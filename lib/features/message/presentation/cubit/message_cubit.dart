import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
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

  StreamSubscription<List<ChatPlant>>? _chatsSub;
  StreamSubscription<List<Exchange>>? _exchangesSub;
  StreamSubscription<List<Donation>>? _donationsSub;

  List<ChatPlant> _lastChats = [];
  List<Exchange> _lastExchanges = [];
  List<Donation> _lastDonations = [];

  MessagesCubit({
    required this.chatPlantRepository,
    required this.userRepository,
    required this.exchangeRepository,
    required this.donationRepository,
  }) : super(const MessagesInitial());

  void load(String currentUserId) {
    emit(const MessagesLoading());

    _chatsSub = chatPlantRepository.chatsForUser(currentUserId).listen(
      (chats) {
        _lastChats = chats;
        _emitCombined(currentUserId);
      },
      onError: (e) {
        if (!isClosed) {
          emit(MessagesError(e.toString()));
        }
      },
    );

    _exchangesSub =
        exchangeRepository.watchUnreadExchanges(currentUserId).listen(
      (exchanges) {
        _lastExchanges = exchanges;
        _emitCombined(currentUserId);
      },
      onError: (e) {
        if (!isClosed) {
          emit(MessagesError(e.toString()));
        }
      },
    );

    _donationsSub =
        donationRepository.watchUnreadDonations(currentUserId).listen(
      (donations) {
        _lastDonations = donations;
        _emitCombined(currentUserId);
      },
      onError: (e) {
        if (!isClosed) {
          emit(MessagesError(e.toString()));
        }
      },
    );
  }

  void _emitCombined(String currentUserId) {
    if (_lastChats.isEmpty) {
      if (!isClosed) {
        emit(const MessagesLoaded(chats: []));
      }
      return;
    }

    final List<TaskEither<Failure, ChatPlant?>> tasks = _lastChats.map((chat) {
      final otherUserId = chat.participants.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) return TaskEither<Failure, ChatPlant?>.of(null);

      return userRepository.getUserUid(otherUserId).map((user) {
        final String displayName = user.userName.match(
          () => user.fullName.split(' ').first,
          (name) => name,
        );

        final displayAvatar =
            user.profilImg.trim().isNotEmpty == true ? user.profilImg : '';

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

        final acceptedExchangeId =
            acceptedExchange.chatId.isNotEmpty ? acceptedExchange.id : null;

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

        final acceptedDonationId =
            acceptedDonation.chatId.isNotEmpty ? acceptedDonation.id : null;

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
          plantOwnerAvatar: Option.fromNullable(displayAvatar.isEmpty ? null : displayAvatar),
          participants: chat.participants,
          lastMessage: chat.lastMessage,
          lastMessageAt: chat.lastMessageAt,
          unreadCount: chat.unreadCount,
          hasUnreadExchange: hasUnreadExchange,
          acceptedExchangeId: Option.fromNullable(acceptedExchangeId),
          isExchangeCompleted: chat.isExchangeCompleted,
          hasUnreadDonation: hasUnreadDonation,
          acceptedDonationId: Option.fromNullable(acceptedDonationId),
          isDonationCompleted: chat.isDonationCompleted,
          isOtherUserOnline: user.isOnline,
        );
      });
    }).toList();

    TaskEither.sequenceList(tasks)
        .match<MessagesState>(
          (failure) => MessagesError(failure.message),
          (results) {
            final chatPlants = results.whereType<ChatPlant>().toList();
            final filteredResult = chatPlants
                .where((chat) =>
                    !chat.isExchangeCompleted && !chat.isDonationCompleted)
                .toList();
            return MessagesLoaded(chats: filteredResult);
          },
        )
        .map((s) {
          if (!isClosed) {
            emit(s);
          }
        })
        .run();
  }

  @override
  Future<void> close() {
    _chatsSub?.cancel();
    _exchangesSub?.cancel();
    _donationsSub?.cancel();
    return super.close();
  }
}
