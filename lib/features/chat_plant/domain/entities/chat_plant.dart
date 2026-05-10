import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

enum ChatMessageType {
  text,
  plantExchange,
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
    required this.isOtherUserOnline,
  });

  ChatPlant copyWith({
    Option<String>? lastMessage,
    Option<DateTime>? lastMessageAt,
    Map<String, int>? unreadCount,
    bool? hasUnreadExchange,
    Option<String>? acceptedExchangeId,
    bool? isExchangeCompleted,
    bool? isOtherUserOnline,
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
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      otherUserId: otherUserId,
      hasUnreadExchange: hasUnreadExchange ?? this.hasUnreadExchange,
      acceptedExchangeId: acceptedExchangeId ?? this.acceptedExchangeId,
      isExchangeCompleted: isExchangeCompleted ?? this.isExchangeCompleted,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
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

  factory ChatPlant.fromJson(String id, Map<String, dynamic> json) {
    return ChatPlant(
      chatId: id,
      plantId: json['plantId'] ?? '',
      plantName: json['plantName'] ?? '',
      plantDescription: json['plantDescription'] ?? '',
      plantImage: json['plantImage'] ?? '',
      plantExchangeType: json['plantExchangeType'] != null
          ? OfferType.values.byName(json['plantExchangeType'])
          : OfferType.exchange,
      plantOwnerId: json['plantOwnerId'] ?? '',
      plantOwnerName: json['plantOwnerName'] ?? 'Propriétaire',
      plantOwnerAvatar: Option.fromNullable(json['plantOwnerAvatar'] as String?),
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: Option.fromNullable(json['lastMessage'] as String?),
      lastMessageAt: Option.fromNullable(json['lastMessageAt']).map(
        (t) => (t as Timestamp).toDate(),
      ),
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      otherUserId: json['otherUserId'] ?? '',
      hasUnreadExchange: false,
      acceptedExchangeId: Option.fromNullable(json['acceptedExchangeId'] as String?),
      isExchangeCompleted: json['isExchangeCompleted'] ?? false,
      isOtherUserOnline: json['isOtherUserOnline'] ?? false,
    );
  }
}
