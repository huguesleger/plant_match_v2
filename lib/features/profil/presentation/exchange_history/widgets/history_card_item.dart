import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/widgets/history_card_data.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/widgets/history_card_image.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/widgets/history_status_badge.dart';

class HistoryCardItem extends StatelessWidget {
  const HistoryCardItem({
    super.key,
    required this.item,
    required this.currentUserId,
  });

  final HistoryItem item;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final data = HistoryCardData.fromItem(item, currentUserId);

    return Material(
      elevation: 6,
      shadowColor: AppColors.black.withValues(alpha: 0.2),
      clipBehavior: Clip.antiAlias,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.greyUltraLight,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                HistoryCardImage(
                  imageUrl: data.imageUrl,
                  height: 100,
                  width: 80,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HistoryStatusBadge(rawStatus: data.rawStatus),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${data.roleText} | ',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.greyDark),
                            ),
                            TextSpan(
                              text: data.typeLabel,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: data.typeColor),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.plantName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('dd/MM/yyyy').format(data.date),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.greyMedium),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevron_right,
                    color: AppColors.greyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
