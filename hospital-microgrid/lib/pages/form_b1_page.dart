import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:hospital_microgrid/services/location_service.dart';
import 'package:hospital_microgrid/services/solar_zone_service.dart';
import 'package:hospital_microgrid/pages/form_b2_page.dart';

class FormB1Page extends StatefulWidget {
  const FormB1Page({super.key});

  @override
  State<FormB1Page> createState() => _FormB1PageState();
}

class _FormB1PageState extends State<FormB1Page> {
  Position? _currentPosition;
  SolarZone? _solarZone;
  bool _isLoading = false;
  String? _errorMessage;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Request permission
      final hasPermission = await LocationService.requestLocationPermission();
      
      if (!hasPermission) {
        setState(() {
          _errorMessage = 'Permission de localisation requise';
          _isLoading = false;
        });
        return;
      }

      // Check if GPS is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Le GPS n\'est pas activé';
          _isLoading = false;
        });
        return;
      }

      // Get location
      final position = await LocationService.getCurrentLocation();
      
      if (position == null) {
        setState(() {
          _errorMessage = 'Impossible d\'obtenir votre localisation';
          _isLoading = false;
        });
        return;
      }

      // Determine solar zone
      final zone = SolarZoneService.getSolarZoneFromLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _solarZone = zone;
        _isLoading = false;
      });

      // Center map on position
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        12.0,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _handleNext() {
    if (_currentPosition == null || _solarZone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez activer le GPS et obtenir votre localisation'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormB2Page(
          position: _currentPosition!,
          solarZone: _solarZone!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activation GPS & Carte'),
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
          child: Column(
            children: [
              // Header with zone info
              if (_solarZone != null && _currentPosition != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
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
                          color: Color(SolarZoneService.getZoneColor(_solarZone!))
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.wb_sunny,
                          color: Color(SolarZoneService.getZoneColor(_solarZone!)),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              SolarZoneService.getZoneName(_solarZone!),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              SolarZoneService.getZoneDescription(_solarZone!),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF0F172A).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _isLoading ? null : _loadLocation,
                        tooltip: 'Actualiser',
                      ),
                    ],
                  ),
                ),
              // Map
              Expanded(
                child: Stack(
                  children: [
                    if (_currentPosition != null)
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          initialZoom: 12.0,
                          minZoom: 5.0,
                          maxZoom: 18.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.hospital_microgrid',
                            maxZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                                width: 60,
                                height: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _solarZone != null
                                        ? Color(SolarZoneService.getZoneColor(_solarZone!))
                                        : const Color(0xFF6366F1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_solarZone != null
                                            ? Color(SolarZoneService.getZoneColor(_solarZone!))
                                            : const Color(0xFF6366F1))
                                            .withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.location_off,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _errorMessage ?? 'Activation du GPS requise',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF0F172A).withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: _loadLocation,
                                    icon: const Icon(Icons.gps_fixed),
                                    label: const Text('Activer GPS'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    if (_currentPosition != null)
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          onPressed: () {
                            _mapController.move(
                              LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              12.0,
                            );
                          },
                          backgroundColor: _solarZone != null
                              ? Color(SolarZoneService.getZoneColor(_solarZone!))
                              : const Color(0xFF6366F1),
                          child: const Icon(Icons.my_location, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              // Coordinates info
              if (_currentPosition != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? Colors.white24
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gps_fixed,
                        size: 16,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF0F172A).withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
                        'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF0F172A).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              // Next Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? Colors.white24
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
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
                        onTap: _handleNext,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continuer',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


