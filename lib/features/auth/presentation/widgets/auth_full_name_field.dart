import 'package:flutter/material.dart';
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
        hintText: 'Entrez votre prénom et nom',
        labelText: 'Prénom et nom',
      ),
      validator: FormBuilderValidators.required(errorText: 'Ce champ est requis'),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
    );
  }
}
