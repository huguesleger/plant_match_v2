import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.firstName,
    required this.fullName,
    required this.profilImg,
  });

  final String firstName;
  final String fullName;
  final String profilImg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${firstName.toCapitalize()}",
                style: const TextStyle(
                    fontSize: AppTypo.textXxl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black),
              ),
              const SizedBox(height: 6),
              const Text(
                "Prêt à échanger ou donner\nde nouvelles plantes ?",
                style: TextStyle(
                    fontSize: AppTypo.text,
                    color: AppColors.greyMedium,
                    height: 1.3),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildNotificationButton(),
            const SizedBox(width: 12),
            _buildUserAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.greyUltraLight,
            shape: BoxShape.circle,
            border:
                Border.all(color: AppColors.greyLight.withValues(alpha: 0.5)),
          ),
          child: const Icon(LucideIcons.bell, color: AppColors.black, size: 24),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: AppColors.greenMedium, shape: BoxShape.circle),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: const Text(
              "3",
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppTypo.textXxs,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Avatar(
        imageUrl: profilImg,
        name: fullName,
        radius: 22,
        imgSizeAvatar: 44,
      ),
    );
  }
}
