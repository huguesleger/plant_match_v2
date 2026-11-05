import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class FavoriteCircleButton extends StatelessWidget {
  const FavoriteCircleButton({
    super.key,
    required this.catalog,
    required this.currentUserId,
  });

  final Catalog catalog;
  final Option<String> currentUserId;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.greyLight),
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: FavoriteBtn(
          catalog: Some(catalog),
          currentUserId: currentUserId,
        ),
      );
}
