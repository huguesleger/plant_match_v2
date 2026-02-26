import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

/// Type d'entrée dans l'historique
enum HistoryItemType { exchange, donation }

/// Filtre de statut commun échange + donation
enum HistoryStatusFilter {
  all,
  accepted,
  completed,
  rejected,
}

/// Modèle unifié pour l'historique : représente soit un échange, soit une donation
class HistoryItem {
  final HistoryItemType type;

  // Champs communs
  final String id;
  final String chatId;
  final String requestedBy;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String rawStatus; // 'pending' | 'accepted' | 'rejected' | 'completed'

  // Champs spécifiques échange
  final Exchange? exchange;

  // Champs spécifiques donation
  final Donation? donation;

  const HistoryItem._({
    required this.type,
    required this.id,
    required this.chatId,
    required this.requestedBy,
    required this.ownerId,
    required this.createdAt,
    required this.rawStatus,
    this.completedAt,
    this.exchange,
    this.donation,
  });

  factory HistoryItem.fromExchange(Exchange e) => HistoryItem._(
        type: HistoryItemType.exchange,
        id: e.id,
        chatId: e.chatId,
        requestedBy: e.requestedBy,
        ownerId: e.ownerId,
        createdAt: e.createdAt,
        completedAt: e.completedAt,
        rawStatus: e.status.name,
        exchange: e,
      );

  factory HistoryItem.fromDonation(Donation d) => HistoryItem._(
        type: HistoryItemType.donation,
        id: d.id,
        chatId: d.chatId,
        requestedBy: d.requestedBy,
        ownerId: d.ownerId,
        createdAt: d.createdAt,
        completedAt: d.completedAt,
        rawStatus: d.status.name,
        donation: d,
      );
}
