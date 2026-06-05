import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_state.dart';

class RecommendationFooter extends StatelessWidget {
  final RecommendationQuestionStep state;

  const RecommendationFooter({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecommendationCubit>();
    final hasAnswered = _hasAnsweredCurrentStep(state);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            if (state.stepIndex > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: cubit.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.greenDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Retour",
                    style: TextStyle(color: AppColors.greenDark),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: hasAnswered ? cubit.nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenDark,
                  disabledBackgroundColor: AppColors.greyLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  state.stepIndex == 3 ? "Terminer" : "Suivant",
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasAnsweredCurrentStep(RecommendationQuestionStep state) {
    return switch (state.stepIndex) {
      0 => state.answers.environment.isSome(),
      1 => state.answers.light.isSome(),
      2 => state.answers.careLevel.isSome(),
      3 => state.answers.petSafety.isSome(),
      _ => false,
    };
  }
}
