import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

enum HistoryStatusFilter {
  all('Tous', LucideIcons.list),
  accepted('Acceptés', LucideIcons.circle_check),
  completed('Terminés', LucideIcons.circle_check_big),
  rejected('Refusés', LucideIcons.circle_x);

  final String label;
  final IconData icon;

  const HistoryStatusFilter(this.label, this.icon);
}

sealed class HistoryItem {
  final String id;
  final String chatId;
  final String requestedBy;
  final String ownerId;
  final DateTime createdAt;
  final Option<DateTime> completedAt;
  final String rawStatus;

  const HistoryItem({
    required this.id,
    required this.chatId,
    required this.requestedBy,
    required this.ownerId,
    required this.createdAt,
    required this.completedAt,
    required this.rawStatus,
  });

  factory HistoryItem.fromExchange(Exchange e) => HistoryExchangeItem(e);
  factory HistoryItem.fromDonation(Donation d) => HistoryDonationItem(d);
}

class HistoryExchangeItem extends HistoryItem {
  final Exchange exchange;

  HistoryExchangeItem(this.exchange)
      : super(
          id: exchange.id,
          chatId: exchange.chatId,
          requestedBy: exchange.requestedBy,
          ownerId: exchange.ownerId,
          createdAt: exchange.createdAt,
          completedAt: exchange.completedAt,
          rawStatus: exchange.status.name,
        );
}

class HistoryDonationItem extends HistoryItem {
  final Donation donation;

  HistoryDonationItem(this.donation)
      : super(
          id: donation.id,
          chatId: donation.chatId,
          requestedBy: donation.requestedBy,
          ownerId: donation.ownerId,
          createdAt: donation.createdAt,
          completedAt: donation.completedAt,
          rawStatus: donation.status.name,
        );
}
