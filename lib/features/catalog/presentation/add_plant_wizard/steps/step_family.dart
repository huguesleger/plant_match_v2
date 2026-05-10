import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/grid_selectable_item.dart';

class StepFamily extends StatelessWidget {
  const StepFamily({
    super.key,
    required this.formKey,
    required this.selectedValues,
    required this.onSelect,
  });

  final GlobalKey<FormBuilderState> formKey;
  final List<Family> selectedValues;
  final Function(Family) onSelect;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.family.title,
        description: t.catalog.wizard.steps.family.description,
        child: FormBuilderField(
          name: 'family',
          initialValue: selectedValues,
          validator: FormBuilderValidators.minLength(
            1,
            errorText: t.catalog.wizard.required_field,
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridSelectableItem(
                selectedValues: selectedValues,
                onSelect: (v) {
                  onSelect(v);
                  field.didChange(selectedValues);
                  field.validate();
                },
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
