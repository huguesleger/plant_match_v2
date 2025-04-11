import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';

class CatalogUploadImage extends StatefulWidget {
  final String userId;
  final String catalogId;
  final FormFieldState<dynamic>? field;

  const CatalogUploadImage({
    super.key,
    required this.userId,
    required this.catalogId,
    this.field,
  });

  @override
  State<CatalogUploadImage> createState() => _CatalogUploadImageState();
}

class _CatalogUploadImageState extends State<CatalogUploadImage> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  List<String> catalogImages = [];
  static const int maxImages = 3;

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();

    if (mounted && images.isNotEmpty) {
      int availableSlots =
          maxImages - (_selectedImages.length + catalogImages.length);
      if (availableSlots <= 0) {
        _showMaxImagesAlert();
        return;
      }

      List<XFile> imagesToAdd = images.take(availableSlots).toList();
      List<File> filesToUpload =
          imagesToAdd.map((img) => File(img.path)).toList();

      print(
          "📷 Images sélectionnées: ${filesToUpload.map((f) => f.path).toList()}");

      setState(() {
        _selectedImages.addAll(filesToUpload);
      });

      // Appel Cubit → upload dans Firebase et mise à jour du catalog
      await context
          .read<CatalogCubit>()
          .updateImageCatalog(widget.catalogId, filesToUpload);

      // Marquer le champ comme "valide"
      widget.field?.didChange(_selectedImages);
    }
  }

  void _deleteImage(int index, {bool isUploaded = false}) {
    setState(() {
      if (isUploaded) {
        catalogImages.removeAt(index);
      } else {
        _selectedImages.removeAt(index);
      }
    });
    widget.field?.didChange(_selectedImages);
  }

  void _showMaxImagesAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vous ne pouvez ajouter que 3 images."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state is CatalogLoaded) {
          catalogImages = state.catalog.images;
          print("🖼️ Images du catalogue: $catalogImages");
        }

        return Column(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              padding: EdgeInsets.zero,
              dashPattern: const [6, 3],
              color: AppColors.blueGreen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.greenLight.withOpacity(0.1),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
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
                            (_selectedImages.length + catalogImages.length) <
                                    maxImages
                                ? _pickImages
                                : null,
                        bgColor: AppColors.blueGreen,
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (widget.field?.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  widget.field!.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: (catalogImages.isNotEmpty || _selectedImages.isNotEmpty)
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: catalogImages.length + _selectedImages.length,
                      itemBuilder: (context, index) {
                        bool isUploaded = index < catalogImages.length;
                        String imagePath = isUploaded
                            ? catalogImages[index]
                            : _selectedImages[index - catalogImages.length]
                                .path;

                        return Column(
                          children: [
                            ListTile(
                              tileColor: AppColors.white,
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: imagePath.contains('http')
                                    ? Image.network(imagePath,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover)
                                    : Image.file(File(imagePath),
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover),
                              ),
                              title: Text(
                                "Image ${index + 1}",
                                style: InterTextStyle.inter(
                                  AppTypo.textS,
                                  color: AppColors.greyDark,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () =>
                                    _deleteImage(index, isUploaded: isUploaded),
                                icon: const Icon(LucideIcons.x,
                                    size: AppTypo.text),
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    )
                  : const Center(child: Text("Aucune image sélectionnée")),
            ),
          ],
        );
      },
    );
  }
}
