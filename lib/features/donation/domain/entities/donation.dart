import 'package:cloud_firestore/cloud_firestore.dart';

enum DonationStatus {
  pending,
  accepted,
  rejected,
  waitingValidation,
  completed,
}

class Donation {
  final String id;
  final String chatId;
  final String requestedBy;
  final String ownerId;

  final String plantId;
  final String plantName;
  final String plantImage;

  final DonationStatus status;
  final DateTime createdAt;
  final bool seenByOwner;
  final bool seenByRequester;
  final DateTime? completedAt;
  final String? completedBy;
  final String? validationCode;

  Donation({
    this.id = '',
    required this.chatId,
    required this.requestedBy,
    required this.ownerId,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.status,
    required this.createdAt,
    required this.seenByOwner,
    required this.seenByRequester,
    this.completedAt,
    this.completedBy,
    this.validationCode,
  });

  factory Donation.fromJson(String id, Map<String, dynamic> json) {
    return Donation(
      id: id,
      chatId: json['chatId'] ?? '',
      requestedBy: json['requestedBy'] ?? '',
      ownerId: json['ownerId'] ?? '',
      plantId: json['plantId'] ?? '',
      plantName: json['plantName'] ?? '',
      plantImage: json['plantImage'] ?? '',
      status: DonationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DonationStatus.pending,
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
        'plantId': plantId,
        'plantName': plantName,
        'plantImage': plantImage,
        'status': status.name,
        'createdAt': createdAt,
        'seenByOwner': seenByOwner,
        'seenByRequester': seenByRequester,
        'completedAt': completedAt,
        'completedBy': completedBy,
        'validationCode': validationCode,
      };
}
