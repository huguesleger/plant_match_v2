import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/message/presentation/state/message_state.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ChatPlantRepository chatPlantRepository;
  final UserRepository userRepository;

  StreamSubscription? _sub;

  MessagesCubit({
    required this.chatPlantRepository,
    required this.userRepository,
  }) : super(MessagesInitial());

  void load(String uid) {
    emit(MessagesLoading());

    _sub = chatPlantRepository.chatsForUser(uid).listen(
      (chats) async {
        final List<ChatPlant> result = [];

        for (final chat in chats) {
          // Récupérer le profil de l'autre utilisateur
          final otherUserId = chat.participants.firstWhere((id) => id != uid);
          final profil = await userRepository.getUserUid(otherUserId);

          final displayName = profil.userName.isNotEmpty
              ? profil.userName
              : profil.fullName.split(' ').first;

          final displayAvatar = profil.profilImg?.trim().isNotEmpty == true
              ? profil.profilImg
              : '';

          result.add(
            ChatPlant(
              chatId: chat.chatId,
              plantId: chat.plantId,
              plantName: chat.plantName,
              plantDescription: chat.plantDescription,
              plantImage: chat.plantImage,
              plantExchangeType: chat.plantExchangeType,
              plantOwnerId: chat.plantOwnerId,
              plantOwnerName: displayName,
              plantOwnerAvatar: displayAvatar,
              participants: chat.participants,
              lastMessage: chat.lastMessage,
              lastMessageAt: chat.lastMessageAt,
              unreadCount: chat.unreadCount,
            ),
          );
        }

        emit(MessagesLoaded(chats: result));
      },
      onError: (e) {
        emit(MessagesError(e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
