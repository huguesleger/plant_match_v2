import 'package:fpdart/fpdart.dart' hide State;
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/pet_toxicity_options.dart';

class PetToxicityField extends StatelessWidget {
  const PetToxicityField({
    super.key,
    required this.selectedToxicity,
    required this.onChanged,
  });

  final PetToxicity selectedToxicity;
  final ValueChanged<PetToxicity> onChanged;

  @override
  Widget build(BuildContext context) => FormSection(
        title: t.catalog.edit.pet_toxicity.title,
        child: FormBuilderField<PetToxicity>(
          name: 'petToxicity',
          initialValue: selectedToxicity,
          validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field,
          ),
          builder: (field) => PetToxicityOptions(
            field: field,
            selected: Some(selectedToxicity),
            onSelect: onChanged,
          ),
        ),
      );
}
