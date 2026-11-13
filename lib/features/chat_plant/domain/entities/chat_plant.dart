import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

enum ChatMessageType {
  text,
  plantExchange,
  plantDonation,
}

class ChatPlant {
  final String chatId;
  final String plantId;
  final String plantName;
  final String plantDescription;
  final String plantImage;
  final OfferType plantExchangeType;

  final String plantOwnerId;
  final String plantOwnerName;
  final Option<String> plantOwnerAvatar;

  final List<String> participants;
  final Option<String> lastMessage;
  final Option<DateTime> lastMessageAt;
  final Map<String, int> unreadCount;
  final String otherUserId;
  final bool hasUnreadExchange;
  final Option<String> acceptedExchangeId;
  final bool isExchangeCompleted;
  final bool hasUnreadDonation;
  final Option<String> acceptedDonationId;
  final bool isDonationCompleted;
  final bool isOtherUserOnline;

  ChatPlant({
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantDescription,
    required this.plantImage,
    required this.plantExchangeType,
    required this.plantOwnerId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.otherUserId,
    required this.hasUnreadExchange,
    required this.acceptedExchangeId,
    required this.isExchangeCompleted,
    required this.hasUnreadDonation,
    required this.acceptedDonationId,
    required this.isDonationCompleted,
    required this.isOtherUserOnline,
  });

  ChatPlant copyWith({
    Option<Option<String>> lastMessage = const None(),
    Option<Option<DateTime>> lastMessageAt = const None(),
    Option<Map<String, int>> unreadCount = const None(),
    Option<bool> hasUnreadExchange = const None(),
    Option<Option<String>> acceptedExchangeId = const None(),
    Option<bool> isExchangeCompleted = const None(),
    Option<bool> hasUnreadDonation = const None(),
    Option<Option<String>> acceptedDonationId = const None(),
    Option<bool> isDonationCompleted = const None(),
    Option<bool> isOtherUserOnline = const None(),
  }) {
    return ChatPlant(
      chatId: chatId,
      plantId: plantId,
      plantName: plantName,
      plantDescription: plantDescription,
      plantImage: plantImage,
      plantExchangeType: plantExchangeType,
      plantOwnerId: plantOwnerId,
      plantOwnerName: plantOwnerName,
      plantOwnerAvatar: plantOwnerAvatar,
      participants: participants,
      lastMessage: lastMessage.getOrElse(() => this.lastMessage),
      lastMessageAt: lastMessageAt.getOrElse(() => this.lastMessageAt),
      unreadCount: unreadCount.getOrElse(() => this.unreadCount),
      otherUserId: otherUserId,
      hasUnreadExchange:
          hasUnreadExchange.getOrElse(() => this.hasUnreadExchange),
      acceptedExchangeId:
          acceptedExchangeId.getOrElse(() => this.acceptedExchangeId),
      isExchangeCompleted:
          isExchangeCompleted.getOrElse(() => this.isExchangeCompleted),
      hasUnreadDonation:
          hasUnreadDonation.getOrElse(() => this.hasUnreadDonation),
      acceptedDonationId:
          acceptedDonationId.getOrElse(() => this.acceptedDonationId),
      isDonationCompleted:
          isDonationCompleted.getOrElse(() => this.isDonationCompleted),
      isOtherUserOnline:
          isOtherUserOnline.getOrElse(() => this.isOtherUserOnline),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'plantDescription': plantDescription,
      'plantImage': plantImage,
      'plantExchangeType': plantExchangeType.name,
      'plantOwnerId': plantOwnerId,
      'plantOwnerName': plantOwnerName,
      'plantOwnerAvatar': plantOwnerAvatar.toNullable(),
      'participants': participants,
      'lastMessage': lastMessage.toNullable(),
      'lastMessageAt': lastMessageAt.toNullable(),
      'unreadCount': unreadCount,
      'otherUserId': otherUserId,
    };
  }

  factory ChatPlant.boneMock() => ChatPlant(
        chatId: '',
        plantId: '',
        plantName: 'Monstera deliciosa',
        plantDescription: '',
        plantImage: '',
        plantExchangeType: OfferType.exchange,
        plantOwnerId: '',
        plantOwnerName: 'Camille',
        plantOwnerAvatar: const None(),
        participants: const [],
        lastMessage: const Some('Bonjour, ta plante est toujours disponible ?'),
        lastMessageAt: Some(DateTime.now()),
        unreadCount: const {},
        otherUserId: '',
        hasUnreadExchange: false,
        acceptedExchangeId: const None(),
        isExchangeCompleted: false,
        hasUnreadDonation: false,
        acceptedDonationId: const None(),
        isDonationCompleted: false,
        isOtherUserOnline: true,
      );

  factory ChatPlant.fromJson(String id, Map<String, dynamic> json) {
    return ChatPlant(
      chatId: id,
      plantId: json.string('plantId'),
      plantName: json.string('plantName'),
      plantDescription: json.string('plantDescription'),
      plantImage: json.string('plantImage'),
      plantExchangeType:
          Option<dynamic>.fromNullable(json['plantExchangeType']).match(
        () => OfferType.exchange,
        (type) => OfferType.values.byName(type),
      ),
      plantOwnerId: json.string('plantOwnerId'),
      plantOwnerName: json.string('plantOwnerName', 'Propriétaire'),
      plantOwnerAvatar: json.read<String>('plantOwnerAvatar'),
      participants: json.listOf<String>('participants'),
      lastMessage: json.read<String>('lastMessage'),
      lastMessageAt: json.date('lastMessageAt'),
      unreadCount: json
          .object('unreadCount')
          .map((key, value) => MapEntry(key, value is num ? value.toInt() : 0)),
      otherUserId: json.string('otherUserId'),
      hasUnreadExchange: false,
      acceptedExchangeId: json.read<String>('acceptedExchangeId'),
      isExchangeCompleted: json.boolean('isExchangeCompleted'),
      hasUnreadDonation: false,
      acceptedDonationId: json.read<String>('acceptedDonationId'),
      isDonationCompleted: json.boolean('isDonationCompleted'),
      isOtherUserOnline: json.boolean('isOtherUserOnline'),
    );
  }
}
