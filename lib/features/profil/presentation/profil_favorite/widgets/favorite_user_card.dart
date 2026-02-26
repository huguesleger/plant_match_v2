import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FavoriteUserCard extends StatelessWidget {
  const FavoriteUserCard({
    super.key,
    required this.user,
    required this.onRemove,
    required this.onTap,
  });

  final ProfilUser user;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final displayName = user.userName.isNotEmpty
        ? user.userName.toCapitalize()
        : user.fullName.toCapitalize();

    return Material(
      elevation: 4,
      shadowColor: AppColors.black.withValues(alpha: 0.15),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.greyUltraLight),
      ),
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Avatar(
                    profilUser: user,
                    radius: 30,
                    imgSizeAvatar: 46,
                    defaultSizeAvatar: 42,
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: user.isOnline
                            ? AppColors.greenLight
                            : AppColors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: InterTextStyle.inter(
                        AppTypo.textS,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greyDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.localisation.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${user.localisation} (${user.zipCode})',
                        style: InterTextStyle.inter(
                          AppTypo.textXs,
                          color: AppColors.greyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Bouton retirer
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.greyUltraLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.greenMedium,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
