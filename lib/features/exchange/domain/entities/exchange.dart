import 'package:cloud_firestore/cloud_firestore.dart';

enum ExchangeStatus {
  pending,
  accepted,
  rejected,
}

class Exchange {
  final String id;
  final String chatId;
  final String requestedBy;
  final String ownerId;

  final String targetPlantId;
  final String offeredPlantId;

  final String offeredPlantName;
  final String offeredPlantImage;

  final ExchangeStatus status;
  final DateTime createdAt;
  final bool seenByOwner;
  final bool seenByRequester;

  Exchange({
    this.id = '',
    required this.chatId,
    required this.requestedBy,
    required this.ownerId,
    required this.targetPlantId,
    required this.offeredPlantId,
    required this.offeredPlantName,
    required this.offeredPlantImage,
    required this.status,
    required this.createdAt,
    required this.seenByOwner,
    required this.seenByRequester,
  });

  factory Exchange.fromJson(String id, Map<String, dynamic> json) {
    return Exchange(
      id: id,
      chatId: json['chatId'],
      requestedBy: json['requestedBy'],
      ownerId: json['ownerId'],
      targetPlantId: json['targetPlantId'],
      offeredPlantId: json['offeredPlantId'],
      offeredPlantName: json['offeredPlantName'],
      offeredPlantImage: json['offeredPlantImage'],
      status: ExchangeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExchangeStatus.pending,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      seenByOwner: json['seenByOwner'],
      seenByRequester: json['seenByRequester'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'requestedBy': requestedBy,
        'ownerId': ownerId,
        'targetPlantId': targetPlantId,
        'offeredPlantId': offeredPlantId,
        'offeredPlantName': offeredPlantName,
        'offeredPlantImage': offeredPlantImage,
        'status': status.name,
        'createdAt': createdAt,
        'seenByOwner': seenByOwner,
        'seenByRequester': seenByRequester,
      };
}
