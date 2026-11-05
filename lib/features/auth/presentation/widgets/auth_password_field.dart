import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    this.labelText = const None(),
    this.hintText = const None(),
    this.validator = const None(),
  });

  final TextEditingController controller;
  final Option<String> labelText;
  final Option<String> hintText;
  final Option<FormFieldValidator<String>> validator;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelText = 
        widget.labelText.getOrElse(() => t.auth.common.password.label);
    final effectiveHintText = 
        widget.hintText.getOrElse(() => t.auth.common.password.hint);

    return FormBuilderTextField(
      name: effectiveLabelText.toLowerCase().replaceAll(' ', '_'),
      decoration: DecorationInput.inputDecoration(
        hintText: effectiveHintText,
        labelText: effectiveLabelText,
        suffixIcon: Some(IconButton(
          icon: Icon(
            _obscureText ? LucideIcons.eye : LucideIcons.eye_off,
            color: AppColors.greyDark,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        )),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator.getOrElse(
        () => FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: t.auth.common.password.required),
        ]),
      ),
    );
  }
}
