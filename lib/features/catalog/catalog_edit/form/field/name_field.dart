import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'name',
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: DecorationInput.inputDecoration(
        hintText: 'Nom de la plante',
        labelText: 'Nom',
      ),
      validator: FormBuilderValidators.required(errorText: 'Ce champ est requis'),
    );
  }
}
