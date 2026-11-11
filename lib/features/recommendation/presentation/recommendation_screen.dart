import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_state.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/env_selection_step.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/light_selection_step.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/care_level_step.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/pet_safety_step.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/recommendation_result_view.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/recommendation_footer.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_page.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_gate.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationCubit, RecommendationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Trouve ta plante",
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: AppLoaderGate(
            isLoading: state is RecommendationInitial || state is RecommendationLoading,
            child: state.match(
              initial: (_) => const AppLoaderPage(),
              step: (stepState) => _buildWizardBody(context, stepState),
              loading: (_) => const AppLoaderPage(),
              result: (resultState) => RecommendationResultView(
                plants: resultState.suggestedPlants,
              ),
              error: (errorState) => Center(
                child: Text(errorState.failure.errorContent.message),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWizardBody(
    BuildContext context,
    RecommendationQuestionStep state,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Étape ${state.stepIndex + 1} sur 4",
                style: const TextStyle(color: AppColors.greyDark, fontSize: 13),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (state.stepIndex + 1) / 4,
                backgroundColor: AppColors.greyLight,
                color: AppColors.greenDark,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Option.fromNullable(<int, Widget Function()>{
              0: () => EnvSelectionStep(answers: state.answers),
              1: () => LightSelectionStep(answers: state.answers),
              2: () => CareLevelStep(answers: state.answers),
              3: () => PetSafetyStep(answers: state.answers),
            }[state.stepIndex])
                .match(() => const SizedBox(), (step) => step()),
          ),
        ),
        RecommendationFooter(state: state),
      ],
    );
  }
}
