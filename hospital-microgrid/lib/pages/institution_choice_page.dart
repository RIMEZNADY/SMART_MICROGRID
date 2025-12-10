import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospital_microgrid/services/solar_zone_service.dart';
import 'package:hospital_microgrid/pages/form_a1_page.dart';
import 'package:hospital_microgrid/pages/form_b1_page.dart';

class InstitutionChoicePage extends StatelessWidget {
  final Position? position;
  final SolarZone? solarZone;

  const InstitutionChoicePage({
    super.key,
    this.position,
    this.solarZone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Question Text
                  Text(
                    'are you here to :',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // EXISTANT Button
                  _buildChoiceButton(
                    context: context,
                    isDark: isDark,
                    label: 'EXISTANT',
                    icon: Icons.local_hospital,
                    onPressed: () {
                      // Navigate to Form A1
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormA1Page(
                            position: position,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFF6366F1),
                  ),
                  const SizedBox(height: 20),
                  // NEW Button
                  _buildChoiceButton(
                    context: context,
                    isDark: isDark,
                    label: 'NEW',
                    icon: Icons.add_business,
                    onPressed: () {
                      // Navigate to Form B1 (GPS & Map)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FormB1Page(),
                        ),
                      );
                    },
                    color: const Color(0xFF06B6D4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required BuildContext context,
    required bool isDark,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color == const Color(0xFF6366F1)
                ? const Color(0xFF06B6D4)
                : const Color(0xFF8B5CF6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
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

