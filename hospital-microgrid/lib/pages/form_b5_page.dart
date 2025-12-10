import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospital_microgrid/services/solar_zone_service.dart';
import 'package:hospital_microgrid/main.dart';
import 'package:hospital_microgrid/providers/theme_provider.dart';

class FormB5Page extends StatefulWidget {
  final Position position;
  final SolarZone solarZone;
  final double globalBudget;
  final double totalSurface;
  final double solarSurface;
  final int population;
  final String hospitalType;
  final String priority;
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
    required this.priority,
    required this.recommendationScore,
  });

  @override
  State<FormB5Page> createState() => _FormB5PageState();
}

class _FormB5PageState extends State<FormB5Page> {
  late Map<String, dynamic> calculations;
  late Map<String, dynamic> economy;

  @override
  void initState() {
    super.initState();
    _calculateResults();
  }

  void _calculateResults() {
    // Calculate consumption (estimate based on population and hospital type)
    final baseConsumptionPerPerson = 50; // kWh per person per year
    final hospitalMultiplier = widget.hospitalType.contains('Régional') ? 3.0 : 2.0;
    final annualConsumption = widget.population * baseConsumptionPerPerson * hospitalMultiplier;

    // Calculate required PV power (kW) based on solar surface
    // Assume 200W per m²
    final requiredPVPower = widget.solarSurface * 0.2;

    // Calculate necessary PV surface (m²) - same as available
    final necessaryPVSurface = widget.solarSurface;

    // Calculate energy autonomy (%) based on solar zone
    final autonomyMultiplier = {
      SolarZone.zone1: 0.85,
      SolarZone.zone2: 0.75,
      SolarZone.zone3: 0.65,
      SolarZone.zone4: 0.55,
    };
    final autonomyPercentage = (autonomyMultiplier[widget.solarZone] ?? 0.70) * 100;

    // Calculate battery need (kWh) - enough for 2 days of average consumption
    final dailyConsumption = annualConsumption / 365;
    final batteryNeed = dailyConsumption * 2;

    calculations = {
      'annualConsumption': annualConsumption,
      'requiredPVPower': requiredPVPower,
      'necessaryPVSurface': necessaryPVSurface,
      'autonomyPercentage': autonomyPercentage,
      'batteryNeed': batteryNeed,
    };

    // Calculate economy
    final installationCost = widget.globalBudget * 0.8; // 80% of budget for installation
    final gridPrice = 1.5; // DH per kWh
    final annualSavings = annualConsumption * (autonomyPercentage / 100) * gridPrice;
    final roi = installationCost / annualSavings; // years
    final co2Reduction = annualConsumption * (autonomyPercentage / 100) * 0.5; // tons CO₂

    economy = {
      'installationCost': installationCost,
      'annualSavings': annualSavings,
      'roi': roi,
      'co2Reduction': co2Reduction,
    };
  }

  void _handleFinish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration complétée avec succès!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to dashboard
    final themeProvider = ThemeProvider();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(themeProvider: themeProvider),
      ),
      (route) => false,
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
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 32),
                // Section 1: Calculations
                Text(
                  'Prévisions Techniques',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.bolt,
                  label: 'Consommation annuelle prévue',
                  value: '${(calculations['annualConsumption'] as double).toStringAsFixed(0)}',
                  unit: 'Kwh',
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.solar_power,
                  label: 'Puissance PV requise',
                  value: '${(calculations['requiredPVPower'] as double).toStringAsFixed(2)}',
                  unit: 'kW',
                  color: const Color(0xFFFFD700),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.grid_view,
                  label: 'Surface PV nécessaire',
                  value: '${(calculations['necessaryPVSurface'] as double).toStringAsFixed(0)}',
                  unit: 'm²',
                  color: const Color(0xFF06B6D4),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.battery_charging_full,
                  label: 'Autonomie énergétique',
                  value: '${(calculations['autonomyPercentage'] as double).toStringAsFixed(1)}',
                  unit: '%',
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.battery_std,
                  label: 'Besoin batterie',
                  value: '${(calculations['batteryNeed'] as double).toStringAsFixed(2)}',
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
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.attach_money,
                  label: 'Coût d\'installation',
                  value: '${(economy['installationCost'] as double).toStringAsFixed(0)}',
                  unit: 'DH',
                  color: const Color(0xFFEF4444),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.savings,
                  label: 'Économie annuelle',
                  value: '${(economy['annualSavings'] as double).toStringAsFixed(0)}',
                  unit: 'DH',
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.trending_up,
                  label: 'ROI en années',
                  value: '${(economy['roi'] as double).toStringAsFixed(1)}',
                  unit: 'ans',
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.eco,
                  label: 'Réduction CO₂',
                  value: '${(economy['co2Reduction'] as double).toStringAsFixed(2)}',
                  unit: 't/an',
                  color: const Color(0xFF06B6D4),
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
                        Color(0xFF6366F1),
                        Color(0xFF06B6D4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
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
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
                        : const Color(0xFF0F172A).withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
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
                              : const Color(0xFF0F172A).withOpacity(0.7),
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


