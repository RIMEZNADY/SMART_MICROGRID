import 'package:flutter/material.dart';
import 'package:hospital_microgrid/main.dart';
import 'package:hospital_microgrid/providers/theme_provider.dart';
import 'package:hospital_microgrid/services/ai_service.dart';
import 'package:hospital_microgrid/pages/calculation_results_page.dart';

import 'package:hospital_microgrid/theme/medical_solar_colors.dart';
class ResultChoicePage extends StatefulWidget {
  final int establishmentId;
  final ThemeProvider themeProvider;

  const ResultChoicePage({
    super.key,
    required this.establishmentId,
    required this.themeProvider,
  });

  @override
  State<ResultChoicePage> createState() => _ResultChoicePageState();
}

class _ResultChoicePageState extends State<ResultChoicePage> {
  bool _isChecking = true;
  bool _iaAvailable = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkIaAvailability();
  }

  Future<void> _checkIaAvailability() async {
    setState(() {
      _isChecking = true;
      _error = null;
    });
    try {
      // Appel leger : forecast 1 jour pour verifier l'acces IA via backend
      await AiService.getForecast(widget.establishmentId, horizonDays: 1);
      setState(() {
        _iaAvailable = true;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _iaAvailable = false;
        _isChecking = false;
        _error = 'IA indisponible (fallback calcul).';
      });
    }
  }

  void _goToCalc() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => CalculationResultsPage(
          establishmentId: widget.establishmentId,
          themeProvider: widget.themeProvider,
        ),
      ),
      (route) => false,
    );
  }

  void _goToIa() {
    if (!_iaAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('IA indisponible, Bascule vers Calcul'),
          backgroundColor: Colors.orange,
        ),
      );
      _goToCalc();
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          themeProvider: widget.themeProvider,
          initialIndex: 1, // AI Prediction
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choix du mode de resultats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selectionnez comment afficher vos resultats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : MedicalSolarColors.softGrey,
              ),
            ),
            const SizedBox(height: 12),
            if (_isChecking)
              const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Verification de la disponibilitée IA...'),
                ],
              )
            else if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.orange),
              )
            else if (_iaAvailable)
              const Text(
                'IA disponible.',
                style: TextStyle(color: Colors.green),
              ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _goToCalc,
              icon: const Icon(Icons.calculate),
              label: const Text('Voir resultats (Calcul)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _iaAvailable && !_isChecking ? _goToIa : null,
              icon: const Icon(Icons.psychology),
              label: const Text('Voir resultats (IA)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _isChecking ? null : _checkIaAvailability,
              child: const Text('Re-tester la disponibilitée IA'),
            ),
          ],
        ),
      ),
    );
  }
}


