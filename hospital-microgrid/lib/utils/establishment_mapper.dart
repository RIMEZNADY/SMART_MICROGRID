/// Mappe les types d'établissement du frontend vers le backend
class EstablishmentMapper {
 /// Convertit le type d'établissement du frontend vers le format backend
 /// Supporte maintenant tous les types du workflow EXISTANT et NEW
 static String mapInstitutionTypeToBackend(String frontendType) {
 // Les types peuvent être soit des noms d'affichage, soit directement des valeurs backend
 // Si c'est déjà une valeur backend, la retourner telle quelle
 if (frontendType == 'CHU' || frontendType == 'HOPITAL_REGIONAL' || 
     frontendType == 'HOPITAL_PROVINCIAL' || frontendType == 'HOPITAL_GENERAL' ||
     frontendType == 'HOPITAL_SPECIALISE' || frontendType == 'CENTRE_REGIONAL_ONCOLOGIE' ||
     frontendType == 'CENTRE_HEMODIALYSE' || frontendType == 'CENTRE_REEDUCATION' ||
     frontendType == 'CENTRE_ADDICTOLOGIE' || frontendType == 'UMH' ||
     frontendType == 'UMP' || frontendType == 'UPH' ||
     frontendType == 'CENTRE_SANTE_PRIMAIRE' || frontendType == 'CLINIQUE_PRIVEE' ||
     frontendType == 'AUTRE') {
   return frontendType;
 }
 
 // Sinon, mapper depuis les noms d'affichage
 if (frontendType.contains('CHU')) {
   return 'CHU';
 } else if (frontendType.contains('Hôpital Régional')) {
   return 'HOPITAL_REGIONAL';
 } else if (frontendType.contains('Hôpital Provincial')) {
   return 'HOPITAL_PROVINCIAL';
 } else if (frontendType.contains('Hôpital Préfectoral') || frontendType.contains('Hôpital Général')) {
   return 'HOPITAL_PREFECTORAL';
 } else if (frontendType.contains('Hôpital Spécialisé') || frontendType.contains('Hôpital Spcialis')) {
   return 'HOPITAL_SPECIALISE';
 } else if (frontendType.contains('Centre Régional d\'Oncologie') || frontendType.contains('Oncologie')) {
   return 'CENTRE_REGIONAL_ONCOLOGIE';
 } else if (frontendType.contains('Hémodialyse')) {
   return 'CENTRE_HEMODIALYSE';
 } else if (frontendType.contains('Rééducation') || frontendType.contains('Reeducation')) {
   return 'CENTRE_REEDUCATION';
 } else if (frontendType.contains('Addictologie')) {
   return 'CENTRE_ADDICTOLOGIE';
 } else if (frontendType.contains('UMH')) {
   return 'UMH';
 } else if (frontendType.contains('UMP')) {
   return 'UMP';
 } else if (frontendType.contains('UPH')) {
   return 'UPH';
 } else if (frontendType.contains('Centre de Santé Primaire') || frontendType.contains('Centre de Sant')) {
   return 'CENTRE_SANTE_PRIMAIRE';
 } else if (frontendType.contains('Clinique')) {
   return 'CLINIQUE_PRIVEE';
 } else if (frontendType.contains('Autre')) {
   return 'CENTRE_SANTE_PRIMAIRE'; // Fallback car AUTRE n'existe pas dans le backend
 } else {
   return 'CENTRE_SANTE_PRIMAIRE'; // Par défaut
 }
 }
 
 /// Convertit la zone solaire du frontend vers le format backend
 static String? mapSolarZoneToIrradiationClass(String? solarZone) {
 if (solarZone == null) return null;
 
 // SolarZone enum: zone1, zone2, zone3, zone4
 // Backend IrradiationClass: A, B, C, D
 switch (solarZone) {
 case 'zone1':
 return 'A';
 case 'zone2':
 return 'B';
 case 'zone3':
 return 'C';
 case 'zone4':
 return 'D';
 default:
 return 'C'; // Par dfaut (Casablanca)
 }
 }
 
 /// Convertit SolarZone enum vers String pour le backend
 static String? mapSolarZoneEnumToIrradiationClass(dynamic solarZone) {
 if (solarZone == null) return null;
 
 final zoneName = solarZone.toString().replaceFirst('SolarZone.', '');
 return mapSolarZoneToIrradiationClass(zoneName);
 }
 
 /// Convertit le type d'établissement du backend vers le format frontend
 static String mapBackendToInstitutionType(String backendType) {
 switch (backendType) {
 case 'CHU':
 return 'CHU (Centre Hospitalier Universitaire)';
 case 'HOPITAL_REGIONAL':
 case 'HOPITAL_PROVINCIAL':
 return 'Hôpital Gnral';
 case 'HOPITAL_SPECIALISE':
 return 'Hôpital Spcialis';
 case 'CLINIQUE_PRIVEE':
 return 'Clinique';
 case 'CENTRE_SANTE_PRIMAIRE':
 return 'Centre de Sant';
 default:
 return 'Autre';
 }
 }
 
 /// Convertit la Priorité du frontend vers le format backend
 static String? mapPrioriteToBackend(String? frontendPriorite) {
   if (frontendPriorite == null) return null;

   // Les Priorités dans FormB3 sont:
 // 'Haute - Production maximale d\'énergie'
 // 'Moyenne - Équilibre coût/efficacité'
   // 'Basse - Coût minimal'

 if (frontendPriorite.contains('Haute') || frontendPriorite.contains('maximale')) {
 return 'MAXIMIZE_AUTONOMY';
 } else if (frontendPriorite.contains('Moyenne') || frontendPriorite.contains('Équilibre')) {
 return 'OPTIMIZE_ROI';
   } else if (frontendPriorite.contains('Basse') || frontendPriorite.contains('minimal')) {
 return 'MINIMIZE_COST';
 } else {
 return 'OPTIMIZE_ROI'; // Par défaut
 }
 }
}

