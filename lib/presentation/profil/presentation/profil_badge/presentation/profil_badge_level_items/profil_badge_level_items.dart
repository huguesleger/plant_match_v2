import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_badge/presentation/level_detail_page/level_detail_page.dart';
import 'package:plant_match_v2/presentation/user_points/presentation/utils/user_points_utils.dart';

class ProfilBadgeLevelItems extends StatelessWidget {
  const ProfilBadgeLevelItems({
    super.key,
    required this.currentLevel,
  });

  final int currentLevel;

  IconData _getIconForLevel(int level) {
    return UserPointsUtils.getIconForLevel(level);
  }

  String _getLevelName(int level) {
    return UserPointsUtils.getLevelName(level);
  }

  @override
  Widget build(BuildContext context) {
    final levels = UserPointsUtils.levelData.entries.toList();

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: levels.length,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final level = levels[index].key;
        final maxPoints = levels[index].value.maxPoints;
        return _buildLevelItem(context, level, maxPoints);
      },
    );
  }

  Widget _buildLevelItem(BuildContext context, int level, int maxPoints) {
    final bool isCurrentOrPreviousLevel = level <= currentLevel;

    return Card.filled(
      color: isCurrentOrPreviousLevel
          ? AppColors.greenDark.withOpacity(0.3)
          : AppColors.greyUltraLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LevelDetailPage(level: level),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SizedBox(
            width: 130,
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: Icon(
                    _getIconForLevel(level),
                    color: AppColors.greenDark,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getLevelName(level),
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.greyDark,
                    fontFamily: 'Chillax',
                    fontWeight: FontWeight.w300,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  '$maxPoints pts',
                  style: InterTextStyle.inter(
                    AppTypo.textXs,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
