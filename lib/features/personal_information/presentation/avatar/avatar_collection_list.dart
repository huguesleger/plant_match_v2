import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AvatarCollectionList extends StatelessWidget {
  final List<AssetGenImage> avatars;
  final int selectedIndex;
  final ValueChanged<AssetGenImage> onAvatarSelected;

  const AvatarCollectionList({
    super.key,
    required this.avatars,
    required this.selectedIndex,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        final avatar = avatars[index];

        return GestureDetector(
          onTap: () => onAvatarSelected(avatar),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.greenDark.withValues(alpha: 0.1)
                      : AppColors.greyUltraLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? AppColors.greenDark : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: Transform.scale(
                    scale: 0.8,
                    child: avatar.image(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
