import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class PlantMessageCard extends StatelessWidget {
  const PlantMessageCard({
    super.key,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.onTap,
    required this.isSender,
  });

  final String plantId;
  final String plantName;
  final String plantImage;
  final VoidCallback onTap;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? AppColors.greenLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.greenMedium.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                plantImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: AppColors.greyLight,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppColors.greyDark,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        size: 16,
                        color: AppColors.greenDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isSender ? 'Plante proposée' : 'Proposition d\'échange',
                        style: const TextStyle(
                          fontSize: AppTypo.textXs,
                          color: AppColors.greenDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plantName,
                    style: const TextStyle(
                      fontSize: AppTypo.text,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Voir le détail',
                        style: TextStyle(
                          fontSize: AppTypo.textXs,
                          color: AppColors.greenDark.withValues(alpha: 0.8),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: AppColors.greenDark.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
