import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catolog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final ExchangeRepository repository;
  final ChatPlantRepository chatRepository;
  StreamSubscription<Exchange?>? _sub;

  final _catalogRepo = FirebaseCatalogRepository();
  List<Catalog> _userPlants = [];
  String? _targetPlantId;
  String? _targetOwnerId;
  String? _chatId;

  ExchangeCubit({
    required this.repository,
    required this.chatRepository,
  }) : super(ExchangeInitial());

  void listen(String chatId) {
    _sub?.cancel();

    _sub = repository.watchExchange(chatId).listen(
      (request) {
        if (request == null) {
          emit(ExchangeInitial());
          return;
        }

        switch (request.status) {
          case ExchangeStatus.pending:
            emit(ExchangePending(request));
            break;
          case ExchangeStatus.accepted:
            emit(ExchangeAccepted(request));
            break;
          case ExchangeStatus.rejected:
            emit(ExchangeRejected(request));
            break;
          case ExchangeStatus.completed:
            emit(ExchangeCompleted(request));
            break;
        }
      },
      onError: (_) => emit(ExchangeError('Erreur échange')),
    );
  }

  void initExchange({
    required String userId,
    required String targetPlantId,
    required String targetOwnerId,
    required String chatId,
  }) {
    _targetPlantId = targetPlantId;
    _targetOwnerId = targetOwnerId;
    _chatId = chatId;

    emit(ExchangeLoading());
    
    _catalogRepo.getCatalogsByUserId(userId).run().then((result) {
      result.match(
        (failure) => emit(ExchangeError('Erreur lors de l\'initialisation de l\'échange')),
        (userPlants) {
          _userPlants = userPlants
              .where((p) => p.offerType == OfferType.exchange)
              .toList();

          emit(ExchangePickingPlant(
            userPlants: _userPlants,
            targetPlantId: targetPlantId,
            targetOwnerId: targetOwnerId,
            chatId: chatId,
          ));
        },
      );
    });
  }

  void selectPlant({
    required Catalog offeredPlant,
    required String targetPlantId,
    required String chatId,
  }) {
    emit(ExchangeLoading());
    
    _catalogRepo.getCatalogById(targetPlantId).run().then((result) {
      result.match(
        (failure) => emit(ExchangeError('Erreur lors du chargement de la plante cible')),
        (option) => option.match(
          () => emit(ExchangeError('Plante cible non trouvée')),
          (targetPlant) {
            emit(ExchangeConfirming(
              targetPlant: targetPlant,
              offeredPlant: offeredPlant,
              chatId: chatId,
            ));
          },
        ),
      );
    });
  }

  void cancelSelection() {
    if (_targetPlantId != null && _targetOwnerId != null && _chatId != null) {
      emit(ExchangePickingPlant(
        userPlants: _userPlants,
        targetPlantId: _targetPlantId!,
        targetOwnerId: _targetOwnerId!,
        chatId: _chatId!,
      ));
    }
  }

  void propose(Exchange exchange) {
    emit(ExchangeLoading());
    
    repository.createExchange(exchange).run().then((result) {
      result.match(
        (failure) => emit(ExchangeError(failure.message)),
        (_) {
          // Envoyer un message de chat avec les détails de la plante proposée
          chatRepository.sendPlantExchangeMessage(
            chatId: exchange.chatId,
            senderId: exchange.requestedBy,
            receiverId: exchange.ownerId,
            plantId: exchange.offeredPlantId,
            plantName: exchange.offeredPlantName,
            plantImage: exchange.offeredPlantImage,
          ).run().then((messageResult) {
            messageResult.match(
              (failure) => emit(ExchangeError(failure.message)),
              (_) => emit(ExchangeSuccess()),
            );
          });
        },
      );
    });
  }

  void accept(String requestId) {
    repository.setStatus(requestId, ExchangeStatus.accepted).run();
  }

  void reject(String requestId) {
    repository.setStatus(requestId, ExchangeStatus.rejected).run();
  }

  void markSeenByOwner(String exchangeId) {
    repository.markSeenByOwner(exchangeId).run();
  }

  void markSeenByRequester(String exchangeId) {
    repository.markSeenByRequester(exchangeId).run();
  }

  void complete(String exchangeId, String completedBy) {
    repository.markAsCompleted(exchangeId, completedBy).run();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
