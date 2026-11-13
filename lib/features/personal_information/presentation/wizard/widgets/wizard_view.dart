import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_actions.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_progress_indicator.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_step_content.dart';

class WizardView extends StatelessWidget {
  const WizardView({super.key, required this.state, required this.onClose});

  final DetailWizardState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBarTemplate(
          title: Some(t.personalInformation.screen.title),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          styleIconButton: Some(IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: AppColors.greyLight),
          )),
          centerTitle: true,
          leading: !state.isFirstStep,
          onPressed: Some(context.read<DetailWizardCubit>().previous),
          actions: Some([
            IconButton(
              onPressed: onClose,
              icon: const Icon(LucideIcons.x),
              color: AppColors.greyDark,
            ),
          ]),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (!state.isSingleStep)
                WizardProgressIndicator(
                  currentPage: state.stepIndex,
                  totalPages: state.steps.length,
                ),
              Expanded(child: WizardStepContent(step: state.currentStep)),
            ],
          ),
        ),
        bottomNavigationBar: WizardActions(state: state),
      );
}
