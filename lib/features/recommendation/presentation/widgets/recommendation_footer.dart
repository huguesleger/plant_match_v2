import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
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
                child: ButtonOutlinedRounded(
                  onPressed: cubit.previousStep,
                  text: t.recommendation.footer.back,
                  borderColor: AppColors.greyLight,
                  textColor: AppColors.greyMedium,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: ButtonRounded(
                onPressed: Option.fromPredicate(
                  cubit.nextStep,
                  (_) => hasAnswered,
                ),
                text: state.stepIndex == 3
                    ? t.recommendation.footer.finish
                    : t.recommendation.footer.next,
                bgColor: AppColors.greenLight,
                textColor: AppColors.blueGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasAnsweredCurrentStep(RecommendationQuestionStep state) {
    return Option.fromNullable(<int, bool>{
      0: state.answers.environment.isSome(),
      1: state.answers.light.isSome(),
      2: state.answers.careLevel.isSome(),
      3: state.answers.petSafety.isSome(),
    }[state.stepIndex])
        .getOrElse(() => false);
  }
}
