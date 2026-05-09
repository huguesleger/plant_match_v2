import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/widgets/form/decoration_input.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';

class StepName extends StatelessWidget {
  const StepName({super.key, required this.formKey, required this.controller});
  
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.name.title,
        description: t.catalog.wizard.steps.name.description,
        child: FormBuilderTextField(
          name: 'name',
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: DecorationInput.inputDecoration(
            hintText: t.catalog.wizard.steps.name.hint,
            labelText: t.catalog.wizard.steps.name.label,
          ),
          validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field,
          ),
        ),
      );
}
