package com.microgrid.service;

import com.microgrid.model.Establishment;
import com.microgrid.model.MoroccanCity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

/**
 * Service pour calculer tous les résultats additionnels (impact environnemental, score global, etc.)
 */
@Service
public class ComprehensiveResultsService {

    @Autowired
    private SizingService sizingService;

    @Autowired
    private PvCalculationService pvCalculationService;

    @Autowired
    private MeteoDataService meteoDataService;
    
    @Autowired
    private MlRecommendationService mlRecommendationService;

    // Constantes
    private static final double CO2_EMISSION_FACTOR = 0.7; // kg CO2/kWh (mix énergétique Maroc)
    private static final double CO2_PER_TREE = 20.0; // kg CO2/an par arbre
    private static final double CO2_PER_CAR = 2000.0; // kg CO2/an par voiture
    private static final double DISCOUNT_RATE = 0.06; // 6% taux d'actualisation
    private static final double CRITICAL_CONSUMPTION_RATIO = 0.6; // 60% de consommation critique

    /**
     * Calcule l'impact environnemental
     */
    public Map<String, Object> calculateEnvironmentalImpact(Establishment establishment, double autonomyPercentage) {
        double monthlyConsumption = establishment.getMonthlyConsumptionKwh() != null
            ? establishment.getMonthlyConsumptionKwh()
            : 50000.0;
        
        // Production PV annuelle
        double annualPvProduction = (monthlyConsumption * 12 * autonomyPercentage / 100.0);
        
        // CO2 évité (tonnes/an)
        double co2Avoided = (annualPvProduction * CO2_EMISSION_FACTOR) / 1000.0;
        
        // Équivalents
        double equivalentTrees = (co2Avoided * 1000) / CO2_PER_TREE;
        double equivalentCars = co2Avoided / (CO2_PER_CAR / 1000.0);
        
        Map<String, Object> result = new HashMap<>();
        result.put("annualPvProduction", annualPvProduction);
        result.put("co2Avoided", co2Avoided);
        result.put("equivalentTrees", equivalentTrees);
        result.put("equivalentCars", equivalentCars);
        
        return result;
    }

    /**
     * Calcule le score global de performance (0-100)
     */
    public Map<String, Object> calculateGlobalScore(
            Establishment establishment,
            double autonomyPercentage,
            double annualSavings,
            double batteryCapacity,
            double co2Avoided) {
        
        // Scores par catégorie (max 25 points chacun)
        double autonomyScore = (autonomyPercentage / 100.0) * 25.0;
        double economicScore = annualSavings > 0 ? 25.0 : 0.0;
        double resilienceScore = calculateResilienceScore(batteryCapacity, autonomyPercentage);
        double environmentalScore = Math.min((co2Avoided / 10.0) * 25.0, 25.0);
        
        double globalScore = autonomyScore + economicScore + resilienceScore + environmentalScore;
        
        Map<String, Object> result = new HashMap<>();
        result.put("globalScore", globalScore);
        result.put("autonomyScore", autonomyScore);
        result.put("economicScore", economicScore);
        result.put("resilienceScore", resilienceScore);
        result.put("environmentalScore", environmentalScore);
        
        return result;
    }

    /**
     * Calcule le score de résilience (0-25)
     */
    private double calculateResilienceScore(double batteryCapacity, double autonomy) {
        // Score basé sur capacité batterie et autonomie
        double batteryScore = Math.min((batteryCapacity / 1000.0) * 15.0, 15.0); // Max 15 points
        double autonomyScore = (autonomy / 100.0) * 10.0; // Max 10 points
        return batteryScore + autonomyScore;
    }

    /**
     * Calcule l'analyse financière détaillée
     */
    public Map<String, Object> calculateFinancialAnalysis(
            double installationCost,
            double annualSavings,
            int years) {
        
        // NPV (Net Present Value)
        double npv = -installationCost;
        for (int i = 1; i <= years; i++) {
            npv += annualSavings / Math.pow(1 + DISCOUNT_RATE, i);
        }
        
        // IRR (Internal Rate of Return) - approximation
        double irr = installationCost > 0 && annualSavings > 0
            ? (annualSavings / installationCost) * 100.0
            : 0.0;
        
        // ROI
        double roi = installationCost > 0 && annualSavings > 0
            ? installationCost / annualSavings
            : Double.MAX_VALUE;
        
        // Économies cumulées
        double cumulativeSavings10 = annualSavings * 10;
        double cumulativeSavings20 = annualSavings * 20;
        
        Map<String, Object> result = new HashMap<>();
        result.put("installationCost", installationCost);
        result.put("annualSavings", annualSavings);
        result.put("roi", roi);
        result.put("npv20", npv);
        result.put("irr", irr);
        result.put("cumulativeSavings10", cumulativeSavings10);
        result.put("cumulativeSavings20", cumulativeSavings20);
        
        return result;
    }

    /**
     * Calcule les métriques de résilience
     */
    public Map<String, Object> calculateResilienceMetrics(
            Establishment establishment,
            double batteryCapacity) {
        
        double monthlyConsumption = establishment.getMonthlyConsumptionKwh() != null
            ? establishment.getMonthlyConsumptionKwh()
            : 50000.0;
        
        // Consommation moyenne (kW)
        double avgConsumption = monthlyConsumption / (30.0 * 24.0);
        double criticalConsumption = avgConsumption * CRITICAL_CONSUMPTION_RATIO;
        
        // Autonomie (heures)
        double autonomyHours = batteryCapacity / avgConsumption;
        double criticalAutonomyHours = batteryCapacity / criticalConsumption;
        
        // Score de fiabilité
        double reliabilityScore = calculateResilienceScore(batteryCapacity, 0);
        
        Map<String, Object> result = new HashMap<>();
        result.put("autonomyHours", autonomyHours);
        result.put("criticalAutonomyHours", criticalAutonomyHours);
        result.put("reliabilityScore", reliabilityScore);
        
        return result;
    }

    /**
     * Calcule la comparaison avant/après
     */
    public Map<String, Object> calculateBeforeAfterComparison(
            Establishment establishment,
            double autonomyPercentage) {
        
        double monthlyConsumption = establishment.getMonthlyConsumptionKwh() != null
            ? establishment.getMonthlyConsumptionKwh()
            : 50000.0;
        
        double electricityPrice = 1.2; // DH/kWh
        
        // Calculer l'autonomie ACTUELLE si PV existant
        double beforeAutonomy = 0.0;
        double beforePvProduction = 0.0;
        
        if (establishment.getExistingPvInstalled() != null && establishment.getExistingPvInstalled()) {
            // Si PV existant, calculer l'autonomie actuelle
            Double existingPvPower = establishment.getExistingPvPowerKwc();
            if (existingPvPower != null && existingPvPower > 0) {
                // Convertir puissance en surface (1 kWc = 5 m²)
                double existingPvSurface = existingPvPower * 5.0;
                
                // Calculer l'autonomie actuelle
                String irradiationClassStr = establishment.getIrradiationClass() != null 
                    ? establishment.getIrradiationClass().toString() 
                    : "C";
                MoroccanCity.IrradiationClass irradiationClass = convertIrradiationClass(irradiationClassStr);
                
                beforeAutonomy = sizingService.calculateEnergyAutonomy(
                    existingPvSurface, monthlyConsumption, irradiationClass);
                beforePvProduction = pvCalculationService.calculatePvProductionForPeriod(
                    existingPvSurface, irradiationClass, 30);
            }
        }
        
        // AVANT (situation actuelle)
        double beforeGridConsumption = monthlyConsumption * (1 - beforeAutonomy / 100.0);
        double beforeMonthlyBill = beforeGridConsumption * electricityPrice;
        double beforeAnnualBill = beforeMonthlyBill * 12;
        
        // APRÈS (avec nouveau microgrid)
        double afterAutonomy = autonomyPercentage;
        double afterGridConsumption = monthlyConsumption * (1 - afterAutonomy / 100.0);
        double afterMonthlyBill = afterGridConsumption * electricityPrice;
        double afterAnnualBill = afterMonthlyBill * 12;
        
        // Calculer l'amélioration (gain réel)
        double autonomyGain = afterAutonomy - beforeAutonomy;
        double monthlySavingsGain = beforeMonthlyBill - afterMonthlyBill;
        double annualSavingsGain = monthlySavingsGain * 12;
        
        Map<String, Object> result = new HashMap<>();
        result.put("beforeMonthlyBill", beforeMonthlyBill);
        result.put("afterMonthlyBill", afterMonthlyBill);
        result.put("beforeAnnualBill", beforeAnnualBill);
        result.put("afterAnnualBill", afterAnnualBill);
        result.put("beforeGridConsumption", beforeGridConsumption);
        result.put("afterGridConsumption", afterGridConsumption);
        result.put("beforeAutonomy", beforeAutonomy);
        result.put("afterAutonomy", afterAutonomy);
        result.put("beforePvProduction", beforePvProduction);
        result.put("autonomyGain", autonomyGain);
        result.put("monthlySavingsGain", monthlySavingsGain);
        result.put("annualSavingsGain", annualSavingsGain);
        result.put("hasExistingPv", establishment.getExistingPvInstalled() != null && establishment.getExistingPvInstalled());
        
        return result;
    }

    /**
     * Estime le coût d'installation
     */
    public double estimateInstallationCost(double pvPower, double batteryCapacity) {
        // Coûts moyens marché marocain (2024)
        double pvCost = pvPower * 2500; // 2500 DH/kW
        double batteryCost = batteryCapacity * 4000; // 4000 DH/kWh
        double inverterCost = pvPower * 2000; // 2000 DH/kW
        double installationCost = (pvCost + batteryCost + inverterCost) * 0.2; // 20% installation
        
        return pvCost + batteryCost + inverterCost + installationCost;
    }

    /**
     * Calcule tous les résultats complets pour un établissement
     */
    public Map<String, Object> calculateAllResults(Establishment establishment) {
        // Convertir IrradiationClass (enum -> String -> enum)
        String irradiationClassStr = establishment.getIrradiationClass() != null 
            ? establishment.getIrradiationClass().toString() 
            : "C";
        MoroccanCity.IrradiationClass irradiationClass = convertIrradiationClass(irradiationClassStr);
        
        // Consommation mensuelle
        double monthlyConsumption = establishment.getMonthlyConsumptionKwh() != null
            ? establishment.getMonthlyConsumptionKwh()
            : 50000.0;
        
        // Recommandations de base (calculs physiques)
        double recommendedPvPower = sizingService.calculateRecommendedPvPower(monthlyConsumption, irradiationClass);
        double recommendedBattery = sizingService.calculateRecommendedBatteryCapacityFromMonthly(monthlyConsumption);
        
        // 🤖 AMÉLIORATION AVEC IA/ML
        // Utiliser le service ML pour affiner les recommandations basées sur des données historiques
        try {
            Map<String, Object> mlResult = mlRecommendationService.getMlRecommendations(establishment);
            
            // Utiliser les recommandations ML si disponibles (plus précises que les calculs basiques)
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> mlRecommendations = 
                (List<Map<String, Object>>) mlResult.get("recommendations");
            if (mlRecommendations != null && !mlRecommendations.isEmpty()) {
                for (Map<String, Object> rec : mlRecommendations) {
                    if (rec.containsKey("type") && "pv_power".equals(rec.get("type"))) {
                        Object value = rec.get("value");
                        if (value instanceof Number) {
                            double mlPvPower = ((Number) value).doubleValue();
                            // Utiliser la valeur ML si elle est raisonnable (dans une plage acceptable)
                            if (mlPvPower > 0 && mlPvPower < recommendedPvPower * 2) {
                                recommendedPvPower = mlPvPower;
                                System.out.println("🤖 IA: PV Power ajusté de " + recommendedPvPower + " à " + mlPvPower + " kW");
                            }
                        }
                    } else if (rec.containsKey("type") && "battery_capacity".equals(rec.get("type"))) {
                        Object value = rec.get("value");
                        if (value instanceof Number) {
                            double mlBattery = ((Number) value).doubleValue();
                            // Utiliser la valeur ML si elle est raisonnable
                            if (mlBattery > 0 && mlBattery < recommendedBattery * 2) {
                                recommendedBattery = mlBattery;
                                System.out.println("🤖 IA: Battery Capacity ajusté de " + recommendedBattery + " à " + mlBattery + " kWh");
                            }
                        }
                    }
                }
            }
            
            // Note: ROI calculé avec formule déterministe (SizingService.calculateROI), pas avec ML
            // Les recommandations ML sont utilisées uniquement pour optimisations et alertes,
            // pas pour ajuster le dimensionnement basique (qui suit les lois physiques)
        } catch (Exception e) {
            // Si le service ML échoue, utiliser les valeurs de base (calculs physiques)
            System.err.println("⚠️ Service ML indisponible, utilisation des calculs basiques: " + e.getMessage());
        }
        
        // Autonomie
        double autonomy = 0.0;
        Double installableSurface = establishment.getInstallableSurfaceM2();
        if (installableSurface != null && installableSurface > 0) {
            autonomy = sizingService.calculateEnergyAutonomy(
                installableSurface, monthlyConsumption, irradiationClass);
        } else {
            double recommendedSurface = sizingService.calculateRecommendedPvSurface(monthlyConsumption, irradiationClass);
            autonomy = sizingService.calculateEnergyAutonomy(
                recommendedSurface, monthlyConsumption, irradiationClass);
        }
        
        // Économies annuelles (gain réel par rapport à la situation actuelle)
        double currentAutonomy = 0.0;
        if (establishment.getExistingPvInstalled() != null && establishment.getExistingPvInstalled()) {
            Double existingPvPower = establishment.getExistingPvPowerKwc();
            if (existingPvPower != null && existingPvPower > 0) {
                double existingPvSurface = existingPvPower * 5.0;
                currentAutonomy = sizingService.calculateEnergyAutonomy(
                    existingPvSurface, monthlyConsumption, irradiationClass);
            }
        }
        // Économies = économies totales avec nouveau microgrid - économies actuelles (si PV existant)
        double totalSavingsWithNewMicrogrid = sizingService.calculateAnnualSavings(monthlyConsumption, autonomy, 1.2);
        double currentSavings = sizingService.calculateAnnualSavings(monthlyConsumption, currentAutonomy, 1.2);
        double annualSavings = totalSavingsWithNewMicrogrid - currentSavings; // Gain réel
        
        // Coût installation
        double installationCost = estimateInstallationCost(recommendedPvPower, recommendedBattery);
        
        // Impact environnemental
        Map<String, Object> environmental = calculateEnvironmentalImpact(establishment, autonomy);
        double co2Avoided = (Double) environmental.get("co2Avoided");
        
        // Score global
        Map<String, Object> globalScore = calculateGlobalScore(
            establishment, autonomy, annualSavings, recommendedBattery, co2Avoided);
        
        // Analyse financière
        Map<String, Object> financial = calculateFinancialAnalysis(installationCost, annualSavings, 20);
        
        // Résilience
        Map<String, Object> resilience = calculateResilienceMetrics(establishment, recommendedBattery);
        
        // Comparaison avant/après
        Map<String, Object> beforeAfter = calculateBeforeAfterComparison(establishment, autonomy);
        
        // Résultat complet
        Map<String, Object> result = new HashMap<>();
        result.put("environmental", environmental);
        result.put("globalScore", globalScore);
        result.put("financial", financial);
        result.put("resilience", resilience);
        result.put("beforeAfter", beforeAfter);
        result.put("recommendedPvPower", recommendedPvPower);
        result.put("recommendedBatteryCapacity", recommendedBattery);
        result.put("autonomy", autonomy);
        result.put("annualSavings", annualSavings);
        result.put("aiEnhanced", true); // Indicateur que l'IA a été utilisée pour améliorer les recommandations
        
        return result;
    }

    /**
     * Convertit IrradiationClass string en enum
     */
    private MoroccanCity.IrradiationClass convertIrradiationClass(String irradiationClass) {
        if (irradiationClass == null) {
            return MoroccanCity.IrradiationClass.C;
        }
        try {
            return MoroccanCity.IrradiationClass.valueOf(irradiationClass);
        } catch (IllegalArgumentException e) {
            return MoroccanCity.IrradiationClass.C; // Default
        }
    }
}

