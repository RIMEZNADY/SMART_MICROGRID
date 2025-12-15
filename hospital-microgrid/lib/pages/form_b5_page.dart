import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospital_microgrid/services/solar_zone_service.dart';
import 'package:hospital_microgrid/providers/theme_provider.dart';
import 'package:hospital_microgrid/services/establishment_service.dart';
import 'package:hospital_microgrid/utils/establishment_mapper.dart';
import 'package:hospital_microgrid/pages/comprehensive_results_page.dart';
import 'package:hospital_microgrid/utils/navigation_helper.dart';

import 'package:hospital_microgrid/theme/medical_solar_colors.dart';

class FormB5Page extends StatefulWidget {
  final Position position;
  final SolarZone solarZone;
  final double globalBudget;
  final double totalSurface;
  final double solarSurface;
  final int population;
  final String hospitalType;
  final String priorite;
  final double recommendationScore;

  const FormB5Page({
    super.key,
    required this.position,
    required this.solarZone,
    required this.globalBudget,
    required this.totalSurface,
    required this.solarSurface,
    required this.population,
    required this.hospitalType,
    required this.priorite,
    required this.recommendationScore,
  });

  @override
  State<FormB5Page> createState() => _FormB5PageState();
}

class _FormB5PageState extends State<FormB5Page> {
  Map<String, dynamic>? calculations;
  Map<String, dynamic>? economy;
  bool _isLoading = true;
  String? _errorMessage;
  int? _establishmentId;

  @override
  void initState() {
    super.initState();
    _loadBackendData();
  }

  Future<void> _loadBackendData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Créer l'établissement dans le backend
      final request = EstablishmentRequest(
        name: widget.hospitalType,
        type: EstablishmentMapper.mapInstitutionTypeToBackend(widget.hospitalType),
        numberOfBeds: (widget.population / 100).round(),
        latitude: widget.position.latitude,
        longitude: widget.position.longitude,
        irradiationClass: EstablishmentMapper.mapSolarZoneEnumToIrradiationClass(widget.solarZone),
        projectBudgetDh: widget.globalBudget,
        totalAvailableSurfaceM2: widget.totalSurface,
        installableSurfaceM2: widget.solarSurface,
        populationServed: widget.population,
        projectPriority: EstablishmentMapper.mapPrioriteToBackend(widget.priorite),
      );

      final establishment = await EstablishmentService.createEstablishment(request);
      _establishmentId = establishment.id;

      // 2. Charger les recommandations depuis le backend
      final recommendations = await EstablishmentService.getRecommendations(establishment.id);

      // 3. Charger les économies depuis le backend
      final savings = await EstablishmentService.getSavings(establishment.id, electricityPriceDhPerKwh: 1.2);

      // 4. Construire les données pour l'affichage
      calculations = {
        'annualConsumption': savings.annualConsumption,
        'requiredPVPower': recommendations.recommendedPvPower,
        'necessaryPVSurface': recommendations.recommendedPvSurface,
        'autonomyPercentage': recommendations.energyAutonomy,
        'batteryNeed': recommendations.recommendedBatteryCapacity,
      };

      // Calculer le coût d'installation (80% du budget)
      final installationCost = widget.globalBudget * 0.8;
      // Calculer la réduction CO2 (estimation: 0.5 t CO2 par MWh d'énergie solaire)
      final co2Reduction = savings.annualPvProduction * 0.5 / 1000; // Conversion kWh -> MWh

      economy = {
        'installationCost': installationCost,
        'annualSavings': savings.annualSavings,
        'roi': recommendations.roi,
        'co2Reduction': co2Reduction,
      };

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement des données: ${e.toString()}';
      });
    }
  }

  Future<void> _handleFinish() async {
    if (_establishmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez attendre le chargement des données'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to ComprehensiveResultsPage (same as EXISTANT workflow)
    // This ensures consistency: both workflows end at the same results page
    final themeProvider = ThemeProvider();
    NavigationHelper.pushAndRemoveUntil(
      context,
      ComprehensiveResultsPage(
        establishmentId: _establishmentId!,
        themeProvider: themeProvider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Décision Finale'),
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
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Calcul des recommandations...',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                        ),
                      ),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _loadBackendData,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          // Title
                          Text(
                            'Décision Finale',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Section 1: Calculations
                          Text(
                            'Prévisions Techniques',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.bolt,
                            label: 'Consommation annuelle prévue',
                            value: (calculations!['annualConsumption'] as double).toStringAsFixed(0),
                            unit: 'Kwh',
                            color: MedicalSolarColors.medicalBlue,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.solar_power,
                            label: 'Puissance PV requise',
                            value: (calculations!['requiredPVPower'] as double).toStringAsFixed(2),
                            unit: 'kW',
                            color: MedicalSolarColors.solarYellow,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.grid_view,
                            label: 'Surface PV nécessaire',
                            value: (calculations!['necessaryPVSurface'] as double).toStringAsFixed(0),
                            unit: 'm²',
                            color: MedicalSolarColors.solarGreen,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.battery_charging_full,
                            label: 'Autonomie énergétique',
                            value: (calculations!['autonomyPercentage'] as double).toStringAsFixed(1),
                            unit: '%',
                            color: MedicalSolarColors.solarGreen,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.battery_std,
                            label: 'Besoin batterie',
                            value: (calculations!['batteryNeed'] as double).toStringAsFixed(2),
                            unit: 'kWh',
                            color: const Color(0xFF8B5CF6),
                          ),
                          const SizedBox(height: 32),
                          // Section 2: Economy
                          Text(
                            'Économie Prévisionnelle',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.attach_money,
                            label: 'ct d\'installation',
                            value: (economy!['installationCost'] as double).toStringAsFixed(0),
                            unit: 'DH',
                            color: MedicalSolarColors.error,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.savings,
                            label: 'Économie annuelle',
                            value: (economy!['annualSavings'] as double).toStringAsFixed(0),
                            unit: 'DH',
                            color: MedicalSolarColors.solarGreen,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.trending_up,
                            label: 'ROI en années',
                            value: (economy!['roi'] as double).toStringAsFixed(1),
                            unit: 'ans',
                            color: MedicalSolarColors.medicalBlue,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            context: context,
                            isDark: isDark,
                            icon: Icons.eco,
                            label: 'Réduction CO2',
                            value: (economy!['co2Reduction'] as double).toStringAsFixed(2),
                            unit: 't/an',
                            color: MedicalSolarColors.solarGreen,
                          ),
                          const SizedBox(height: 40),
                          // Finish Button
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
                                onTap: _handleFinish,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  child: Text(
                                    'Finaliser',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? MedicalSolarColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withOpacity(0.9)
                        : MedicalSolarColors.softGrey.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                    ),
                    children: [
                      TextSpan(text: value),
                      const TextSpan(
                        text: ' ',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextSpan(
                        text: unit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : MedicalSolarColors.softGrey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}