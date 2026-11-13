import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_item.dart';

class WizardBioForm extends StatelessWidget {
  const WizardBioForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DetailWizardCubit>();

    return DetailWizardItem(
      title: t.personalInformation.wizard.bio.title,
      description: t.personalInformation.wizard.bio.description,
      child: FormBuilderTextField(
        name: 'bio',
        initialValue: cubit.state.draft.bio.getOrElse(() => ''),
        decoration: DecorationInput.inputDecoration(
          hintText: t.personalInformation.wizard.bio.hint,
          labelText: t.personalInformation.wizard.bio.label,
          alignLabelWithHint: true,
        ),
        autofocus: true,
        minLines: 3,
        maxLines: 5,
        maxLength: 150,
        onChanged: (value) => cubit.updateBio(value ?? ''),
      ),
    );
  }
}
