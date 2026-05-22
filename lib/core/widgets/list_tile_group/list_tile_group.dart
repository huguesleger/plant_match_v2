import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppListTileGroup extends StatelessWidget {
  const AppListTileGroup({
    super.key,
    required this.children,
    this.borderRadius = 15,
    this.margin,
  });

  final List<Widget> children;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          final isFirst = index == 0;
          final isLast = index == children.length - 1;

          final radius = BorderRadius.only(
            topLeft: isFirst ? Radius.circular(borderRadius) : Radius.zero,
            topRight: isFirst ? Radius.circular(borderRadius) : Radius.zero,
            bottomLeft: isLast ? Radius.circular(borderRadius) : Radius.zero,
            bottomRight: isLast ? Radius.circular(borderRadius) : Radius.zero,
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: radius),
                child: widget,
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.greyLight,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
