import 'package:plant_match_v2/features/chat/domain/entities/chat_user.dart';

sealed class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<ChatUser> chats;

  MessagesLoaded({required this.chats});
}

class MessagesError extends MessagesState {
  final String message;

  MessagesError(this.message);
}
