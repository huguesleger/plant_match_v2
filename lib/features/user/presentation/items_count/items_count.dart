import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/presentation/items_count/item_count.dart';

class ItemsCount extends StatelessWidget {
  const ItemsCount({super.key, required this.catalog, required this.level});

  final List<Catalog> catalog;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontal,
      child: Row(
        children: [
          ItemCount(
            count: catalog.length.toString(),
            text: catalog.length > 1 ? 'plantes' : 'plante',
            icon: LucideIcons.flower_2,
          ),
          const SizedBox(width: 10),
          const ItemCount(
            //TODO: Update this count when the feature is implemented
            count: '5',
            text: 'plantMatch',
            icon: LucideIcons.heart_handshake,
          ),
          const SizedBox(width: 10),
          ItemCount(
            count: level.toString(),
            text: 'niveau',
            isLevel: true,
            sup: level <= 1 ? 'er' : 'ème',
            icon: LucideIcons.award,
          ),
        ],
      ),
    );
  }
}
