import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AvatarCollection extends StatelessWidget {
  const AvatarCollection({
    super.key,
    required this.avatar,
    this.avatarSize = 60,
    this.isSelected = false,
  });

  final AssetGenImage avatar;
  final double avatarSize;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.greenDark.withValues(alpha: 0.1)
        : AppColors.greyUltraLight;
    final borderColor = isSelected ? AppColors.greenDark : Colors.transparent;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: 40,
        child: avatar.image(
          width: avatarSize,
          height: avatarSize,
        ),
      ),
    );
  }
}
