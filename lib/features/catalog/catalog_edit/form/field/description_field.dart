import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
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
      title: t.catalog.edit.description.title,
      child: FormBuilderTextField(
        maxLines: 4,
        maxLength: 150,
        name: 'description',
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: DecorationInput.inputDecoration(
          hintText: t.catalog.edit.description.hint,
          labelText: t.catalog.edit.description.label,
          alignLabelWithHint: true,
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: t.catalog.wizard.required_field),
          FormBuilderValidators.maxLength(150,
              errorText: t.catalog.edit.description.max_length),
        ]),
      ),
    );
  }
}
