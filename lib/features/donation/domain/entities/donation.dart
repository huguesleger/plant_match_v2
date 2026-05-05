import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

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
  final Option<DateTime> completedAt;
  final Option<String> completedBy;
  final Option<String> validationCode;

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
    required this.completedAt,
    required this.completedBy,
    required this.validationCode,
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
      completedAt: Option.fromNullable(json['completedAt']).map(
        (t) => (t as Timestamp).toDate(),
      ),
      completedBy: Option.fromNullable(json['completedBy'] as String?),
      validationCode: Option.fromNullable(json['validationCode'] as String?),
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
        'completedAt': completedAt.toNullable(),
        'completedBy': completedBy.toNullable(),
        'validationCode': validationCode.toNullable(),
      };
}
