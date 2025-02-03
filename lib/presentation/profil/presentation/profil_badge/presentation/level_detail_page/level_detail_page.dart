import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_badge/presentation/level_detail_page/utils/user_level_details.dart';
import 'package:plant_match_v2/presentation/user_points/presentation/utils/user_points_utils.dart';

class LevelDetailPage extends StatelessWidget {
  const LevelDetailPage({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final levelData = UserLevelDetails.getLevelDetails(level);
    return Scaffold(
      appBar: AppBarHeaderImage(
        image: const Image(
            image: AssetImage('assets/images/bg_profil_level_detail.jpg')),
        headerHeight: 215,
        onPressed: () {
          Navigator.pop(context);
        },
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            _IconLevel(level: level),
            const SizedBox(height: 10),
            _TitleLevel(level: level),
            const SizedBox(height: 40),
            _ContentLevel(levelData: levelData),
          ],
        ),
      ),
    );
  }
}

class _ContentLevel extends StatelessWidget {
  const _ContentLevel({
    required this.levelData,
  });

  final Map<String, dynamic> levelData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Conditions : ',
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
            children: <TextSpan>[
              TextSpan(
                text: levelData['condition'],
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            text: 'Description : ',
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
            children: <TextSpan>[
              TextSpan(
                text: levelData['description'],
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            text: 'Points nécessaires : ',
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '${levelData['requiredPoints']} points',
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Actions principales récompensées :",
          style: TextStyle(
            fontSize: AppTypo.textS,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (levelData['rewardedActions'] as Map<String, int>)
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: RichText(
                      text: TextSpan(
                        text: "• ${entry.key} : ",
                        style: InterTextStyle.inter(
                          AppTypo.textS,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyDark,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "+${entry.value} points",
                            style: InterTextStyle.inter(
                              AppTypo.textS,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TitleLevel extends StatelessWidget {
  const _TitleLevel({
    required this.level,
  });

  final int level;

  String _getLevelName(int level) {
    return UserPointsUtils.getLevelName(level);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitlePage(
          title: 'Niveau $level',
          fontSize: AppTypo.textXl,
        ),
        Text(
          _getLevelName(level),
          style: const TextStyle(
            fontSize: AppTypo.text,
            color: AppColors.greyMedium,
          ),
        ),
      ],
    );
  }
}

class _IconLevel extends StatelessWidget {
  const _IconLevel({
    required this.level,
  });

  final int level;

  IconData _getIconForLevel(int level) {
    return UserPointsUtils.getIconForLevel(level);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 53,
      height: 53,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.greenDark.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        _getIconForLevel(level),
        color: AppColors.greyDark,
        size: 24,
      ),
    );
  }
}
