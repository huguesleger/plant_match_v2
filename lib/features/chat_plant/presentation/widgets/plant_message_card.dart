import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_theme.dart';

class PlantMessageCard extends StatelessWidget {
  const PlantMessageCard({
    super.key,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.onTap,
    required this.isSender,
    required this.time,
    this.status,
  });

  final String plantId;
  final String plantName;
  final String plantImage;
  final VoidCallback onTap;
  final bool isSender;
  final String time;
  final types.Status? status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender
              ? ChatThemes.light.primaryColor
              : ChatThemes.light.secondaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.greenMedium.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
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
                              LucideIcons.arrow_right_left,
                              size: 16,
                              color: AppColors.greenDark,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isSender
                                  ? 'Plante proposée'
                                  : 'Proposition d\'échange',
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
                            const Text(
                              'Voir le détail',
                              style: TextStyle(
                                fontSize: AppTypo.textXs,
                                color: AppColors.greenDark,
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
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.greyDark.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSender) ...[
                      const SizedBox(width: 4),
                      _StatusIcon(status: status),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({this.status});
  final types.Status? status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      types.Status.delivered =>
        const Icon(LucideIcons.check_check, size: 12, color: Colors.grey),
      types.Status.seen => const Icon(LucideIcons.check_check,
          size: 12, color: AppColors.blueGreen),
      types.Status.sent =>
        const Icon(LucideIcons.check, size: 12, color: Colors.grey),
      types.Status.sending =>
        const Icon(LucideIcons.clock, size: 10, color: Colors.grey),
      types.Status.error =>
        const Icon(LucideIcons.circle_alert, size: 12, color: Colors.red),
      _ => const SizedBox.shrink(),
    };
  }
}
