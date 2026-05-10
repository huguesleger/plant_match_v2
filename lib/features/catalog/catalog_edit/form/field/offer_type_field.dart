import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';

class OfferTypeField extends StatelessWidget {
  const OfferTypeField({
    super.key,
    required this.selectedOfferType,
    required this.onChanged,
  });

  final OfferType? selectedOfferType;
  final ValueChanged<OfferType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: t.catalog.edit.offer_type.title,
      child: FormBuilderField<OfferType>(
        name: 'offerType',
        initialValue: selectedOfferType,
        validator: FormBuilderValidators.required(
            errorText: t.catalog.wizard.required_field),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SelectableItem<OfferType>(
                    icon: LucideIcons.gift,
                    label: t.catalog.wizard.steps.offer_type.donation,
                    value: OfferType.donation,
                    isSelected: selectedOfferType == OfferType.donation,
                    onTap: (val) {
                      onChanged(val);
                      field.didChange(val);
                      field.validate();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectableItem<OfferType>(
                    icon: LucideIcons.heart_handshake,
                    label: t.catalog.wizard.steps.offer_type.exchange,
                    value: OfferType.exchange,
                    isSelected: selectedOfferType == OfferType.exchange,
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
