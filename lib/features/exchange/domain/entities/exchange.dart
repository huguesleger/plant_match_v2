import 'package:cloud_firestore/cloud_firestore.dart';

enum ExchangeStatus {
  pending,
  accepted,
  rejected,
  waitingValidation, // En attente de saisie du code PIN
  completed, // Échange physique terminé
}

class Exchange {
  final String id;
  final String chatId;
  final String requestedBy;
  final String ownerId;

  final String targetPlantId;
  final String offeredPlantId;

  final String targetPlantName;
  final String targetPlantImage;
  final String offeredPlantName;
  final String offeredPlantImage;

  final ExchangeStatus status;
  final DateTime createdAt;
  final bool seenByOwner;
  final bool seenByRequester;
  final DateTime? completedAt;
  final String? completedBy;
  final String? validationCode;

  Exchange({
    this.id = '',
    required this.chatId,
    required this.requestedBy,
    required this.ownerId,
    required this.targetPlantId,
    required this.offeredPlantId,
    required this.targetPlantName,
    required this.targetPlantImage,
    required this.offeredPlantName,
    required this.offeredPlantImage,
    required this.status,
    required this.createdAt,
    required this.seenByOwner,
    required this.seenByRequester,
    this.completedAt,
    this.completedBy,
    this.validationCode,
  });

  factory Exchange.fromJson(String id, Map<String, dynamic> json) {
    return Exchange(
      id: id,
      chatId: json['chatId'] ?? '',
      requestedBy: json['requestedBy'] ?? '',
      ownerId: json['ownerId'] ?? '',
      targetPlantId: json['targetPlantId'] ?? '',
      offeredPlantId: json['offeredPlantId'] ?? '',
      targetPlantName: json['targetPlantName'] ?? '',
      targetPlantImage: json['targetPlantImage'] ?? '',
      offeredPlantName: json['offeredPlantName'] ?? '',
      offeredPlantImage: json['offeredPlantImage'] ?? '',
      status: ExchangeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExchangeStatus.pending,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      seenByOwner: json['seenByOwner'] ?? false,
      seenByRequester: json['seenByRequester'] ?? false,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      completedBy: json['completedBy'],
      validationCode: json['validationCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'requestedBy': requestedBy,
        'ownerId': ownerId,
        'targetPlantId': targetPlantId,
        'offeredPlantId': offeredPlantId,
        'targetPlantName': targetPlantName,
        'targetPlantImage': targetPlantImage,
        'offeredPlantName': offeredPlantName,
        'offeredPlantImage': offeredPlantImage,
        'status': status.name,
        'createdAt': createdAt,
        'seenByOwner': seenByOwner,
        'seenByRequester': seenByRequester,
        'completedAt': completedAt,
        'completedBy': completedBy,
        'validationCode': validationCode,
      };
}
