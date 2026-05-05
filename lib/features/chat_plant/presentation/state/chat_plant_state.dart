import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

sealed class ChatPlantState {}

class ChatPlantInitial extends ChatPlantState {}

class ChatPlantLoading extends ChatPlantState {}

class ChatPlantLoaded extends ChatPlantState {
  final List<types.Message> messages;
  final bool isBlocked;

  ChatPlantLoaded({
    required this.messages,
    this.isBlocked = false,
  });
}

class ChatPlantBlocked extends ChatPlantState {}

class ChatPlantError extends ChatPlantState {
  final String message;

  ChatPlantError(this.message);
}
