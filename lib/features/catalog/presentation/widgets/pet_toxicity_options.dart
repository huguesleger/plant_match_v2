import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/item_radio.dart';

class PetToxicityOptions extends StatelessWidget {
  const PetToxicityOptions({
    super.key,
    required this.field,
    required this.selected,
    required this.onSelect,
  });

  final FormFieldState<PetToxicity> field;
  final Option<PetToxicity> selected;
  final ValueChanged<PetToxicity> onSelect;

  static const List<PetToxicity> values = [
    PetSafe(),
    PetToxic(),
    PetToxicityUnknown(),
  ];

  static String subtitleOf(PetToxicity toxicity) => switch (toxicity) {
        PetSafe() => t.catalog.wizard.steps.pet_toxicity.safe_subtitle,
        PetToxic() => t.catalog.wizard.steps.pet_toxicity.toxic_subtitle,
        PetToxicityUnknown() =>
          t.catalog.wizard.steps.pet_toxicity.unknown_subtitle,
      };

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...values.map(
            (toxicity) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ItemRadio<PetToxicity>(
                title: toxicity.label,
                subtitle: Some(subtitleOf(toxicity)),
                value: toxicity,
                selectedItem: selected,
                onItemSelected: (value) {
                  onSelect(value);
                  field.didChange(value);
                  field.validate();
                },
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                Option.fromNullable(field.errorText).getOrElse(() => ''),
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
}
