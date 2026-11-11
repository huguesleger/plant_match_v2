import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_password_field.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return AuthPasswordField(
      controller: controller,
      labelText: Some(t.auth.register.confirmPassword.label),
      hintText: Some(t.auth.register.confirmPassword.hint),
      validator: Some(FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: t.auth.common.password.required),
        (val) => Option.fromPredicate(
              t.auth.register.confirmPassword.mismatch,
              (_) => val != passwordController.text,
            ).toNullable(),
      ])),
    );
  }
}
