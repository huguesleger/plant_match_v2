import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/map_users/bottom_sheet_user.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

class MapUsers extends StatefulWidget {
  const MapUsers({
    super.key,
    required this.users,
    required this.currentUser,
  });

  final List<ProfilUser> users;
  final ProfilUser currentUser;

  @override
  State<MapUsers> createState() => _MapUsersState();
}

class _MapUsersState extends State<MapUsers> {
  late final MapController _mapController;
  double _currentZoom = 12.0;
  final double _minZoom = 10.0;
  final double _maxZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _zoomIn() {
    if (_currentZoom < _maxZoom) {
      setState(() {
        _currentZoom += 1;
        _mapController.move(_mapController.camera.center, _currentZoom);
      });
    }
  }

  void _zoomOut() {
    if (_currentZoom > _minZoom) {
      setState(() {
        _currentZoom -= 1;
        _mapController.move(_mapController.camera.center, _currentZoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _getUserPosition(widget.currentUser),
                  initialZoom: _currentZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(
                    markers: widget.users.map((user) {
                      return Marker(
                        width: 40.0,
                        height: 40.0,
                        point: _getUserPosition(user),
                        child: _buildUserMarker(user),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 40,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                backgroundColor: AppColors.white,
                mini: true,
                child: const Icon(LucideIcons.plus, color: AppColors.blueGreen),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _zoomOut,
                backgroundColor: AppColors.white,
                mini: true,
                child:
                    const Icon(LucideIcons.minus, color: AppColors.blueGreen),
              ),
            ],
          ),
        ),
      ],
    );
  }

  LatLng _getUserPosition(ProfilUser user) {
    return LatLng(user.latitude ?? 0.0, user.longitude ?? 0.0);
  }

  Widget _buildUserMarker(ProfilUser user) {
    bool isCurrentUser = user.uid == widget.currentUser.uid;

    return isCurrentUser
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.greenMedium.withValues(alpha: 0.5),
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
          )
        : IconButton(
            onPressed: () {
              bottomSheetUser(context: context, user: user);
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(const CircleBorder()),
              backgroundColor: WidgetStateProperty.all(AppColors.greenLight),
            ),
            icon: const Icon(
              LucideIcons.heart_handshake,
              color: AppColors.blueGreen,
              size: 25.0,
            ),
          );
  }
}
