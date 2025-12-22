import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

sealed class ChatPlantState {}

class ChatPlantInitial extends ChatPlantState {}

class ChatPlantLoading extends ChatPlantState {}

class ChatPlantLoaded extends ChatPlantState {
  final List<types.Message> messages;

  ChatPlantLoaded({
    required this.messages,
  });
}

class ChatPlantError extends ChatPlantState {
  final String message;

  ChatPlantError(this.message);
}
