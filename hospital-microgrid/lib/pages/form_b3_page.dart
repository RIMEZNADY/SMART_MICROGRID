import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospital_microgrid/services/solar_zone_service.dart';
import 'package:hospital_microgrid/pages/form_b4_page.dart';
import 'package:hospital_microgrid/widgets/hierarchical_type_selector.dart';

import 'package:hospital_microgrid/theme/medical_solar_colors.dart';

class FormB3Page extends StatefulWidget {
  final Position position;
  final SolarZone solarZone;
  final double globalBudget;
  final double totalSurface;
  final double solarSurface;
  final int population;

  const FormB3Page({
    super.key,
    required this.position,
    required this.solarZone,
    required this.globalBudget,
    required this.totalSurface,
    required this.solarSurface,
    required this.population,
  });

  @override
  State<FormB3Page> createState() => _FormB3PageState();
}

class _FormB3PageState extends State<FormB3Page> {
  String? _selectedHospitalTypeBackend; // Valeur backend (ex: 'CHU', 'HOPITAL_REGIONAL')
  String? _selectedPriorite;

  final List<String> _priorites = [
    'Haute - Production maximale d\'énergie',
    'Moyenne - Équilibre coût/efficacité',
    'Basse - ct minimal',
  ];

  void _handleNext() {
    if (_selectedHospitalTypeBackend == null || _selectedPriorite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner le type d\'établissement et la priorité'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Convertir la valeur backend en nom d'affichage pour FormB4Page
    final hospitalTypeDisplay = _getDisplayNameFromBackend(_selectedHospitalTypeBackend!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormB4Page(
          position: widget.position,
          solarZone: widget.solarZone,
          globalBudget: widget.globalBudget,
          totalSurface: widget.totalSurface,
          solarSurface: widget.solarSurface,
          population: widget.population,
          hospitalType: hospitalTypeDisplay,
          priorite: _selectedPriorite!,
        ),
      ),
    );
  }

  String _getDisplayNameFromBackend(String backendValue) {
    // Mapper les valeurs backend vers les noms d'affichage
    switch (backendValue) {
      case 'CHU':
        return 'CHU (Centre Hospitalier Universitaire)';
      case 'HOPITAL_REGIONAL':
        return 'Hôpital Régional';
      case 'HOPITAL_PROVINCIAL':
        return 'Hôpital Provincial';
      case 'HOPITAL_PREFECTORAL':
        return 'Hôpital Préfectoral';
      case 'HOPITAL_SPECIALISE':
        return 'Hôpital Spécialisé';
      case 'CENTRE_REGIONAL_ONCOLOGIE':
        return 'Centre Régional d\'Oncologie';
      case 'CENTRE_HEMODIALYSE':
        return 'Centre d\'Hémodialyse';
      case 'CENTRE_REEDUCATION':
        return 'Centre de Rééducation';
      case 'CENTRE_ADDICTOLOGIE':
        return 'Centre d\'Addictologie';
      case 'UMH':
        return 'UMH (Urgences Médico-Hospitalières)';
      case 'UMP':
        return 'UMP (Urgences Médicales de Proximité)';
      case 'UPH':
        return 'UPH (Urgences Pré-Hospitalières)';
      case 'CENTRE_SANTE_PRIMAIRE':
        return 'Centre de Santé Primaire';
      case 'CLINIQUE_PRIVEE':
        return 'Clinique Privée';
      case 'AUTRE':
        return 'Autre';
      default:
        return backendValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objectif & Priorité'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? MedicalSolarColors.softGrey : MedicalSolarColors.offWhite,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  'Objectif et Priorité',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                  ),
                ),
                const SizedBox(height: 32),
                // 1. Objectif (type d'hôpital)
                Text(
                  'Objectif (type d\'hôpital)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withOpacity(0.9)
                        : MedicalSolarColors.softGrey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                HierarchicalTypeSelector(
                  selectedValue: _selectedHospitalTypeBackend,
                  isDark: isDark,
                  onChanged: (String backendValue) {
                    setState(() {
                      _selectedHospitalTypeBackend = backendValue;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // 2. Priorité
                Text(
                  'Priorité',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withOpacity(0.9)
                        : MedicalSolarColors.softGrey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPriorite,
                  decoration: InputDecoration(
                    hintText: 'Sélectionnez la priorité',
                    prefixIcon: const Icon(Icons.priority_high),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: MedicalSolarColors.medicalBlue,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark ? MedicalSolarColors.darkSurface : Colors.white,
                  ),
                  dropdownColor: isDark ? MedicalSolarColors.darkSurface : Colors.white,
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                  ),
                  items: _priorites.map((priorite) {
                    return DropdownMenuItem(
                      value: priorite,
                      child: Text(priorite),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriorite = value;
                    });
                  },
                ),
                const SizedBox(height: 40),
                // Next Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MedicalSolarColors.medicalBlue,
                        MedicalSolarColors.solarGreen,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MedicalSolarColors.medicalBlue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleNext,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Suivant',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}