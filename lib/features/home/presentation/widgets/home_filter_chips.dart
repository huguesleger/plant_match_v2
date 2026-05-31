import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

enum HomeFilterOption {
  all,
  donation,
  exchange,
  cutting,
  rare,
}

class HomeFilterChips extends StatelessWidget {
  const HomeFilterChips({
    super.key,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  final HomeFilterOption selectedOption;
  final ValueChanged<HomeFilterOption> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final filters = [
      (HomeFilterOption.all, "Tout", LucideIcons.layout_grid),
      (HomeFilterOption.donation, "Don", LucideIcons.leaf),
      (HomeFilterOption.exchange, "Échange", LucideIcons.arrow_left_right),
      (HomeFilterOption.cutting, "Bouture", LucideIcons.sprout),
      (HomeFilterOption.rare, "Rare", LucideIcons.gem),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedOption == filter.$1;

          return InkWell(
            onTap: () => onOptionSelected(filter.$1),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.greenDark : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.greyLight.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    filter.$3,
                    color: isSelected ? AppColors.white : AppColors.black,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter.$2,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontSize: AppTypo.textXs,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
