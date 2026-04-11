import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_card.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_points_card.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_card_header.dart';
import 'package:plant_match_v2/features/level/widget/level_items.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Mes badges',
        centerTitle: true,
        backgroundColor: AppColors.greenLight,
        surfaceTintColor: AppColors.white,
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyDark),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<UserPointsCubit, UserPointsState>(
        builder: (context, state) => switch (state) {
          UserPointsInitial() ||
          UserPointsLoading() =>
            const Center(child: CircularProgressIndicator()),
          UserPointsError s => ErrorPage(
              errorMessage: s.message,
              onRetry: () =>
                  context.read<UserPointsCubit>().fetchUserPoints(userId),
            ),
          UserPointsLoaded s => _LevelContent(userPoints: s.userPoints),
          UserPointsAwarded s => _LevelContent(userPoints: s.userPoints),
        },
      ),
    );
  }
}

class _LevelContent extends StatelessWidget {
  const _LevelContent({required this.userPoints});

  final dynamic userPoints;

  @override
  Widget build(BuildContext context) {
    final level = userPoints.level;
    final currentPoints = userPoints.currentPoints;
    final maxPoints = UserPointsUtils.getMaxPointsForLevel(level);
    final levels = UserPointsUtils.levelData.length;

    return Stack(
      children: [
        Container(
          height: 60,
          color: AppColors.greenLight,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 30),
              child: LevelCardHeader(
                currentPoints: currentPoints,
                level: level,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppSpacing.paddingHorizontal +
                          const EdgeInsets.symmetric(vertical: 30),
                      child: const LevelCard(),
                    ),
                    Container(
                      color: AppColors.greyUltraLight,
                      width: double.infinity,
                      child: Padding(
                        padding: AppSpacing.paddingHorizontal +
                            const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const TitlePage(
                              title: 'Mon niveau',
                              fontSize: AppTypo.textXl,
                            ),
                            const SizedBox(height: 20),
                            LevelPointsCard(
                              level: level,
                              points: currentPoints,
                              maxPoints: maxPoints,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: AppSpacing.paddingHorizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitlePage(
                            title: 'Mes badges',
                            fontSize: AppTypo.textXl,
                          ),
                          BadgePill(
                            text: Text(
                              '$level/$levels',
                              style: const TextStyle(
                                fontSize: AppTypo.textXs,
                                color: AppColors.white,
                              ),
                            ),
                            badgeColor: AppColors.greenMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: Padding(
                        padding: AppSpacing.paddingHorizontal,
                        child: LevelItems(currentLevel: level),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
