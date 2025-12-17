import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<types.Message> messages;

  ChatLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
