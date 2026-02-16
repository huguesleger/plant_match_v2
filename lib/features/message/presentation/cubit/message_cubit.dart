import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/message/presentation/state/message_state.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ChatPlantRepository chatPlantRepository;
  final UserRepository userRepository;
  final ExchangeRepository exchangeRepository;

  StreamSubscription<List<ChatPlant>>? _chatsSub;
  StreamSubscription<List<Exchange>>? _exchangesSub;

  List<ChatPlant> _lastChats = [];
  List<Exchange> _lastExchanges = [];

  MessagesCubit({
    required this.chatPlantRepository,
    required this.userRepository,
    required this.exchangeRepository,
  }) : super(MessagesInitial());

  void load(String currentUserId) {
    emit(MessagesLoading());

    _chatsSub = chatPlantRepository.chatsForUser(currentUserId).listen(
      (chats) {
        _lastChats = chats;
        _emitCombined(currentUserId);
      },
      onError: (e) {
        emit(MessagesError(e.toString()));
      },
    );

    _exchangesSub =
        exchangeRepository.watchUnreadExchanges(currentUserId).listen(
      (exchanges) {
        _lastExchanges = exchanges;
        _emitCombined(currentUserId);
      },
      onError: (e) {
        emit(MessagesError(e.toString()));
      },
    );
  }

  Future<void> _emitCombined(String currentUserId) async {
    try {
      final List<ChatPlant> result = [];

      for (final chat in _lastChats) {
        /// 1️⃣ Trouver l'interlocuteur
        final otherUserId = chat.participants.firstWhere(
          (id) => id != currentUserId,
          orElse: () => '',
        );

        if (otherUserId.isEmpty) continue;

        final userResult = await userRepository.getUserUid(otherUserId).run();

        // Si l'utilisateur n'est pas trouvé, on skip ce chat
        final userOption = userResult.toOption();
        if (userOption.isNone()) continue;

        final user = userOption.toNullable()!;

        final displayName = user.userName.isNotEmpty
            ? user.userName
            : user.fullName.split(' ').first;

        final displayAvatar =
            user.profilImg.trim().isNotEmpty == true ? user.profilImg : '';

        final bool hasUnreadExchange =
            _lastExchanges.any((e) => e.chatId == chat.chatId);

        // Trouver l'échange accepté pour ce chat
        final acceptedExchange = _lastExchanges.firstWhere(
          (e) => e.chatId == chat.chatId && e.status == ExchangeStatus.accepted,
          orElse: () => Exchange(
            chatId: '',
            requestedBy: '',
            ownerId: '',
            targetPlantId: '',
            targetPlantName: '',
            targetPlantImage: '',
            offeredPlantId: '',
            offeredPlantName: '',
            offeredPlantImage: '',
            status: ExchangeStatus.pending,
            createdAt: DateTime.now(),
            seenByOwner: false,
            seenByRequester: false,
          ),
        );

        final acceptedExchangeId =
            acceptedExchange.chatId.isNotEmpty ? acceptedExchange.id : null;

        result.add(
          ChatPlant(
            chatId: chat.chatId,
            plantId: chat.plantId,
            plantName: chat.plantName,
            plantDescription: chat.plantDescription,
            plantImage: chat.plantImage,
            plantExchangeType: chat.plantExchangeType,
            plantOwnerId: chat.plantOwnerId,
            otherUserId: otherUserId,
            plantOwnerName: displayName,
            plantOwnerAvatar: displayAvatar,
            participants: chat.participants,
            lastMessage: chat.lastMessage,
            lastMessageAt: chat.lastMessageAt,
            unreadCount: chat.unreadCount,
            hasUnreadExchange: hasUnreadExchange,
            acceptedExchangeId: acceptedExchangeId,
            isExchangeCompleted: chat.isExchangeCompleted,
          ),
        );
      }

      // Filtrer les conversations clôturées
      final filteredResult =
          result.where((chat) => !chat.isExchangeCompleted).toList();

      emit(MessagesLoaded(chats: filteredResult));
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _chatsSub?.cancel();
    _exchangesSub?.cancel();
    return super.close();
  }
}
