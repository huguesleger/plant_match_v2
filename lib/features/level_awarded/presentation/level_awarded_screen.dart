import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/cubit/level_awarded_cubit.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/cubit/level_awarded_state.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/widgets/level_awarded_success_view.dart';

class LevelAwardedScreen extends StatelessWidget {
  const LevelAwardedScreen({
    super.key,
    required this.userId,
    required this.userPoints,
    this.isFromRegistration = false,
  });

  final String userId;
  final UserPoints userPoints;
  final bool isFromRegistration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenLight,
      appBar: AppBarTemplate(
        backgroundColor: Colors.transparent,
        surfaceTintColor: AppColors.white,
        leading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: AppColors.greyDark),
          ),
        ],
      ),
      body: BlocBuilder<LevelAwardedCubit, LevelAwardedState>(
        builder: (context, state) => switch (state) {
          LevelAwardedInitial() || LevelAwardedLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          LevelAwardedError(:final message) => ErrorPage(
              errorMessage: message,
              onRetry: () => context.read<LevelAwardedCubit>().load(userId),
            ),
          LevelAwardedLoaded(:final userPoints) => LevelAwardedSuccessView(
              userPoints: userPoints,
              isFromRegistration: isFromRegistration,
            ),
        },
      ),
    );
  }
}
