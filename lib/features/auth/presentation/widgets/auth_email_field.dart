import 'package:flutter/material.dart';
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
        hintText: 'Entrez votre e-mail',
        labelText: 'E-mail',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Ce champ est requis'),
        FormBuilderValidators.email(errorText: 'Entrez un e-mail valide'),
      ]),
    );
  }
}
