import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

class AroundMeMapScreen extends StatelessWidget {
  const AroundMeMapScreen({
    super.key,
    required this.profilUser,
    required this.users,
  });

  final ProfilUser profilUser;
  final List<ProfilUser> users;

  @override
  Widget build(BuildContext context) {
    if (profilUser.latitude == null || profilUser.longitude == null) {
      return _locationDisabledScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Autour de moi")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(profilUser.latitude!, profilUser.longitude!),
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _buildMarkers(),
          ),
        ],
      ),
    );
  }

  Widget _locationDisabledScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text("Autour de moi")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Veuillez activer votre localisation pour voir les utilisateurs autour de vous.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    return [
      Marker(
        width: 50.0,
        height: 50.0,
        point: LatLng(profilUser.latitude!, profilUser.longitude!),
        child: const Icon(
          Icons.location_on,
          size: 40,
          color: AppColors.blueGreen,
        ),
      ),
      ...users.map(
        (user) => Marker(
          width: 50.0,
          height: 50.0,
          point: LatLng(user.latitude!, user.longitude!),
          child: Icon(
            Icons.location_on,
            size: 40,
            color: AppColors.greenDark,
          ),
        ),
      ),
    ];
  }
}
