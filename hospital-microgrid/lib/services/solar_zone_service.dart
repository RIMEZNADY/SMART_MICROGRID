
/// Zones solaires du Maroc selon le rayonnement solaire
enum SolarZone {
  zone1, // Zone à très fort rayonnement (Sud-Est, Sahara)
  zone2, // Zone à fort rayonnement (Centre, Sud)
  zone3, // Zone à rayonnement moyen (Nord, Côtes)
  zone4, // Zone à rayonnement modéré (Rif, Hautes altitudes)
}

class SolarZoneService {
  /// Détermine la zone solaire selon les coordonnées GPS
  static SolarZone getSolarZoneFromLocation(double latitude, double longitude) {
    // Division du Maroc en zones selon le rayonnement solaire
    
    // Zone 1: Régions du Sud-Est et Sahara (très fort rayonnement)
    // Latitude: 27°N - 32°N, Longitude: -4°W - 12°W
    if (latitude >= 27.0 && latitude <= 32.0 && 
        longitude >= -12.0 && longitude <= -4.0) {
      // Vérifier si c'est vraiment dans le Sahara/Sud-Est
      if (latitude >= 28.0 && longitude >= -9.0) {
        return SolarZone.zone1; // Sahara, Ouarzazate, Errachidia
      }
    }

    // Zone 2: Centre et Sud du Maroc (fort rayonnement)
    // Latitude: 30°N - 33°N, Longitude: -8°W - -4°W
    if (latitude >= 30.0 && latitude <= 33.0 && 
        longitude >= -8.0 && longitude <= -4.0) {
      return SolarZone.zone2; // Marrakech, Agadir, Casablanca, Rabat
    }

    // Zone 3: Nord et Côtes (rayonnement moyen)
    // Latitude: 33°N - 36°N, Longitude: -6°W - -1°W
    if (latitude >= 33.0 && latitude <= 36.0 && 
        longitude >= -6.0 && longitude <= -1.0) {
      return SolarZone.zone3; // Tanger, Tétouan, Fès, Meknès
    }

    // Zone 4: Rif et Hautes altitudes (rayonnement modéré)
    // Latitude: 34°N - 36°N, Longitude: -6°W - -3°W
    if (latitude >= 34.0 && latitude <= 36.0 && 
        longitude >= -6.0 && longitude <= -3.0) {
      // Vérifier les régions montagneuses
      if (latitude >= 34.5) {
        return SolarZone.zone4; // Rif, Moyen Atlas
      }
    }

    // Par défaut, assigner selon la latitude
    if (latitude < 30.0) {
      return SolarZone.zone1; // Sud
    } else if (latitude < 32.0) {
      return SolarZone.zone2; // Centre
    } else if (latitude < 34.0) {
      return SolarZone.zone3; // Nord
    } else {
      return SolarZone.zone4; // Rif
    }
  }

  /// Obtient le nom de la zone
  static String getZoneName(SolarZone zone) {
    switch (zone) {
      case SolarZone.zone1:
        return 'Zone 1 - Très Fort Rayonnement';
      case SolarZone.zone2:
        return 'Zone 2 - Fort Rayonnement';
      case SolarZone.zone3:
        return 'Zone 3 - Rayonnement Moyen';
      case SolarZone.zone4:
        return 'Zone 4 - Rayonnement Modéré';
    }
  }

  /// Obtient la description de la zone
  static String getZoneDescription(SolarZone zone) {
    switch (zone) {
      case SolarZone.zone1:
        return 'Régions du Sud-Est et Sahara\nRayonnement solaire: 6-7 kWh/m²/jour';
      case SolarZone.zone2:
        return 'Centre et Sud du Maroc\nRayonnement solaire: 5-6 kWh/m²/jour';
      case SolarZone.zone3:
        return 'Nord et Côtes\nRayonnement solaire: 4-5 kWh/m²/jour';
      case SolarZone.zone4:
        return 'Rif et Hautes Altitudes\nRayonnement solaire: 3-4 kWh/m²/jour';
    }
  }

  /// Obtient la couleur de la zone
  static int getZoneColor(SolarZone zone) {
    switch (zone) {
      case SolarZone.zone1:
        return 0xFFFF6B35; // Orange vif
      case SolarZone.zone2:
        return 0xFFFFA726; // Orange
      case SolarZone.zone3:
        return 0xFFFFD54F; // Jaune
      case SolarZone.zone4:
        return 0xFF90CAF9; // Bleu clair
    }
  }
}


