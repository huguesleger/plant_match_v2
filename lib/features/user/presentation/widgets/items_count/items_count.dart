import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/items_count/item_count.dart';

class ItemsCount extends StatelessWidget {
  const ItemsCount({
    super.key,
    required this.catalog,
    required this.level,
    required this.exchangeCount,
  });

  final List<Catalog> catalog;
  final int level;
  final int exchangeCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontal,
      child: Row(
        children: [
          ItemCount(
            count: catalog.length.toString(),
            text: t.user.stats.plants(n: catalog.length),
            icon: LucideIcons.flower_2,
          ),
          const SizedBox(width: 10),
          ItemCount(
            count: exchangeCount.toString(),
            text: t.user.stats.matches,
            icon: LucideIcons.heart_handshake,
          ),
          const SizedBox(width: 10),
          ItemCount(
            count: level.toString(),
            text: t.user.stats.level,
            isLevel: true,
            sup: t.user.stats.level_suffix(n: level),
            icon: LucideIcons.award,
          ),
        ],
      ),
    );
  }
}
