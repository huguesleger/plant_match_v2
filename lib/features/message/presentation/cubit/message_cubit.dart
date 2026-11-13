import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/widgets/skeleton/skeleton_effect.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/message_state.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ChatPlantRepository chatPlantRepository;
  final UserRepository userRepository;
  final ExchangeRepository exchangeRepository;
  final DonationRepository donationRepository;

  Option<StreamSubscription<List<ChatPlant>>> _chatsSub = const None();
  Option<StreamSubscription<List<Exchange>>> _exchangesSub = const None();
  Option<StreamSubscription<List<Donation>>> _donationsSub = const None();

  List<ChatPlant> _lastChats = [];
  List<Exchange> _lastExchanges = [];
  List<Donation> _lastDonations = [];
  int _generation = 0;
  Future<void> _minimalDelay = Future.value();

  MessagesCubit({
    required this.chatPlantRepository,
    required this.userRepository,
    required this.exchangeRepository,
    required this.donationRepository,
  }) : super(const MessagesInitial());

  void load(String currentUserId) {
    _cancelSubscriptions();
    _generation++;
    _minimalDelay = Future.delayed(SkeletonEffect.shimmerMinimumDelay);
    emit(MessagesLoading());

    _chatsSub = Some(chatPlantRepository.chatsForUser(currentUserId).listen(
      (chats) {
        _lastChats = chats;
        _emitCombined(currentUserId);
      },
      onError: _emitError,
    ));

    _exchangesSub =
        Some(exchangeRepository.watchUnreadExchanges(currentUserId).listen(
      (exchanges) {
        _lastExchanges = exchanges;
        _emitCombined(currentUserId);
      },
      onError: _emitError,
    ));

    _donationsSub =
        Some(donationRepository.watchUnreadDonations(currentUserId).listen(
      (donations) {
        _lastDonations = donations;
        _emitCombined(currentUserId);
      },
      onError: _emitError,
    ));
  }

  void _emitError(Object error) {
    _generation++;
    if (!isClosed) {
      emit(MessagesError(mapError(error)));
    }
  }

  void _cancelSubscriptions() {
    _chatsSub.map((sub) => sub.cancel());
    _exchangesSub.map((sub) => sub.cancel());
    _donationsSub.map((sub) => sub.cancel());
  }

  void _emitCombined(String currentUserId) {
    final generation = ++_generation;

    if (_lastChats.isEmpty) {
      _minimalDelay.then((_) {
        if (!isClosed && generation == _generation) {
          emit(const MessagesLoaded(chats: []));
        }
      });
      return;
    }

    final List<Task<Option<ChatPlant>>> tasks = _lastChats.map((chat) {
      final otherUserId = chat.participants.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) return Task.of(none<ChatPlant>());

      return userRepository.getUserUid(otherUserId).map((user) {
        final String displayName = user.userName.match(
          () => user.fullName.split(' ').first,
          (name) => name,
        );

        final displayAvatar =
            Option.of(user.profilImg).filter((img) => img.trim().isNotEmpty);

        final bool hasUnreadExchange =
            _lastExchanges.any((e) => e.chatId == chat.chatId);

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
            completedAt: const None(),
            completedBy: const None(),
            validationCode: const None(),
          ),
        );

        final acceptedExchangeId = Option.of(acceptedExchange.id)
            .filter((_) => acceptedExchange.chatId.isNotEmpty);

        final bool hasUnreadDonation =
            _lastDonations.any((d) => d.chatId == chat.chatId);

        final acceptedDonation = _lastDonations.firstWhere(
          (d) => d.chatId == chat.chatId && d.status == DonationStatus.accepted,
          orElse: () => Donation(
            chatId: '',
            requestedBy: '',
            ownerId: '',
            plantId: '',
            plantName: '',
            plantImage: '',
            status: DonationStatus.pending,
            createdAt: DateTime.now(),
            seenByOwner: false,
            seenByRequester: false,
            completedAt: const None(),
            completedBy: const None(),
            validationCode: const None(),
          ),
        );

        final acceptedDonationId = Option.of(acceptedDonation.id)
            .filter((_) => acceptedDonation.chatId.isNotEmpty);

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
          hasUnreadDonation: hasUnreadDonation,
          acceptedDonationId: acceptedDonationId,
          isDonationCompleted: chat.isDonationCompleted,
          isOtherUserOnline: user.isOnline,
        );
      }).match((_) => none<ChatPlant>(), (c) => some(c));
    }).toList();

    Task.sequenceList(tasks)
        .map(
      (results) => MessagesLoaded(
        chats: results
            .expand((option) => option.match(() => <ChatPlant>[], (c) => [c]))
            .where((chat) =>
                !chat.isExchangeCompleted && !chat.isDonationCompleted)
            .toList(),
      ),
    )
        .flatMap((s) => Task(() => _minimalDelay.then((_) => s)))
        .map((s) {
      if (!isClosed && generation == _generation) {
        emit(s);
      }
    }).run();
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
