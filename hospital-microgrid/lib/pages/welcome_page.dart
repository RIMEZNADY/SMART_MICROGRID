import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_microgrid/pages/auth_page.dart';
import 'package:hospital_microgrid/theme/medical_solar_colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _solarController;
  late AnimationController _slideController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _solarRotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Animation rotation panneau solaire
    _solarController = AnimationController(
      duration: const Duration(milliseconds: 20000),
      vsync: this,
    );
    _solarController.repeat();
    
    // Animation slide
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    
    _solarRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.15, // Lgère inclinaison
    ).animate(CurvedAnimation(
      parent: _solarController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();

    // Navigate to auth page after 5 seconds
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _solarController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    MedicalSolarColors.darkBackground,
                    MedicalSolarColors.darkSurface,
                    MedicalSolarColors.medicalBlueDark.withOpacity(0.1),
                  ]
                : [
                    MedicalSolarColors.offWhite,
                    MedicalSolarColors.medicalBlue.withOpacity(0.1),
                    MedicalSolarColors.solarGreen.withOpacity(0.08),
                  ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo avec panneaux solaires
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rayons de soleil anims
                          AnimatedBuilder(
                            animation: _solarRotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _solarRotationAnimation.value,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        MedicalSolarColors.solarYellow.withOpacity(0.2),
                                        MedicalSolarColors.solarYellow.withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: SunRaysPainter(),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Panneaux solaires styliss
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
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
                                  color: MedicalSolarColors.medicalBlue.withOpacity(0.4),
                                  blurRadius: 40,
                                  offset: const Offset(0, 15),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Lignes de panneaux solaires
                                CustomPaint(
                                  size: const Size(160, 160),
                                  painter: SolarPanelPainter(),
                                ),
                                // Icône croix mdicale + soleil combins
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.medical_services_rounded,
                                      color: Colors.white,
                                      size: 48,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Icon(
                                      Icons.wb_sunny_rounded,
                                      color: MedicalSolarColors.solarYellow,
                                      size: 32,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Nom de l'app avec effet amélioré
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark
                            ? [
                                MedicalSolarColors.medicalBlueDark,
                                MedicalSolarColors.solarGreenDark,
                                MedicalSolarColors.solarYellowDark,
                              ]
                            : [
                                MedicalSolarColors.medicalBlue,
                                MedicalSolarColors.solarGreen,
                                MedicalSolarColors.solarYellow,
                              ],
                      ).createShader(bounds),
                      child: Text(
                        'SOLAR',
                        style: GoogleFonts.inter(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'MEDICAL',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        color: isDark ? Colors.white : MedicalSolarColors.softGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : MedicalSolarColors.medicalBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.2)
                              : MedicalSolarColors.medicalBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Microgrid Intelligent pour Hopitaux',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark 
                              ? Colors.white.withOpacity(0.9)
                              : MedicalSolarColors.softGrey.withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Indicateur de chargement subtil
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: isDark
                            ? MedicalSolarColors.medicalBlueDark.withOpacity(0.2)
                            : MedicalSolarColors.medicalBlue.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? MedicalSolarColors.medicalBlueDark : MedicalSolarColors.medicalBlue,
                        ),
                        minHeight: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Peintre pour les rayons de soleil
class SunRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MedicalSolarColors.solarYellow.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    
    // Dessiner des rayons
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final startX = center.dx + (radius - 15) * math.cos(angle);
      final startY = center.dy + (radius - 15) * math.sin(angle);
      final endX = center.dx + (radius + 10) * math.cos(angle);
      final endY = center.dy + (radius + 10) * math.sin(angle);
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Peintre pour les lignes de panneaux solaires
class SolarPanelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Lignes horizontales (cellules de panneau)
    for (int i = 1; i < 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(
        Offset(20, y),
        Offset(size.width - 20, y),
        paint,
      );
    }
    
    // Lignes verticales
    for (int i = 1; i < 4; i++) {
      final x = (size.width / 4) * i;
      canvas.drawLine(
        Offset(x, 20),
        Offset(x, size.height - 20),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
