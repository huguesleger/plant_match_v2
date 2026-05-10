import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class SelectableItem<T> extends StatelessWidget {
  const SelectableItem({
    super.key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  final String label;
  final T value;
  final bool isSelected;
  final Function(T) onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        //height: 124,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenDark.withValues(alpha: 0.1)
              : AppColors.greyUltraLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.greenDark : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppTypo.textXxl,
              color: isSelected ? AppColors.greenDark : AppColors.greyDark,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypo.textXs,
                color: isSelected ? AppColors.greenDark : AppColors.greyDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
