import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospital_microgrid/main.dart';
import 'package:hospital_microgrid/providers/theme_provider.dart';

class FormA5Page extends StatefulWidget {
  final String institutionType;
  final String institutionName;
  final Position location;
  final int numberOfBeds;
  final double solarSurface;
  final double nonCriticalSurface;
  final double monthlyConsumption;
  final double recommendedPVPower;
  final double recommendedBatteryCapacity;

  const FormA5Page({
    super.key,
    required this.institutionType,
    required this.institutionName,
    required this.location,
    required this.numberOfBeds,
    required this.solarSurface,
    required this.nonCriticalSurface,
    required this.monthlyConsumption,
    required this.recommendedPVPower,
    required this.recommendedBatteryCapacity,
  });

  @override
  State<FormA5Page> createState() => _FormA5PageState();
}

class _FormA5PageState extends State<FormA5Page> {
  String? _selectedPanel;
  String? _selectedBattery;
  String? _selectedInverter;
  String? _selectedController;

  final List<Map<String, String>> _solarPanels = [
    {'id': 'panel1', 'name': 'Panneau Solaire Monocristallin 400W', 'price': '850', 'efficiency': '21.5%'},
    {'id': 'panel2', 'name': 'Panneau Solaire Polycristallin 380W', 'price': '720', 'efficiency': '19.2%'},
    {'id': 'panel3', 'name': 'Panneau Solaire Bifacial 450W', 'price': '1100', 'efficiency': '22.8%'},
    {'id': 'panel4', 'name': 'Panneau Solaire PERC 410W', 'price': '950', 'efficiency': '21.8%'},
  ];

  final List<Map<String, String>> _batteries = [
    {'id': 'battery1', 'name': 'Batterie Lithium-ion 10kWh', 'price': '45000', 'cycles': '6000'},
    {'id': 'battery2', 'name': 'Batterie Lithium-ion 15kWh', 'price': '65000', 'cycles': '6000'},
    {'id': 'battery3', 'name': 'Batterie Lithium Fer Phosphate 12kWh', 'price': '52000', 'cycles': '8000'},
    {'id': 'battery4', 'name': 'Batterie AGM 20kWh', 'price': '38000', 'cycles': '1500'},
  ];

  final List<Map<String, String>> _inverters = [
    {'id': 'inv1', 'name': 'Onduleur Hybride 5kW', 'price': '12000', 'type': 'Hybride'},
    {'id': 'inv2', 'name': 'Onduleur Hybride 10kW', 'price': '22000', 'type': 'Hybride'},
    {'id': 'inv3', 'name': 'Onduleur Grid-Tie 8kW', 'price': '15000', 'type': 'Grid-Tie'},
    {'id': 'inv4', 'name': 'Onduleur Hybride 15kW', 'price': '32000', 'type': 'Hybride'},
  ];

  final List<Map<String, String>> _controllers = [
    {'id': 'ctrl1', 'name': 'Régulateur MPPT 60A', 'price': '3500', 'type': 'MPPT'},
    {'id': 'ctrl2', 'name': 'Régulateur MPPT 80A', 'price': '4800', 'type': 'MPPT'},
    {'id': 'ctrl3', 'name': 'Régulateur MPPT 100A', 'price': '6200', 'type': 'MPPT'},
    {'id': 'ctrl4', 'name': 'Régulateur PWM 50A', 'price': '1800', 'type': 'PWM'},
  ];

  void _handleFinish() {
    if (_selectedPanel == null || _selectedBattery == null || _selectedInverter == null || _selectedController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner tous les équipements'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
        title: const Text('Sélection des Équipements'),
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
                  'Choisissez vos équipements',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sélectionnez les équipements recommandés pour votre installation',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : const Color(0xFF0F172A).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                // Recommended Power Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.info_outline, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommandations',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PV: ${widget.recommendedPVPower.toStringAsFixed(2)} kW | Batterie: ${widget.recommendedBatteryCapacity.toStringAsFixed(2)} kWh',
                              style: GoogleFonts.inter(
                                fontSize: 14,
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
                const SizedBox(height: 32),
                // 1. Panneaux Solaires
                _buildSectionTitle('Panneaux Solaires', Icons.solar_power, isDark),
                const SizedBox(height: 16),
                ..._solarPanels.map((panel) => _buildEquipmentCard(
                      context: context,
                      isDark: isDark,
                      isMobile: isMobile,
                      id: panel['id']!,
                      name: panel['name']!,
                      details: 'Efficacité: ${panel['efficiency']}',
                      price: panel['price']!,
                      isSelected: _selectedPanel == panel['id'],
                      onTap: () {
                        setState(() {
                          _selectedPanel = panel['id'];
                        });
                      },
                    )),
                const SizedBox(height: 32),
                // 2. Batteries
                _buildSectionTitle('Batteries', Icons.battery_std, isDark),
                const SizedBox(height: 16),
                ..._batteries.map((battery) => _buildEquipmentCard(
                      context: context,
                      isDark: isDark,
                      isMobile: isMobile,
                      id: battery['id']!,
                      name: battery['name']!,
                      details: 'Cycles: ${battery['cycles']}',
                      price: battery['price']!,
                      isSelected: _selectedBattery == battery['id'],
                      onTap: () {
                        setState(() {
                          _selectedBattery = battery['id'];
                        });
                      },
                    )),
                const SizedBox(height: 32),
                // 3. Onduleurs
                _buildSectionTitle('Onduleurs', Icons.bolt, isDark),
                const SizedBox(height: 16),
                ..._inverters.map((inverter) => _buildEquipmentCard(
                      context: context,
                      isDark: isDark,
                      isMobile: isMobile,
                      id: inverter['id']!,
                      name: inverter['name']!,
                      details: 'Type: ${inverter['type']}',
                      price: inverter['price']!,
                      isSelected: _selectedInverter == inverter['id'],
                      onTap: () {
                        setState(() {
                          _selectedInverter = inverter['id'];
                        });
                      },
                    )),
                const SizedBox(height: 32),
                // 4. Régulateurs
                _buildSectionTitle('Régulateurs de Charge', Icons.tune, isDark),
                const SizedBox(height: 16),
                ..._controllers.map((controller) => _buildEquipmentCard(
                      context: context,
                      isDark: isDark,
                      isMobile: isMobile,
                      id: controller['id']!,
                      name: controller['name']!,
                      details: 'Type: ${controller['type']}',
                      price: controller['price']!,
                      isSelected: _selectedController == controller['id'],
                      onTap: () {
                        setState(() {
                          _selectedController = controller['id'];
                        });
                      },
                    )),
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

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6366F1), size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentCard({
    required BuildContext context,
    required bool isDark,
    required bool isMobile,
    required String id,
    required String name,
    required String details,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : (isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2)),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF6366F1).withOpacity(0.3)
                    : (isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1)),
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1).withOpacity(0.2)
                      : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withOpacity(0.6)
                            : const Color(0xFF0F172A).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${price} DH',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

