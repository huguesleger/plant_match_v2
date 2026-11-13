import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_state.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/widgets/wizard_secondary_action.dart';

class WizardActions extends StatelessWidget {
  const WizardActions({super.key, required this.state});

  final DetailWizardState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DetailWizardCubit>();
    final isLocationStep = switch (state.currentStep) {
      WizardStepLocation() => true,
      WizardStepPseudo() || WizardStepBirthday() || WizardStepBio() => false,
    };

    final secondary = isLocationStep
        ? Some(
            WizardSecondaryAction(
              text: state.draft.localisation.isEmpty
                  ? t.personalInformation.wizard.common.geolocate
                  : t.personalInformation.wizard.common.update_location,
              isLoading: state.status is WizardLocating,
              onPressed:
                  Option.fromPredicate(cubit.locate, (_) => !state.isBusy),
            ),
          )
        : Option.fromPredicate(
            WizardSecondaryAction(
              text: t.personalInformation.wizard.common.skip,
              isLoading: false,
              onPressed: Option.fromPredicate(cubit.skip, (_) => !state.isBusy),
            ),
            (_) => !state.isSingleStep,
          );

    return BottomBar(
      child: Row(
        children: [
          ...secondary
              .map((action) => [
                    Expanded(child: action),
                    const SizedBox(width: 12),
                  ])
              .getOrElse(() => []),
          Expanded(
            child: ButtonRounded(
              text: _primaryLabel(isLocationStep),
              isLoading: state.status is WizardSaving,
              onPressed: Option.fromPredicate(cubit.next, (_) => !state.isBusy),
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
            ),
          ),
        ],
      ),
    );
  }

  String _primaryLabel(bool isLocationStep) => !state.isLastStep
      ? t.personalInformation.wizard.common.next
      : state.isSingleStep && !isLocationStep
          ? t.personalInformation.wizard.common.save
          : t.personalInformation.wizard.common.finish;
}
