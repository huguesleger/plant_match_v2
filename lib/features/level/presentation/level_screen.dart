import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level/presentation/level_header.dart';
import 'package:plant_match_v2/features/level/presentation/my_badges.dart';
import 'package:plant_match_v2/features/level/presentation/my_level.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_card.dart';
import 'package:plant_match_v2/features/level/widget/level_items.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: t.level.screen.title,
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
          UserPointsLoaded(:final userPoints) ||
          UserPointsAwarded(:final userPoints) =>
            Stack(
              children: [
                Container(
                  height: 60,
                  color: AppColors.greenLight,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LevelHeader(
                      currentPoints: userPoints.currentPoints,
                      level: userPoints.level,
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
                            MyLevel(
                              currentPoints: userPoints.currentPoints,
                              level: userPoints.level,
                              maxPoints: UserPointsUtils.getMaxPointsForLevel(
                                  userPoints.level),
                            ),
                            const SizedBox(height: 20),
                            MyBadges(
                              level: userPoints.level,
                              levels: UserPointsUtils.levelData.length,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 150,
                              child: Padding(
                                padding: AppSpacing.paddingHorizontal,
                                child:
                                    LevelItems(currentLevel: userPoints.level),
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
            ),
        },
      ),
    );
  }
}
