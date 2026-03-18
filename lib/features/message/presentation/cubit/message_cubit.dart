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

  void _emitCombined(String currentUserId) {
    final List<Future<ChatPlant?>> futures = _lastChats.map((chat) {
      /// 1️⃣ Trouver l'interlocuteur
      final otherUserId = chat.participants.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) return Future.value(null);

      return userRepository.getUserUid(otherUserId).run().then((userResult) {
        final userOption = userResult.toOption();
        if (userOption.isNone()) return null;

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

        return ChatPlant(
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
        );
      });
    }).toList();

    Future.wait(futures).then((results) {
      if (isClosed) return;
      
      final List<ChatPlant> chatPlants = results.whereType<ChatPlant>().toList();
      
      // Filtrer les conversations clôturées
      final filteredResult =
          chatPlants.where((chat) => !chat.isExchangeCompleted).toList();

      emit(MessagesLoaded(chats: filteredResult));
    }).catchError((e) {
      if (!isClosed) {
        emit(MessagesError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _chatsSub?.cancel();
    _exchangesSub?.cancel();
    return super.close();
  }
}
