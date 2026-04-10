import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';

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
    final roleText = isRequester ? 'Demande envoyée' : 'Demande reçue';

    final (typeLabel, typeColor, plantName, imageUrl) = switch (item) {
      HistoryExchangeItem e => () {
          final name = isRequester
              ? e.exchange.targetPlantName
              : e.exchange.offeredPlantName;
          final image = isRequester
              ? e.exchange.targetPlantImage
              : e.exchange.offeredPlantImage;
          return (
            'Échange',
            AppColors.greenDark,
            name.isNotEmpty ? name.toCapitalize() : 'Plante inconnue',
            image,
          );
        }(),
      HistoryDonationItem d => (
          'Donation',
          AppColors.blueGreen,
          d.donation.plantName.isNotEmpty
              ? d.donation.plantName.toCapitalize()
              : 'Plante inconnue',
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
