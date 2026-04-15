import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';

class StepOfferType extends StatelessWidget {
  const StepOfferType({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onSelect,
  });

  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: 'Offre',
        description: 'Que faire de votre plante ?',
        child: FormBuilderField(
          name: 'offerType',
          initialValue: controller.text,
          validator: FormBuilderValidators.required(
            errorText: 'Ce champ est requis',
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.gift,
                      label: 'Donation',
                      value: 'donation',
                      isSelected: controller.text == 'donation',
                      onTap: (v) {
                        onSelect(v);
                        field.didChange(v);
                        field.validate();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableItem(
                      icon: LucideIcons.heart_handshake,
                      label: 'Echange',
                      value: 'exchange',
                      isSelected: controller.text == 'exchange',
                      onTap: (v) {
                        onSelect(v);
                        field.didChange(v);
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
