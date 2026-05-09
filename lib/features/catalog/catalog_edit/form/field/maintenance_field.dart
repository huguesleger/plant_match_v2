import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class MaintenanceField extends StatelessWidget {
  const MaintenanceField({
    super.key,
    required this.selectedMaintenance,
    required this.onChanged,
  });

  final String? selectedMaintenance;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: t.catalog.edit.maintenance.title,
      child: FormBuilderField<String>(
        name: 'maintenance',
        initialValue: selectedMaintenance,
        validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ItemRadio(
                  title: t.catalog.wizard.steps.maintenance.low,
                  subtitle: t.catalog.edit.maintenance.low_subtitle,
                  value: 'low',
                  selectedItem: selectedMaintenance,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio(
                  title: t.catalog.wizard.steps.maintenance.medium,
                  subtitle: t.catalog.edit.maintenance.medium_subtitle,
                  value: 'medium',
                  selectedItem: selectedMaintenance,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio(
                  title: t.catalog.wizard.steps.maintenance.high,
                  subtitle: t.catalog.edit.maintenance.high_subtitle,
                  value: 'high',
                  selectedItem: selectedMaintenance,
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
