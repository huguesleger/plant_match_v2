import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/family_items.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/selectable_item.dart';

class GridSelectableItem extends StatelessWidget {
  const GridSelectableItem({
    super.key,
    required this.selectedValues,
    required this.onSelect,
  });

  final List<String> selectedValues;
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: familyItems.length,
      itemBuilder: (context, index) {
        final item = familyItems[index];
        return SelectableItem(
          icon: item.icon,
          label: item.label,
          value: item.value,
          isSelected: selectedValues.contains(item.value),
          onTap: onSelect,
        );
      },
    );
  }
}
