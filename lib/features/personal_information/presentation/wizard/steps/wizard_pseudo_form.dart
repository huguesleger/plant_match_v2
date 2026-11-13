import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_item.dart';

class WizardPseudoForm extends StatelessWidget {
  const WizardPseudoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DetailWizardCubit>();

    return DetailWizardItem(
      title: t.personalInformation.wizard.pseudo.title,
      description: t.personalInformation.wizard.pseudo.description,
      child: FormBuilderTextField(
        name: 'userName',
        initialValue: cubit.state.draft.userName.getOrElse(() => ''),
        decoration: DecorationInput.inputDecoration(
          hintText: t.personalInformation.wizard.pseudo.hint,
          labelText: t.personalInformation.wizard.pseudo.label,
        ),
        autofocus: true,
        maxLength: 20,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        onChanged: (value) => cubit.updatePseudo(value ?? ''),
        onSubmitted: (_) => cubit.next(),
      ),
    );
  }
}
