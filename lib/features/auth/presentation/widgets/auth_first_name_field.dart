import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';

class AuthFirstNameField extends StatelessWidget {
  const AuthFirstNameField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'firstName',
      decoration: DecorationInput.inputDecoration(
        hintText: t.auth.common.firstName.hint,
        labelText: t.auth.common.firstName.label,
      ),
      validator:
          FormBuilderValidators.required(errorText: t.auth.common.firstName.required),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
    );
  }
}
