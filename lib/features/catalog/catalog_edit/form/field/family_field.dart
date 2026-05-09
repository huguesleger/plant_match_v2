import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/grid_selectable_item.dart';

class FamilyField extends StatelessWidget {
  const FamilyField({
    super.key,
    required this.selectedFamilies,
    required this.onSelect,
  });

  final List<String> selectedFamilies;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: t.catalog.edit.family.title,
      child: FormBuilderField<List<String>>(
        name: 'family',
        initialValue: selectedFamilies,
        validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridSelectableItem(
              selectedValues: selectedFamilies,
              onSelect: (val) {
                onSelect(val);
                field.didChange(selectedFamilies);
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
}
