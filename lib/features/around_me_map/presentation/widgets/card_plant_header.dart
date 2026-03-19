import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class CardPlantHeader extends StatelessWidget {
  const CardPlantHeader({
    super.key,
    required this.catalog,
    required this.currentUserId,
  });

  final Catalog catalog;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.network(
            catalog.images.isNotEmpty ? catalog.images.first : '',
            height: 120,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: FavoriteBtn(
              catalog: catalog,
              currentUserId: currentUserId,
            ),
          ),
        ),
      ],
    );
  }
}
