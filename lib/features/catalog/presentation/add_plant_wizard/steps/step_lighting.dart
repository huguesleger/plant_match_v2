import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/title_with_icon/title_with_icon.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class StepLighting extends StatelessWidget {
  const StepLighting({
    super.key,
    required this.formKey,
    required this.selected,
    required this.onSelect,
  });

  final GlobalKey<FormBuilderState> formKey;
  final Lighting? selected;
  final Function(Lighting) onSelect;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.lighting.title,
        description: t.catalog.wizard.steps.lighting.description,
        child: FormBuilderField<Lighting>(
          name: 'lighting',
          initialValue: selected,
          validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field,
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  TitleWithIcon(
                    icon: LucideIcons.sun,
                    title: t.catalog.wizard.steps.lighting.label,
                    bgColor: AppColors.greenDark,
                    iconColor: AppColors.greenLight,
                  ),
                  const SizedBox(height: 10),
                  ItemRadio<Lighting>(
                    title: t.catalog.wizard.steps.lighting.sun,
                    value: Lighting.sun,
                    selectedItem: selected,
                    onItemSelected: (v) {
                      onSelect(v);
                      field.didChange(v);
                      field.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  ItemRadio<Lighting>(
                    title: t.catalog.wizard.steps.lighting.indirect,
                    value: Lighting.indirectLight,
                    selectedItem: selected,
                    onItemSelected: (v) {
                      onSelect(v);
                      field.didChange(v);
                      field.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  ItemRadio<Lighting>(
                    title: t.catalog.wizard.steps.lighting.shade,
                    value: Lighting.shade,
                    selectedItem: selected,
                    onItemSelected: (v) {
                      onSelect(v);
                      field.didChange(v);
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
