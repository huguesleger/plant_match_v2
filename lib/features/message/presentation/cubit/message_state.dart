import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';

sealed class MessagesState {
  const MessagesState();
}

class MessagesInitial extends MessagesState {
  const MessagesInitial();
}

class MessagesLoading extends MessagesState {
  final List<ChatPlant> boneMocks =
      List.generate(6, (_) => ChatPlant.boneMock());

  MessagesLoading();
}

class MessagesLoaded extends MessagesState {
  final List<ChatPlant> chats;

  const MessagesLoaded({required this.chats});
}

class MessagesError extends MessagesState {
  final Failure failure;

  const MessagesError(this.failure);
}
