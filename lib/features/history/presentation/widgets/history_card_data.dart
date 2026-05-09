import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_item.dart';

class HistoryCardData {
  final DateTime date;
  final String rawStatus;
  final String typeLabel;
  final Color typeColor;
  final String plantName;
  final String? imageUrl;
  final String roleText;

  const HistoryCardData({
    required this.date,
    required this.rawStatus,
    required this.typeLabel,
    required this.typeColor,
    required this.plantName,
    required this.imageUrl,
    required this.roleText,
  });

  factory HistoryCardData.fromItem(HistoryItem item, String currentUserId) {
    final isRequester = item.requestedBy == currentUserId;
    final roleText = isRequester ? t.history.card.request_sent : t.history.card.request_received;

    final (typeLabel, typeColor, plantName, imageUrl) = switch (item) {
      HistoryExchangeItem e => () {
          final name = isRequester
              ? e.exchange.targetPlantName
              : e.exchange.offeredPlantName;
          final image = isRequester
              ? e.exchange.targetPlantImage
              : e.exchange.offeredPlantImage;
          return (
            t.history.card.exchange,
            AppColors.greenDark,
            name.isNotEmpty ? name.toCapitalize() : t.history.card.unknown_plant,
            image,
          );
        }(),
      HistoryDonationItem d => (
          t.history.card.donation,
          AppColors.blueGreen,
          d.donation.plantName.isNotEmpty
              ? d.donation.plantName.toCapitalize()
              : t.history.card.unknown_plant,
          d.donation.plantImage,
        ),
    };

    return HistoryCardData(
      date: item.createdAt,
      rawStatus: item.rawStatus,
      typeLabel: typeLabel,
      typeColor: typeColor,
      plantName: plantName,
      imageUrl: imageUrl,
      roleText: roleText,
    );
  }
}
