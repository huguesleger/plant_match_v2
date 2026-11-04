import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:fpdart/fpdart.dart' hide State;

class RadiusFilterPage extends StatefulWidget {
  final double initialRadius;
  final ProfilUser currentUser;

  const RadiusFilterPage({
    super.key,
    required this.initialRadius,
    required this.currentUser,
  });

  @override
  State<RadiusFilterPage> createState() => _RadiusFilterPageState();
}

class _RadiusFilterPageState extends State<RadiusFilterPage>
    with TickerProviderStateMixin {
  late double _selectedRadius;
  late final AnimatedMapController _animatedMapController;

  @override
  void initState() {
    super.initState();
    _selectedRadius = widget.initialRadius;
    _animatedMapController = AnimatedMapController(vsync: this);
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  LatLng _getUserPosition() => LatLng(
        widget.currentUser.latitude.getOrElse(() => 0.0),
        widget.currentUser.longitude.getOrElse(() => 0.0),
      );

  LatLngBounds _getBoundsFromRadius(LatLng center, double radiusInKm) {
    final dLat = radiusInKm / 111.1;
    final latRad = center.latitude * math.pi / 180.0;
    final dLon = radiusInKm / (111.1 * math.cos(latRad));
    return LatLngBounds(
      LatLng(center.latitude - dLat, center.longitude - dLon),
      LatLng(center.latitude + dLat, center.longitude + dLon),
    );
  }

  void _updateCameraForRadius(double radius) {
    final center = _getUserPosition();
    final bounds = _getBoundsFromRadius(center, radius);
    _animatedMapController.animatedFitCamera(
      cameraFit: CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(20),
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Rayon de recherche',
            style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Définissez la distance maximale pour découvrir des plantes autour de vous.',
                style: TextStyle(
                  color: AppColors.greyDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dans un rayon de',
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                    ),
                  ),
                  Text(
                    '${_selectedRadius.toInt()} km',
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueGreen,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.blueGreen,
                  inactiveTrackColor: AppColors.greyLight,
                  thumbColor: AppColors.blueGreen,
                  overlayColor: AppColors.blueGreen.withValues(alpha: 0.12),
                  trackHeight: 4,
                ),
                child: Slider(
                  min: 1.0,
                  max: 200.0,
                  divisions: 199,
                  value: _selectedRadius,
                  onChanged: (value) {
                    setState(() {
                      _selectedRadius = value;
                    });
                  },
                  onChangeEnd: (value) {
                    _updateCameraForRadius(value);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0 km',
                    style: InterTextStyle.inter(
                      AppTypo.textXs,
                      color: AppColors.greyMedium,
                    ),
                  ),
                  Text(
                    '200 km',
                    style: InterTextStyle.inter(
                      AppTypo.textXs,
                      color: AppColors.greyMedium,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SizedBox(
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlutterMap(
                      mapController: _animatedMapController.mapController,
                      options: MapOptions(
                        initialCenter: _getUserPosition(),
                        initialZoom: 10,
                        onMapReady: () {
                          _updateCameraForRadius(_selectedRadius);
                        },
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                      ),
                      children: [
                        TileLayer(
                          userAgentPackageName: "com.plantmatch.app",
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: _getUserPosition(),
                              radius: _selectedRadius * 1000,
                              useRadiusInMeter: true,
                              color:
                                  AppColors.blueGreen.withValues(alpha: 0.12),
                              borderColor:
                                  AppColors.blueGreen.withValues(alpha: 0.4),
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 30,
                              height: 30,
                              point: _getUserPosition(),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.greenMedium
                                          .withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: AppColors.greenMedium,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedRadius);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Appliquer',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
