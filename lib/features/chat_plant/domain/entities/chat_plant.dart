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
  });

  ChatPlant copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
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
    );
  }
}
