import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/widgets/add_plant_wizard_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_upload_image.dart';

class StepImage extends StatelessWidget {
  const StepImage({
    super.key,
    required this.formKey,
    required this.catalog,
    required this.onUpdate,
  });

  final GlobalKey<FormBuilderState> formKey;
  final Catalog catalog;
  final Function(Catalog) onUpdate;

  @override
  Widget build(BuildContext context) => AddPlantWizardItem(
        formKey: formKey,
        title: t.catalog.wizard.steps.image.title,
        description: t.catalog.wizard.steps.image.description,
        child: FormBuilderField<List<String>>(
          name: 'images',
          initialValue: catalog.images,
          validator: FormBuilderValidators.minLength(
            1,
            errorText: t.catalog.wizard.required_field,
          ),
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CatalogUploadImage(
                catalog: catalog,
                field: field,
                onCatalogUpdated: (c) {
                  onUpdate(c);
                  field.didChange(c.images);
                  field.validate();
                },
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
