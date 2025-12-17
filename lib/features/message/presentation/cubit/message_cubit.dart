import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/features/chat/domain/entities/chat_user.dart';
import 'package:plant_match_v2/features/chat/repository/chat_repository.dart';
import 'package:plant_match_v2/features/message/presentation/state/message_state.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ChatRepository chatRepository;
  final UserRepository userRepository;

  StreamSubscription? _sub;

  MessagesCubit({
    required this.chatRepository,
    required this.userRepository,
  }) : super(MessagesInitial());

  void load(String uid) {
    emit(MessagesLoading());

    _sub = chatRepository.chatsForUser(uid).listen(
      (chats) async {
        final List<ChatUser> result = [];

        for (final chat in chats) {
          final otherUserId = chat.participants.firstWhere((id) => id != uid);
          final profil = await userRepository.getUserUid(otherUserId);
          final displayName = profil.userName.isNotEmpty
              ? profil.userName.toCapitalize()
              : profil.fullName.getFirstWordBeforeSpace().toCapitalize();

          result.add(
            ChatUser(
              chatId: chat.chatId,
              participants: chat.participants,
              otherUserId: otherUserId,
              otherUserName: displayName,
              otherUserAvatar: profil.profilImg,
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
