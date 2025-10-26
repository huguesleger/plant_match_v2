import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class CatalogUploadImage extends StatefulWidget {
  final Catalog catalog;
  final FormFieldState<List<String>>? field;
  final ValueChanged<Catalog>? onCatalogUpdated;

  const CatalogUploadImage({
    super.key,
    required this.catalog,
    this.field,
    this.onCatalogUpdated,
  });

  @override
  State<CatalogUploadImage> createState() => _CatalogUploadImageState();
}

class _CatalogUploadImageState extends State<CatalogUploadImage> {
  final ImagePicker _picker = ImagePicker();
  static const int maxImages = 3;
  List<String> catalogImages = [];

  @override
  void initState() {
    super.initState();
    catalogImages = widget.catalog.images;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyFieldChanged(catalogImages);
    });
  }

  void _notifyFieldChanged(List<String> urls) {
    widget.field?.didChange(urls);
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        maxHeight: 500,
        limit: maxImages,
      );
      if (pickedFiles.isEmpty) return;

      final availableSlots = maxImages - catalogImages.length;
      final localPaths =
          pickedFiles.take(availableSlots).map((x) => x.path).toList();

      if (localPaths.isEmpty) return;

      setState(() {
        catalogImages.addAll(localPaths);
      });

      final updatedCatalog = widget.catalog.copyWith(newImages: catalogImages);
      _notifyFieldChanged(catalogImages);
      widget.onCatalogUpdated?.call(updatedCatalog);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la sélection d’image.')),
        );
      }
    }
  }

  void _deleteImage(int index) {
    setState(() {
      catalogImages.removeAt(index);
    });

    final updatedCatalog = widget.catalog.copyWith(newImages: catalogImages);
    _notifyFieldChanged(catalogImages);
    widget.onCatalogUpdated?.call(updatedCatalog);
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, width: 56, height: 56, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), width: 56, height: 56, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greenLight.withValues(alpha: 0.1),
              border: const DashedBorder(
                dashLength: 8,
                left: BorderSide(color: AppColors.blueGreen, width: 2),
                top: BorderSide(color: AppColors.blueGreen, width: 2),
                right: BorderSide(color: AppColors.blueGreen, width: 2),
                bottom: BorderSide(color: AppColors.blueGreen, width: 2),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/images/upload_images.png'),
                  height: 130,
                ),
                const SizedBox(height: 10),
                ButtonRounded(
                  text: 'Sélectionner des images',
                  onPressed:
                      catalogImages.length < maxImages ? _pickImages : null,
                  bgColor: AppColors.blueGreen,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
        if (catalogImages.isNotEmpty) ...[
          const SizedBox(height: 20),
          SizedBox(
            height: 216,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: catalogImages.length,
              itemBuilder: (_, index) {
                final imagePath = catalogImages[index];
                return ListTile(
                  tileColor: AppColors.white,
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _buildImage(imagePath),
                  ),
                  title: Text(
                    "Image ${index + 1}",
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                      color: AppColors.greyDark,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () => _deleteImage(index),
                    icon: const Icon(LucideIcons.x, size: AppTypo.text),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
