import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPlant {
  final String chatId;
  final String plantId;
  final String plantName;
  final String plantDescription;
  final String plantImage;
  final String plantExchangeType;

  final String plantOwnerId;
  final String plantOwnerName;
  final String? plantOwnerAvatar;

  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCount;
  final String otherUserId;
  final bool hasUnreadExchange;
  final String? acceptedExchangeId;
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
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    required this.otherUserId,
    this.hasUnreadExchange = false,
    this.acceptedExchangeId,
    this.isExchangeCompleted = false,
    this.isOtherUserOnline = false,
  });

  ChatPlant copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
    bool? hasUnreadExchange,
    String? acceptedExchangeId,
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
      'plantExchangeType': plantExchangeType,
      'plantOwnerId': plantOwnerId,
      'plantOwnerName': plantOwnerName,
      'plantOwnerAvatar': plantOwnerAvatar,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
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
      plantExchangeType: json['plantExchangeType'] ?? '',
      plantOwnerId: json['plantOwnerId'] ?? '',
      plantOwnerName: json['plantOwnerName'] ?? 'Propriétaire',
      plantOwnerAvatar: json['plantOwnerAvatar'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null
          ? (json['lastMessageAt'] as Timestamp).toDate()
          : null,
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      otherUserId: json['otherUserId'] ?? '',
      hasUnreadExchange: false,
      acceptedExchangeId: json['acceptedExchangeId'],
      isExchangeCompleted: json['isExchangeCompleted'] ?? false,
      isOtherUserOnline: json['isOtherUserOnline'] ?? false,
    );
  }
}
