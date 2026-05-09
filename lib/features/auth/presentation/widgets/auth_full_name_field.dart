import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';

class AuthFullNameField extends StatelessWidget {
  const AuthFullNameField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'fullName',
      decoration: DecorationInput.inputDecoration(
        hintText: t.auth.common.fullName.hint,
        labelText: t.auth.common.fullName.label,
      ),
      validator:
          FormBuilderValidators.required(errorText: t.auth.common.fullName.required),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
    );
  }
}
