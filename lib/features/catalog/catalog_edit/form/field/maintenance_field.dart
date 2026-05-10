import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class MaintenanceField extends StatelessWidget {
  const MaintenanceField({
    super.key,
    required this.selectedMaintenance,
    required this.onChanged,
  });

  final LevelMaintenance? selectedMaintenance;
  final ValueChanged<LevelMaintenance?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: t.catalog.edit.maintenance.title,
      child: FormBuilderField<LevelMaintenance>(
        name: 'maintenance',
        initialValue: selectedMaintenance,
        validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ItemRadio<LevelMaintenance>(
                  title: t.catalog.wizard.steps.maintenance.low,
                  subtitle: t.catalog.edit.maintenance.low_subtitle,
                  value: LevelMaintenance.low,
                  selectedItem: selectedMaintenance,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio<LevelMaintenance>(
                  title: t.catalog.wizard.steps.maintenance.medium,
                  subtitle: t.catalog.edit.maintenance.medium_subtitle,
                  value: LevelMaintenance.medium,
                  selectedItem: selectedMaintenance,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio<LevelMaintenance>(
                  title: t.catalog.wizard.steps.maintenance.high,
                  subtitle: t.catalog.edit.maintenance.high_subtitle,
                  value: LevelMaintenance.high,
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
