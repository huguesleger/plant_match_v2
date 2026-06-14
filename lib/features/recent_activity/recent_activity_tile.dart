import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.catalog,
    required this.owner,
    required this.currentUserId,
  });

  final Catalog catalog;
  final ProfilUser owner;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final displayName = owner.userName.getOrElse(() => owner.firstName);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPlant(
            catalog: catalog,
            owner: owner,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildUserAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: AppColors.black, fontSize: AppTypo.textS),
                    children: [
                      TextSpan(
                          text: displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: " a ajouté une plante"),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.calendar_clock,
                      color: AppColors.greyMedium,
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTimeAgo(catalog.createdAt),
                      style: const TextStyle(
                          color: AppColors.greyMedium,
                          fontSize: AppTypo.textXs),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _buildPlantThumbnail(),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Avatar(
      profilUser: owner,
      radius: 22,
      imgSizeAvatar: 44,
    );
  }

  Widget _buildPlantThumbnail() {
    final hasImg = catalog.images.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: hasImg
            ? Image.network(catalog.images.first, fit: BoxFit.cover)
            : const Icon(LucideIcons.image,
                color: AppColors.greyMedium, size: 20),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return "${diff.inMinutes} min";
    if (diff.inHours < 24) return "${diff.inHours} h";
    return "${diff.inDays} j";
  }
}
