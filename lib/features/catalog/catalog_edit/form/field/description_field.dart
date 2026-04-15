import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Ajouter une brève description',
      child: FormBuilderTextField(
        maxLines: 4,
        maxLength: 150,
        name: 'description',
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: DecorationInput.inputDecoration(
          hintText: 'Description de la plante',
          labelText: 'Description',
          alignLabelWithHint: true,
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Ce champ est requis'),
          FormBuilderValidators.maxLength(150, errorText: 'Maximum 150 caractères'),
        ]),
      ),
    );
  }
}
