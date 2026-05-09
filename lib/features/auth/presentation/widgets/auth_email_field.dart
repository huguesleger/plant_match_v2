import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'email',
      decoration: DecorationInput.inputDecoration(
        hintText: t.auth.common.email.hint,
        labelText: t.auth.common.email.label,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: t.auth.common.email.required),
        FormBuilderValidators.email(errorText: t.auth.common.email.invalid),
      ]),
    );
  }
}
