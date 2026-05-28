import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';

class AuthLastNameField extends StatelessWidget {
  const AuthLastNameField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'lastName',
      decoration: DecorationInput.inputDecoration(
        hintText: t.auth.common.lastName.hint,
        labelText: t.auth.common.lastName.label,
      ),
      validator:
          FormBuilderValidators.required(errorText: t.auth.common.lastName.required),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
    );
  }
}
