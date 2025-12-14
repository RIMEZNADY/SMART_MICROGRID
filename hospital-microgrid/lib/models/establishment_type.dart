/// Modèle pour les types d'établissements avec hiérarchie parent-enfant
class EstablishmentTypeModel {
  final String id;
  final String name;
  final String? backendValue; // Valeur pour le backend (null si c'est un parent)
  final List<EstablishmentTypeModel>? children; // Sous-types (null si c'est une feuille)

  EstablishmentTypeModel({
    required this.id,
    required this.name,
    this.backendValue,
    this.children,
  });

  /// Retourne true si ce type a des sous-types
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Retourne true si c'est un type final (feuille)
  bool get isLeaf => backendValue != null;

  /// Structure hiérarchique selon le PDF Institutions_Sante_Maroc_Lois.pdf
  static List<EstablishmentTypeModel> getHierarchicalTypes() {
    return [
      // CHU (Centre Hospitalier Universitaire) - Type parent
      EstablishmentTypeModel(
        id: 'chu',
        name: 'CHU (Centre Hospitalier Universitaire)',
        backendValue: 'CHU',
      ),

      // Hôpitaux - Type parent avec sous-types
      EstablishmentTypeModel(
        id: 'hopitaux',
        name: 'Hôpitaux',
        children: [
          EstablishmentTypeModel(
            id: 'hopital_regional',
            name: 'Hôpital Régional',
            backendValue: 'HOPITAL_REGIONAL',
          ),
          EstablishmentTypeModel(
            id: 'hopital_provincial',
            name: 'Hôpital Provincial',
            backendValue: 'HOPITAL_PROVINCIAL',
          ),
          EstablishmentTypeModel(
            id: 'hopital_prefectoral',
            name: 'Hôpital Préfectoral',
            backendValue: 'HOPITAL_PREFECTORAL',
          ),
          EstablishmentTypeModel(
            id: 'hopital_specialise',
            name: 'Hôpital Spécialisé',
            backendValue: 'HOPITAL_SPECIALISE',
          ),
        ],
      ),

      // Centres de soins spécialisés - Type parent avec sous-types
      EstablishmentTypeModel(
        id: 'centres_specialises',
        name: 'Centres de Soins Spécialisés',
        children: [
          EstablishmentTypeModel(
            id: 'centre_regional_oncologie',
            name: 'Centre Régional d\'Oncologie',
            backendValue: 'CENTRE_REGIONAL_ONCOLOGIE',
          ),
          EstablishmentTypeModel(
            id: 'centre_hemodialyse',
            name: 'Centre d\'Hémodialyse',
            backendValue: 'CENTRE_HEMODIALYSE',
          ),
          EstablishmentTypeModel(
            id: 'centre_reeducation',
            name: 'Centre de Rééducation',
            backendValue: 'CENTRE_REEDUCATION',
          ),
          EstablishmentTypeModel(
            id: 'centre_addictologie',
            name: 'Centre d\'Addictologie',
            backendValue: 'CENTRE_ADDICTOLOGIE',
          ),
        ],
      ),

      // Urgences - Type parent avec sous-types
      EstablishmentTypeModel(
        id: 'urgences',
        name: 'Dispositifs d\'Urgences',
        children: [
          EstablishmentTypeModel(
            id: 'umh',
            name: 'UMH (Urgences Médico-Hospitalières)',
            backendValue: 'UMH',
          ),
          EstablishmentTypeModel(
            id: 'ump',
            name: 'UMP (Urgences Médicales de Proximité)',
            backendValue: 'UMP',
          ),
          EstablishmentTypeModel(
            id: 'uph',
            name: 'UPH (Urgences Pré-Hospitalières)',
            backendValue: 'UPH',
          ),
        ],
      ),

      // Soins primaires
      EstablishmentTypeModel(
        id: 'centre_sante_primaire',
        name: 'Centre de Santé Primaire',
        backendValue: 'CENTRE_SANTE_PRIMAIRE',
      ),

      // Secteur privé
      EstablishmentTypeModel(
        id: 'clinique_privee',
        name: 'Clinique Privée',
        backendValue: 'CLINIQUE_PRIVEE',
      ),

      // Autre (mappé vers CENTRE_SANTE_PRIMAIRE par défaut car AUTRE n'existe pas dans le backend)
      EstablishmentTypeModel(
        id: 'autre',
        name: 'Autre',
        backendValue: 'CENTRE_SANTE_PRIMAIRE', // Fallback car AUTRE n'existe pas dans EstablishmentType enum
      ),
    ];
  }

  /// Trouve un type par sa valeur backend
  static EstablishmentTypeModel? findByBackendValue(String backendValue) {
    for (var type in getHierarchicalTypes()) {
      if (type.backendValue == backendValue) {
        return type;
      }
      if (type.hasChildren) {
        for (var child in type.children!) {
          if (child.backendValue == backendValue) {
            return child;
          }
        }
      }
    }
    return null;
  }
}