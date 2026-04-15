import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class LightingField extends StatelessWidget {
  const LightingField({
    super.key,
    required this.selectedLighting,
    required this.onChanged,
  });

  final String? selectedLighting;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Sélectionner le besoin en lumière',
      child: FormBuilderField<String>(
        name: 'lighting',
        initialValue: selectedLighting,
        validator: FormBuilderValidators.required(errorText: 'Ce champ est requis'),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ItemRadio(
                  title: 'Soleil directe',
                  value: 'sun',
                  selectedItem: selectedLighting,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio(
                  title: 'Lumière indirecte',
                  value: 'indirectLight',
                  selectedItem: selectedLighting,
                  onItemSelected: (val) {
                    onChanged(val);
                    field.didChange(val);
                    field.validate();
                  },
                ),
                const SizedBox(height: 20),
                ItemRadio(
                  title: 'Ombre',
                  value: 'shade',
                  selectedItem: selectedLighting,
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
