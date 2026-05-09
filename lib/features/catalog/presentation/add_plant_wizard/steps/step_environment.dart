import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';

class StepEnvironment extends StatelessWidget {
  const StepEnvironment({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.category.title,
        description: t.catalog.wizard.steps.category.description,
        child: FormBuilderField(
          name: 'category',
          initialValue: controller.text,
          validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field,
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.house,
                      label: t.catalog.wizard.steps.category.indoor,
                      value: Environment.indoor.name,
                      isSelected: controller.text == Environment.indoor.name,
                      onTap: (v) {
                        controller.text = v;
                        field.didChange(v);
                        field.validate();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.trees,
                      label: t.catalog.wizard.steps.category.outdoor,
                      value: Environment.outdoor.name,
                      isSelected: controller.text == Environment.outdoor.name,
                      onTap: (v) {
                        controller.text = v;
                        field.didChange(v);
                        field.validate();
                      },
                    ),
                  ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      );
}
