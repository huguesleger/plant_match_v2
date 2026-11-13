import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:fpdart/fpdart.dart';

enum ExchangeStatus {
  pending,
  accepted,
  rejected,
  waitingValidation,
  completed,
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
  final Option<DateTime> completedAt;
  final Option<String> completedBy;
  final Option<String> validationCode;

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
    required this.completedAt,
    required this.completedBy,
    required this.validationCode,
  });

  factory Exchange.boneMock() => Exchange(
        chatId: '',
        requestedBy: '',
        ownerId: '',
        targetPlantId: '',
        offeredPlantId: '',
        targetPlantName: 'Monstera deliciosa',
        targetPlantImage: '',
        offeredPlantName: 'Monstera deliciosa',
        offeredPlantImage: '',
        status: ExchangeStatus.completed,
        createdAt: DateTime.now(),
        seenByOwner: true,
        seenByRequester: true,
        completedAt: const None(),
        completedBy: const None(),
        validationCode: const None(),
      );

  factory Exchange.fromJson(String id, Map<String, dynamic> json) {
    return Exchange(
      id: id,
      chatId: json.string('chatId'),
      requestedBy: json.string('requestedBy'),
      ownerId: json.string('ownerId'),
      targetPlantId: json.string('targetPlantId'),
      offeredPlantId: json.string('offeredPlantId'),
      targetPlantName: json.string('targetPlantName'),
      targetPlantImage: json.string('targetPlantImage'),
      offeredPlantName: json.string('offeredPlantName'),
      offeredPlantImage: json.string('offeredPlantImage'),
      status: ExchangeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExchangeStatus.pending,
      ),
      createdAt: json.date('createdAt').getOrElse(DateTime.now),
      seenByOwner: json.boolean('seenByOwner'),
      seenByRequester: json.boolean('seenByRequester'),
      completedAt: json.date('completedAt'),
      completedBy: json.read<String>('completedBy'),
      validationCode: json.read<String>('validationCode'),
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
        'completedAt': completedAt.toNullable(),
        'completedBy': completedBy.toNullable(),
        'validationCode': validationCode.toNullable(),
      };
}
