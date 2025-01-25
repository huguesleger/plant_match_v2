import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_badge/presentation/profil_badge_card/profil_badge_card.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_badge/presentation/profil_badge_header/profil_badge_card_header.dart';
import 'package:plant_match_v2/presentation/user_points/domain/entities/user_points.dart';
import 'package:plant_match_v2/presentation/user_points/presentation/utils/user_points_utils.dart';

class ProfilBadgeScreen extends StatelessWidget {
  const ProfilBadgeScreen({super.key, required this.userPoints});

  final UserPoints userPoints;

  @override
  Widget build(BuildContext context) {
    final points = userPoints;
    final currentPoints = points.currentPoints;
    final level = points.level;
    final maxPoints = UserPointsUtils.getMaxPointsForLevel(level);

    return Stack(
      children: [
        Container(
          height: 60,
          color: AppColors.greenLight,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
/*                        child: ProfilLevelProgressIndicator(
                          currentPoints: currentPoints,
                          maxPoints: maxPoints,
                          level: level,
                        ),*/
              child: ProfilBadgeCardHeader(
                  currentPoints: currentPoints, level: level),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ProfilBadgeCard(),
            ),
          ],
        ),
      ],
    );
  }
}
