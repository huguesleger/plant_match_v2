import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/title_with_icon/title_with_icon.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/pet_toxicity_options.dart';

class StepPetToxicity extends StatelessWidget {
  const StepPetToxicity({
    super.key,
    required this.formKey,
    required this.selected,
    required this.onSelect,
  });

  final GlobalKey<FormBuilderState> formKey;
  final Option<PetToxicity> selected;
  final ValueChanged<PetToxicity> onSelect;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.pet_toxicity.title,
        description: t.catalog.wizard.steps.pet_toxicity.description,
        child: FormBuilderField<PetToxicity>(
          name: 'petToxicity',
          initialValue: selected.toNullable(),
          validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field,
          ),
          builder: (field) => Column(
            children: [
              TitleWithIcon(
                icon: LucideIcons.paw_print,
                title: t.catalog.wizard.steps.pet_toxicity.label,
                bgColor: AppColors.greenDark,
                iconColor: AppColors.greenLight,
              ),
              const SizedBox(height: 10),
              PetToxicityOptions(
                field: field,
                selected: selected,
                onSelect: onSelect,
              ),
            ],
          ),
        ),
      );
}
