import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hospital_microgrid/pages/form_a3_page.dart';

class FormA2Page extends StatefulWidget {
  final String institutionType;
  final String institutionName;
  final Position location;
  final int numberOfBeds;

  const FormA2Page({
    super.key,
    required this.institutionType,
    required this.institutionName,
    required this.location,
    required this.numberOfBeds,
  });

  @override
  State<FormA2Page> createState() => _FormA2PageState();
}

class _FormA2PageState extends State<FormA2Page> {
  final _formKey = GlobalKey<FormState>();
  final _solarSurfaceController = TextEditingController();
  final _solarSurfaceMinController = TextEditingController();
  final _solarSurfaceMaxController = TextEditingController();
  final _nonCriticalSurfaceController = TextEditingController();
  final _monthlyConsumptionController = TextEditingController();
  bool _useInterval = false;

  @override
  void dispose() {
    _solarSurfaceController.dispose();
    _solarSurfaceMinController.dispose();
    _solarSurfaceMaxController.dispose();
    _nonCriticalSurfaceController.dispose();
    _monthlyConsumptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Validate interval if enabled
      if (_useInterval) {
        final min = double.tryParse(_solarSurfaceMinController.text);
        final max = double.tryParse(_solarSurfaceMaxController.text);
        
        if (min == null || max == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez entrer des valeurs valides pour l\'intervalle'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        
        if (min >= max) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La valeur minimale doit être inférieure à la valeur maximale'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Get the solar surface value
      final solarSurface = _useInterval
          ? ((double.tryParse(_solarSurfaceMinController.text) ?? 0) +
                  (double.tryParse(_solarSurfaceMaxController.text) ?? 0)) /
              2
          : double.tryParse(_solarSurfaceController.text) ?? 0;

      // Navigate to Form A3 (Graphs)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormA3Page(
            institutionType: widget.institutionType,
            institutionName: widget.institutionName,
            location: widget.location,
            numberOfBeds: widget.numberOfBeds,
            solarSurface: solarSurface,
            nonCriticalSurface: double.tryParse(_nonCriticalSurfaceController.text) ?? 0,
            monthlyConsumption: double.tryParse(_monthlyConsumptionController.text) ?? 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire 2'),
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
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    'Informations techniques',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 1. Surface installable pour panneau solaire (m2)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Surface installable pour panneau solaire (m²)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white.withOpacity(0.9)
                                : const Color(0xFF0F172A).withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Toggle for interval/exact value
                  Row(
                    children: [
                      Text(
                        'Valeur exacte',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF0F172A).withOpacity(0.7),
                        ),
                      ),
                      Switch(
                        value: _useInterval,
                        onChanged: (value) {
                          setState(() {
                            _useInterval = value;
                          });
                        },
                        activeColor: const Color(0xFF6366F1),
                      ),
                      Text(
                        'Intervalle',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF0F172A).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!_useInterval)
                    TextFormField(
                      controller: _solarSurfaceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ex: 500',
                        suffixText: 'm²',
                        prefixIcon: const Icon(Icons.solar_power),
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
                            color: Color(0xFF6366F1),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      ),
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer la surface';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre valide';
                        }
                        return null;
                      },
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _solarSurfaceMinController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min',
                              hintText: 'Ex: 400',
                              suffixText: 'm²',
                              prefixIcon: const Icon(Icons.arrow_downward),
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
                                  color: Color(0xFF6366F1),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  isDark ? const Color(0xFF1E293B) : Colors.white,
                            ),
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Min requis';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Nombre invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _solarSurfaceMaxController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max',
                              hintText: 'Ex: 600',
                              suffixText: 'm²',
                              prefixIcon: const Icon(Icons.arrow_upward),
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
                                  color: Color(0xFF6366F1),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  isDark ? const Color(0xFF1E293B) : Colors.white,
                            ),
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Max requis';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Nombre invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // 2. Surface non critiques dispo
                  Text(
                    'Surface non critiques dispo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF0F172A).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nonCriticalSurfaceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Ex: 200',
                      suffixText: 'm²',
                      prefixIcon: const Icon(Icons.grid_view),
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
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    ),
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la surface';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un nombre valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // 3. Consommation mensuelle actuel (Kwh)
                  Text(
                    'Consommation mensuelle actuelle (Kwh)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF0F172A).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _monthlyConsumptionController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Ex: 50000',
                      suffixText: 'Kwh',
                      prefixIcon: const Icon(Icons.bolt),
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
                          color: Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    ),
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la consommation';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un nombre valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  // Submit Button
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
                        onTap: _handleSubmit,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            'Soumettre',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

