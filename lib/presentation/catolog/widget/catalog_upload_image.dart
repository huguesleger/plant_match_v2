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

  @override
  void initState() {
    super.initState();
    _loadInitialCatalogImages();
  }

  Future<void> _loadInitialCatalogImages() async {
    final currentState = context.read<CatalogCubit>().state;
    if (currentState is CatalogLoaded) {
      final matching =
          currentState.catalogs.where((c) => c.uid == widget.catalogId);
      if (matching.isNotEmpty) {
        setState(() => catalogImages = matching.first.images);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialCatalogImages();
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (!mounted || images.isEmpty) return;

    final availableSlots = maxImages - (catalogImages.length);
    if (availableSlots <= 0) {
      _showMaxImagesAlert();
      return;
    }

    final toAdd = images.take(availableSlots);
    final filesToUpload = toAdd.map((x) => File(x.path)).toList();

    setState(() => catalogImages.addAll(filesToUpload.map((f) => f.path)));

    // Upload images to Firebase
    await context.read<CatalogCubit>().uploadImagesToCatalog(
          widget.userId,
          widget.catalogId,
          filesToUpload.map((f) => f.path).toList(),
        );

    // Recharge images depuis Firebase pour éviter les problèmes
    await _loadInitialCatalogImages();
    widget.field?.didChange(catalogImages.map((p) => File(p)).toList());
  }

  void _deleteImage(int index) {
    final path = catalogImages[index];

    setState(() => catalogImages.removeAt(index));
    widget.field?.didChange(catalogImages.map((p) => File(p)).toList());

    // Optionnel : supprimer aussi du backend via Cubit si nécessaire
  }

  void _showMaxImagesAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vous ne pouvez ajouter que 3 images.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bloc UI pour le bouton de sélection d'image
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
        // Bloc UI pour afficher les images déjà sélectionnées ou uploadées
        if (catalogImages.isNotEmpty)
          SizedBox(
            height:
                200, // Contraint la hauteur du ListView pour éviter des problèmes de Flex
            child: ListView.builder(
              itemCount: catalogImages.length,
              itemBuilder: (_, index) {
                final imagePath = catalogImages[index];

                return Column(
                  key: ValueKey(imagePath),
                  children: [
                    ListTile(
                      tileColor: AppColors.white,
                      contentPadding: EdgeInsets.zero,
                      leading: imagePath.startsWith('http')
                          ? Image.network(imagePath,
                              width: 56, height: 56, fit: BoxFit.cover)
                          : Image.file(File(imagePath),
                              width: 56, height: 56, fit: BoxFit.cover),
                      title: Text(
                        "Image ${index + 1}",
                        style: InterTextStyle.inter(AppTypo.textS,
                            color: AppColors.greyDark),
                      ),
                      trailing: IconButton(
                        onPressed: () => _deleteImage(index),
                        icon: const Icon(LucideIcons.x, size: AppTypo.text),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          )
        else
          const Center(child: Text("Aucune image sélectionnée")),
      ],
    );
  }
}
