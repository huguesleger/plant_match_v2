import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

enum BlockStatus { none, blockedByMe, blockedByOther }

sealed class ChatPlantState {}

class ChatPlantInitial extends ChatPlantState {}

class ChatPlantLoading extends ChatPlantState {}

class ChatPlantLoaded extends ChatPlantState {
  final List<types.Message> messages;
  final BlockStatus blockStatus;

  ChatPlantLoaded({
    required this.messages,
    this.blockStatus = BlockStatus.none,
  });

  bool get isBlocked => blockStatus != BlockStatus.none;
}

class ChatPlantBlocked extends ChatPlantState {}

class ChatPlantError extends ChatPlantState {
  final Failure failure;

  ChatPlantError(this.failure);
}
