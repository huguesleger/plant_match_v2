import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level/presentation/widgets/level_view.dart';

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
          UserPointsLoaded s => LevelView(userPoints: s.userPoints),
          UserPointsAwarded s => LevelView(userPoints: s.userPoints),
        },
      ),
    );
  }
}
