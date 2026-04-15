import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';

class EnvironmentField extends StatelessWidget {
  const EnvironmentField({
    super.key,
    required this.selectedEnvironment,
    required this.onChanged,
  });

  final String? selectedEnvironment;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Sélectionner une catégorie pour votre plante',
      child: FormBuilderField<String>(
        name: 'category',
        initialValue: selectedEnvironment,
        validator: FormBuilderValidators.required(errorText: 'Ce champ est requis'),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SelectableItem(
                    icon: LucideIcons.house,
                    label: "Intérieur",
                    value: "indoor",
                    isSelected: selectedEnvironment == "indoor",
                    onTap: (val) {
                      onChanged(val);
                      field.didChange(val);
                      field.validate();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectableItem(
                    icon: LucideIcons.trees,
                    label: "Extérieur",
                    value: "outdoor",
                    isSelected: selectedEnvironment == "outdoor",
                    onTap: (val) {
                      onChanged(val);
                      field.didChange(val);
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
}
