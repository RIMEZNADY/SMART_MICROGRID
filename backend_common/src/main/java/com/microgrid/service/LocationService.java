package com.microgrid.service;

import com.microgrid.model.Establishment.IrradiationClass;
import com.microgrid.model.MoroccanCity;
import com.microgrid.repository.MoroccanCityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class LocationService {
    
    @Autowired
    private MoroccanCityRepository cityRepository;
    
    /**
     * Détermine la classe d'irradiation solaire selon les coordonnées GPS
     * en trouvant la ville marocaine la plus proche
     */
    public IrradiationClass determineIrradiationClass(Double latitude, Double longitude) {
        if (latitude == null || longitude == null) {
            return IrradiationClass.C; // Par défaut (Casablanca)
        }
        
        Optional<MoroccanCity> nearestCity = cityRepository.findNearestCity(latitude, longitude);
        
        if (nearestCity.isPresent()) {
            // Convertir l'enum de MoroccanCity vers Establishment
            return convertIrradiationClass(nearestCity.get().getIrradiationClass());
        }
        
        // Si aucune ville trouvée, déterminer selon les coordonnées
        return determineIrradiationByCoordinates(latitude, longitude);
    }
    
    /**
     * Convertit l'enum IrradiationClass de MoroccanCity vers Establishment
     */
    private IrradiationClass convertIrradiationClass(MoroccanCity.IrradiationClass cityClass) {
        return switch (cityClass) {
            case A -> IrradiationClass.A;
            case B -> IrradiationClass.B;
            case C -> IrradiationClass.C;
            case D -> IrradiationClass.D;
        };
    }
    
    /**
     * Détermine la classe d'irradiation selon les coordonnées GPS
     * (méthode de fallback si aucune ville n'est trouvée)
     */
    private IrradiationClass determineIrradiationByCoordinates(Double latitude, Double longitude) {
        // Zone A: Sud-Est et Sahara (latitude < 30°)
        if (latitude < 30.0) {
            return IrradiationClass.A;
        }
        // Zone B: Centre et Sud (30° - 32°)
        else if (latitude < 32.0) {
            return IrradiationClass.B;
        }
        // Zone C: Nord et Côtes (32° - 34°)
        else if (latitude < 34.0) {
            return IrradiationClass.C;
        }
        // Zone D: Rif et Hautes altitudes (latitude >= 34°)
        else {
            return IrradiationClass.D;
        }
    }
    
    /**
     * Obtient la ville la plus proche d'un point GPS
     */
    public Optional<MoroccanCity> getNearestCity(Double latitude, Double longitude) {
        if (latitude == null || longitude == null) {
            return Optional.empty();
        }
        return cityRepository.findNearestCity(latitude, longitude);
    }
    
    /**
     * Estime la population environnante basée sur la localisation et le type d'établissement
     * 
     * @param latitude Latitude GPS
     * @param longitude Longitude GPS
     * @param establishmentType Type d'établissement (CHU, HOPITAL_REGIONAL, etc.)
     * @param numberOfBeds Nombre de lits (optionnel, pour affiner l'estimation)
     * @return Estimation de la population environnante
     */
    public Integer estimatePopulation(Double latitude, Double longitude, 
                                     String establishmentType, Integer numberOfBeds) {
        if (latitude == null || longitude == null) {
            return 50000; // Valeur par défaut
        }
        
        Optional<MoroccanCity> nearestCity = cityRepository.findNearestCity(latitude, longitude);
        
        // Estimation basée sur la classe d'irradiation (corrélée avec la taille de la ville)
        // Zone A/B = grandes villes (Casablanca, Marrakech, Agadir)
        // Zone C = villes moyennes (Rabat, Fès, Tanger)
        // Zone D = petites villes/rural
        IrradiationClass irradiationClass = determineIrradiationClass(latitude, longitude);
        
        int basePopulation;
        switch (irradiationClass) {
            case A, B -> basePopulation = 800000; // Grandes villes (Sud)
            case C -> basePopulation = 500000;    // Villes moyennes (Nord/Côtes)
            case D -> basePopulation = 100000;    // Petites villes/rural
        }
        
        // Ajustement selon le type d'établissement
        double typeMultiplier = switch (establishmentType) {
            case "CHU" -> 1.5;              // CHU = grande métropole
            case "HOPITAL_REGIONAL" -> 1.2; // Hôpital régional = grande ville
            case "HOPITAL_PREFECTORAL", "HOPITAL_PROVINCIAL", "HOPITAL_GENERAL" -> 1.0; // Ville moyenne
            case "HOPITAL_SPECIALISE" -> 1.1; // Hôpital spécialisé = grande ville
            case "CENTRE_REGIONAL_ONCOLOGIE", "CENTRE_HEMODIALYSE" -> 1.0; // Centre spécialisé = ville moyenne
            case "CENTRE_REEDUCATION", "CENTRE_ADDICTOLOGIE", "CENTRE_SOINS_PALLIATIFS" -> 0.8; // Centre médico-social
            case "UMH", "UMP", "UPH" -> 0.7; // Urgences = petite/moyenne ville
            case "CENTRE_SANTE_PRIMAIRE" -> 0.5; // Petite ville/commune
            case "CLINIQUE_PRIVEE" -> 0.9; // Clinique privée = ville moyenne
            default -> 1.0; // Par défaut pour "AUTRE" ou types non reconnus
        };
        
        // Ajustement selon le nombre de lits (si disponible)
        if (numberOfBeds != null && numberOfBeds > 0) {
            // Estimation : 1 lit = ~100-200 habitants servis
            // Si beaucoup de lits, c'est une grande ville
            if (numberOfBeds > 500) {
                typeMultiplier = Math.max(typeMultiplier, 1.5);
            } else if (numberOfBeds > 200) {
                typeMultiplier = Math.max(typeMultiplier, 1.2);
            } else if (numberOfBeds < 50) {
                typeMultiplier = Math.min(typeMultiplier, 0.7);
            }
        }
        
        int estimatedPopulation = (int) (basePopulation * typeMultiplier);
        
        // Limiter entre 10,000 et 3,000,000 (plage raisonnable pour le Maroc)
        return Math.max(10000, Math.min(3000000, estimatedPopulation));
    }
}


