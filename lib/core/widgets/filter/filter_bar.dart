import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_badge.dart';

class FilterBar<T> extends StatelessWidget {
  final List<T> filters;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final IconData Function(T) iconBuilder;

  const FilterBar({
    super.key,
    required this.filters,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
    required this.iconBuilder,
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
          itemCount: filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final filter = filters[index];
            return FilterBadge(
              label: labelBuilder(filter),
              icon: iconBuilder(filter),
              isSelected: selected == filter,
              onTap: () => onChanged(filter),
            );
          },
        ),
      ),
    );
  }
}
