import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class WateringField extends StatelessWidget {
  const WateringField({
    super.key,
    required this.selectedWatering,
    required this.onChanged,
  });

  final Watering? selectedWatering;
  final ValueChanged<Watering?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: t.catalog.edit.watering.title,
      child: FormBuilderField<Watering>(
        name: 'watering',
        initialValue: selectedWatering,
        validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ItemRadio<Watering>(
                  title: t.catalog.wizard.steps.watering.little,
                  value: Watering.little,
                  selectedItem: selectedWatering,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio<Watering>(
                  title: t.catalog.wizard.steps.watering.regularly,
                  value: Watering.regularly,
                  selectedItem: selectedWatering,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
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
}
