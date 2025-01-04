import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_cubit.dart';

void showImageSourceBottomSheet({
  required BuildContext context,
  required ProfilUser profilUser,
  required Future<void> Function(ImageSource source) onPickImage,
}) {
  AppBottomSheet.showBottomSheet(
    context,
    SizedBox(
      height: 450,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.greyLight,
                ),
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: TitlePage(
                  title: 'Photo de profil',
                  fontSize: 18,
                  color: AppColors.greyDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: AppColors.greenLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(LucideIcons.image, color: AppColors.blueGreen),
            ),
            title: const Text(
              'Choisir depuis la galerie',
              style: TextStyle(color: AppColors.greyMedium),
            ),
            onTap: () async {
              Navigator.pop(context);
              await onPickImage(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: AppColors.greenLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(LucideIcons.camera, color: AppColors.blueGreen),
            ),
            title: const Text(
              'Prendre une photo',
              style: TextStyle(color: AppColors.greyMedium),
            ),
            onTap: () async {
              Navigator.pop(context);
              await onPickImage(ImageSource.camera);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: AppColors.greenLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child:
                  const Icon(LucideIcons.image_off, color: AppColors.blueGreen),
            ),
            title: const Text(
              'Aucune photo',
              style: TextStyle(color: AppColors.greyMedium),
            ),
            onTap: () {
              Navigator.pop(context);
              context
                  .read<ProfilCubit>()
                  .deleteImageProfile(profilUser.profilImg);
            },
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ButtonOutlinedRounded(
                text: 'Annuler',
                onPressed: () {
                  Navigator.pop(context);
                },
                borderColor: AppColors.greyLight,
                textColor: AppColors.blueGreen,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
