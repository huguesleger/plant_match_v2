import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/cubit/detail_wizard_cubit.dart';
import 'package:plant_match_v2/features/personal_information/presentation/wizard/wizard_item.dart';

class WizardBirthdayForm extends StatelessWidget {
  const WizardBirthdayForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DetailWizardCubit>();
    final birthday = cubit.state.draft.birthdayDate.toNullable();

    return DetailWizardItem(
      title: t.personalInformation.wizard.birthday.title,
      description: t.personalInformation.wizard.birthday.description,
      child: FormBuilderDateTimePicker(
        name: 'dateOfBirth',
        inputType: InputType.date,
        initialDate: birthday,
        initialValue: birthday,
        format: DateFormat('dd/MM/yyyy'),
        lastDate: DateTime.now(),
        decoration: DecorationInput.inputDecoration(
          hintText: t.personalInformation.wizard.birthday.hint,
          labelText: t.personalInformation.wizard.birthday.label,
          suffixIcon: const Some(Icon(LucideIcons.calendar)),
        ),
        locale: const Locale('fr', 'FR'),
        onChanged: (date) => cubit.updateBirthday(Option.fromNullable(date)),
      ),
    );
  }
}
