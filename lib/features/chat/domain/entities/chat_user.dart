class ChatUser {
  final String chatId;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCount;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final DateTime? lastMessageReadAt;

  ChatUser({
    required this.chatId,
    required this.participants,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    this.lastMessageReadAt,
  });

  ChatUser copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
    String? otherUserName,
    String? otherUserAvatar,
    DateTime? lastMessageReadAt,
  }) {
    return ChatUser(
      chatId: chatId,
      participants: participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      otherUserId: otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      lastMessageReadAt: lastMessageReadAt ?? this.lastMessageReadAt,
    );
  }
}
