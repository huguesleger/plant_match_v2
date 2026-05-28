import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class ItemRadio<T> extends StatelessWidget {
  const ItemRadio({
    super.key,
    this.subtitle,
    required this.title,
    required this.value,
    required this.selectedItem,
    required this.onItemSelected,
  });

  final String title;
  final String? subtitle;
  final T value;
  final T? selectedItem;
  final Function(T) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedItem == value;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.greenDark : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => onItemSelected(value),
        tileColor: isSelected
            ? AppColors.greenDark.withValues(alpha: 0.1)
            : AppColors.greyUltraLight,
        title: Text(
          title,
          style: const TextStyle(
              color: AppColors.greyMedium, fontSize: AppTypo.textS),
        ),
        subtitle: Option.fromNullable(subtitle).match(
          () => null,
          (text) => Text(
            text,
            style: const TextStyle(fontSize: AppTypo.textXs),
          ),
        ),
        trailing: RadioGroup<T>(
          groupValue: selectedItem,
          onChanged: (T? newValue) =>
              Option.fromNullable(newValue).map(onItemSelected),
          child: Radio<T>(
            value: value,
            activeColor: AppColors.greenDark,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
    );
  }
}
