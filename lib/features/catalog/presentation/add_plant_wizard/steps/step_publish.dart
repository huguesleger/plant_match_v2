import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';

class StepPublish extends StatelessWidget {
  const StepPublish({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onToggle,
  });

  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.publish.title,
        description: t.catalog.wizard.steps.publish.description,
        child: FormBuilderSwitch(
          name: 'publish',
          title: Text(t.catalog.wizard.publish_label),
          initialValue: controller.text == 'true',
          onChanged: (v) => onToggle(v ?? false),
        ),
      );
}
