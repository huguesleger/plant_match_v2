import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_content.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: Some(t.favorite.screen.title),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: const Some(AppColors.black),
        styleIconButton: Some(IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        )),
        onPressed: Some(() => Navigator.pop(context)),
      ),
      body: FavoriteContent(uid: uid),
    );
  }
}
