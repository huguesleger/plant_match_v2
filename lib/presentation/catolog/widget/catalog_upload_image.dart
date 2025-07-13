import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';

class CatalogUploadImage extends StatefulWidget {
  final String userId;
  final String catalogId;
  final FormFieldState<dynamic>? field;
  final Catalog catalog;
  final void Function(Catalog updated)? onCatalogUpdated;

  const CatalogUploadImage({
    super.key,
    required this.userId,
    required this.catalogId,
    this.field,
    required this.catalog,
    this.onCatalogUpdated,
  });

  @override
  State<CatalogUploadImage> createState() => _CatalogUploadImageState();
}

class _CatalogUploadImageState extends State<CatalogUploadImage> {
  final ImagePicker _picker = ImagePicker();
  static const int maxImages = 3;
  List<String> catalogImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    catalogImages =
        widget.catalog.images.where((img) => img.startsWith('http')).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyFieldChangedErrorMessage(catalogImages);
    });
  }

  void _notifyFieldChangedErrorMessage(List<String> urls) {
    if (widget.field != null && urls.isNotEmpty) {
      widget.field!.didChange(urls.map((_) => File('')).toList());
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        imageQuality: 50,
        maxHeight: 500,
        limit: maxImages,
      );
      if (pickedFiles.isEmpty) return;

      final availableSlots = maxImages - catalogImages.length;
      final localPaths =
          pickedFiles.take(availableSlots).map((x) => x.path).toList();

      if (localPaths.isEmpty) return;

      await _uploadImages(localPaths);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la sélection d’image.')),
      );
    }
  }

  Future<void> _uploadImages(List<String> localPaths) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final catalogCubit = context.read<CatalogCubit>();

      final updatedCatalog = await catalogCubit.uploadCatalogImages(
        catalog: widget.catalog,
        catalogId: widget.catalog.catalogId ?? widget.catalogId,
        imagePaths: localPaths,
        existingImages: catalogImages,
      );

      if (!mounted || updatedCatalog == null) return;

      final firebaseUrls =
          updatedCatalog.images.where((url) => url.startsWith('http')).toList();

      setState(() {
        catalogImages = firebaseUrls;
        _isLoading = false;
      });

      _notifyFieldChanged(firebaseUrls);
      widget.onCatalogUpdated?.call(updatedCatalog);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une erreur est survenue lors de l’upload.'),
        ),
      );
    }
  }

  void _deleteImage(int index) async {
    final imageUrlToDelete = catalogImages[index];

    final updatedCatalog =
        await context.read<CatalogCubit>().deleteImageCatalog(
              catalog: widget.catalog,
              imageUrl: imageUrlToDelete,
            );

    if (updatedCatalog == null || !mounted) return;

    setState(() {
      catalogImages = updatedCatalog.images;
    });

    _notifyFieldChanged(catalogImages);
    widget.onCatalogUpdated
        ?.call(widget.catalog.copyWith(newImages: catalogImages));
  }

  void _notifyFieldChanged(List<String> urls) {
    widget.field?.didChange(urls.map((_) => File('')).toList());
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
              color: AppColors.greenLight.withOpacity(0.1),
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
        if (_isLoading || catalogImages.isNotEmpty) ...[
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
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
                      child: Image.network(
                        imagePath,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
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
        ]
      ],
    );
  }
}
