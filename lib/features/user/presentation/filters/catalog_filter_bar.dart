import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';
import 'package:plant_match_v2/features/user/presentation/filters/filter_badge.dart';

class CatalogFiltersBar extends StatelessWidget {
  final CatalogFilter selected;
  final ValueChanged<CatalogFilter> onChanged;

  const CatalogFiltersBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: AppColors.greyUltraLight,
        child: SizedBox(
          height: 75,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingAll,
            itemCount: CatalogFilter.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final filter = CatalogFilter.values[index];
              return FilterBadge(
                label: filter.label,
                icon: filter.icon,
                isSelected: selected == filter,
                onTap: () => onChanged(filter),
              );
            },
          ),
        ));
  }
}
