import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/title_with_icon/title_with_icon.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class StepMaintenance extends StatelessWidget {
  const StepMaintenance({
    super.key,
    required this.formKey,
    required this.selected,
    required this.onSelect,
  });

  final GlobalKey<FormBuilderState> formKey;
  final String? selected;
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: 'Entretien',
        description: 'Niveau de difficulté',
        child: FormBuilderField(
          name: 'maintenance',
          initialValue: selected,
          validator: FormBuilderValidators.required(
            errorText: 'Ce champ est requis',
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const TitleWithIcon(
                    icon: LucideIcons.shovel,
                    title: 'Difficulté',
                    bgColor: AppColors.greenDark,
                    iconColor: AppColors.greenLight,
                  ),
                  const SizedBox(height: 10),
                  ItemRadio(
                    title: 'Facile',
                    value: 'low',
                    selectedItem: selected,
                    onItemSelected: (v) {
                      onSelect(v);
                      field.didChange(v);
                      field.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  ItemRadio(
                    title: 'Moyen',
                    value: 'medium',
                    selectedItem: selected,
                    onItemSelected: (v) {
                      onSelect(v);
                      field.didChange(v);
                      field.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  ItemRadio(
                    title: 'Difficile',
                    value: 'high',
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
