import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/wizard_step.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/steps/wizard_bio_form.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/steps/wizard_birthday_form.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/steps/wizard_location_form.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/steps/wizard_pseudo_form.dart';

class WizardStepContent extends StatelessWidget {
  const WizardStepContent({super.key, required this.step});

  final WizardStep step;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        layoutBuilder: (current, previous) => Stack(
          fit: StackFit.expand,
          children: [
            ...previous,
            ...Option.fromNullable(current)
                .match(() => <Widget>[], (child) => [child])
          ],
        ),
        child: KeyedSubtree(
          key: ValueKey(step),
          child: switch (step) {
            WizardStepPseudo() => const WizardPseudoForm(),
            WizardStepBirthday() => const WizardBirthdayForm(),
            WizardStepBio() => const WizardBioForm(),
            WizardStepLocation() => const WizardLocationForm(),
          },
        ),
      );
}
