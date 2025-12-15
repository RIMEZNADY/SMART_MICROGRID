import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_microgrid/pages/login_page.dart';
import 'package:hospital_microgrid/pages/register_page.dart';
import 'package:hospital_microgrid/theme/medical_solar_colors.dart';

class AuthPage extends StatefulWidget {
 const AuthPage({super.key});

 @override
 State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
 with SingleTickerProviderStateMixin {
 late AnimationController _animationController;
 late Animation<double> _fadeAnimation;
 late Animation<Offset> _slideAnimation;

 @override
 void initState() {
 super.initState();
 _animationController = AnimationController(
 duration: const Duration(milliseconds: 800),
 vsync: this,
 );

 _fadeAnimation = Tween<double>(
 begin: 0.0,
 end: 1.0,
 ).animate(CurvedAnimation(
 parent: _animationController,
 curve: Curves.easeInOut,
 ));

 _slideAnimation = Tween<Offset>(
 begin: const Offset(0, 0.2),
 end: Offset.zero,
 ).animate(CurvedAnimation(
 parent: _animationController,
 curve: Curves.easeOutCubic,
 ));

 _animationController.forward();
 }

 @override
 void dispose() {
 _animationController.dispose();
 super.dispose();
 }

 void _handleLogin() {
 // Navigate to login page
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(
 builder: (context) => const LoginPage(),
 ),
 );
 }

 void _handleRegister() {
 // Navigate to register page
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(
 builder: (context) => const RegisterPage(),
 ),
 );
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
                  ]
                : [
                    MedicalSolarColors.offWhite,
                    MedicalSolarColors.medicalBlue.withOpacity(0.05),
                  ],
          ),
        ),
 child: SafeArea(
 child: SingleChildScrollView(
 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
 child: FadeTransition(
 opacity: _fadeAnimation,
 child: SlideTransition(
 position: _slideAnimation,
 child: Column(
   crossAxisAlignment: CrossAxisAlignment.stretch,
   mainAxisSize: MainAxisSize.min,
   children: [
     const SizedBox(height: 40),
                    // Logo with enhanced design
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  MedicalSolarColors.medicalBlue.withOpacity(0.2),
                                  MedicalSolarColors.medicalBlue.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                          // Main logo container
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
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
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Medical icon
                                const Icon(
                                  Icons.medical_services_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                // Sun icon overlay
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MedicalSolarColors.solarYellow.withOpacity(0.9),
                                    ),
                                    child: const Icon(
                                      Icons.wb_sunny_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
 const SizedBox(height: 32),
 // Title
                    Text(
                      'Bienvenue',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : MedicalSolarColors.softGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Connectez-vous ou creez un compte pour commencer',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: isDark
                            ? Colors.white.withOpacity(0.8)
                            : MedicalSolarColors.softGrey.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
 const SizedBox(height: 60),
 // Login Button
 _buildAuthButton(
   context: context,
   isDark: isDark,
   label: 'Connexion',
   icon: Icons.arrow_forward_rounded,
   onPressed: _handleLogin,
   isPrimary: true,
 ),
 const SizedBox(height: 16),
 // Register Button
 _buildAuthButton(
   context: context,
   isDark: isDark,
   label: 'Inscription',
   icon: Icons.person_add_rounded,
   onPressed: _handleRegister,
   isPrimary: false,
 ),
 const SizedBox(height: 40),
 // Footer text
 Padding(
   padding: const EdgeInsets.only(bottom: 32),
   child: Text(
     'Microgrid Intelligent pour Hopitaux',
     style: GoogleFonts.inter(
       fontSize: 12,
       color: isDark
           ? Colors.white.withOpacity(0.5)
           : MedicalSolarColors.softGrey.withOpacity(0.5),
       letterSpacing: 0.5,
     ),
     textAlign: TextAlign.center,
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

 Widget _buildAuthButton({
 required BuildContext context,
 required bool isDark,
 required String label,
 required IconData icon,
 required VoidCallback onPressed,
 required bool isPrimary,
 }) {
    if (isPrimary) {
      // Primary button with gradient
      return Container(
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
 onTap: onPressed,
 borderRadius: BorderRadius.circular(16),
 child: Container(
   padding: const EdgeInsets.symmetric(vertical: 18),
   child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Text(
         label,
         style: GoogleFonts.inter(
           fontSize: 18,
           fontWeight: FontWeight.w600,
           color: Colors.white,
           letterSpacing: 0.5,
         ),
       ),
       const SizedBox(width: 12),
       Icon(icon, color: Colors.white, size: 22),
     ],
   ),
 ),
 ),
 ),
 );
    } else {
      // Secondary button with border
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? MedicalSolarColors.darkSurface : Colors.white,
          border: Border.all(
            color: MedicalSolarColors.medicalBlue.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : MedicalSolarColors.medicalBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : MedicalSolarColors.medicalBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      icon,
                      color: isDark
                          ? Colors.white
                          : MedicalSolarColors.medicalBlue,
                      size: 22,
                    ),
                  ],
                ),
              ),
          ),
        ),
      );
    }
 }
}

