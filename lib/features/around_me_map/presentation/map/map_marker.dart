import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/current_user_marker.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class MapMarker extends StatelessWidget {
  const MapMarker({
    super.key,
    required this.user,
    required this.isCurrentUser,
    required this.distance,
    required this.catalogs,
  });

  final ProfilUser user;
  final bool isCurrentUser;
  final double distance;
  final List<Catalog> catalogs;

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? const CurrentUserMarker()
        : _buildOtherUserMarker(context);
  }

  Widget _buildOtherUserMarker(BuildContext context) {
    return IconButton(
      onPressed: () {
        bottomSheet(
          context: context,
          user: user,
          distance: Some(distance),
          catalogs: catalogs,
        );
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(const CircleBorder()),
        backgroundColor: WidgetStateProperty.all(
            catalogs.isNotEmpty ? AppColors.greenLight : AppColors.grey),
      ),
      icon: Icon(
        LucideIcons.heart_handshake,
        color: catalogs.isNotEmpty ? AppColors.blueGreen : AppColors.white,
        size: 25.0,
      ),
    );
  }
}
