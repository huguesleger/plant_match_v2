import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/form/form_section.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_upload_image.dart';

class ImageField extends StatelessWidget {
  const ImageField({
    super.key,
    required this.catalog,
    required this.updatedImages,
    required this.onCatalogUpdated,
  });

  final Catalog catalog;
  final List<String> updatedImages;
  final ValueChanged<Catalog> onCatalogUpdated;

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Sélectionner une à trois photos de votre plante',
      child: FormBuilderField<List<String>>(
        name: 'images',
        initialValue: updatedImages,
        validator: FormBuilderValidators.minLength(1, errorText: 'Ce champ est requis'),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CatalogUploadImage(
              catalog: catalog.copyWith(newImages: field.value ?? []),
              field: field,
              onCatalogUpdated: (updatedCatalog) {
                onCatalogUpdated(updatedCatalog);
                field.didChange(updatedCatalog.images);
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
}
