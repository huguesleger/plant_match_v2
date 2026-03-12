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

  Future<void> initExchange({
    required String userId,
    required String targetPlantId,
    required String targetOwnerId,
    required String chatId,
  }) async {
    _targetPlantId = targetPlantId;
    _targetOwnerId = targetOwnerId;
    _chatId = chatId;

    emit(ExchangeLoading());
    try {
      final userPlants = await _catalogRepo.getCatalogsByUserId(userId);
      _userPlants = userPlants
          .where((p) => p.offerType == OfferType.exchange)
          .toList();

      emit(ExchangePickingPlant(
        userPlants: _userPlants,
        targetPlantId: targetPlantId,
        targetOwnerId: targetOwnerId,
        chatId: chatId,
      ));
    } catch (e) {
      emit(ExchangeError('Erreur lors de l\'initialisation de l\'échange'));
    }
  }

  Future<void> selectPlant({
    required Catalog offeredPlant,
    required String targetPlantId,
    required String chatId,
  }) async {
    emit(ExchangeLoading());
    try {
      final targetPlant = await _catalogRepo.getCatalogById(targetPlantId);
      if (targetPlant == null) throw Exception('Plante cible non trouvée');

      emit(ExchangeConfirming(
        targetPlant: targetPlant,
        offeredPlant: offeredPlant,
        chatId: chatId,
      ));
    } catch (e) {
      emit(ExchangeError('Erreur lors du chargement de la plante cible'));
    }
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

  Future<void> propose(Exchange exchange) async {
    emit(ExchangeLoading());
    try {
      await repository.createExchange(exchange);

      // Envoyer un message de chat avec les détails de la plante proposée
      await chatRepository.sendPlantExchangeMessage(
        chatId: exchange.chatId,
        senderId: exchange.requestedBy,
        receiverId: exchange.ownerId,
        plantId: exchange.offeredPlantId,
        plantName: exchange.offeredPlantName,
        plantImage: exchange.offeredPlantImage,
      );
      emit(ExchangeSuccess());
    } catch (e) {
      emit(ExchangeError(e.toString()));
    }
  }

  Future<void> accept(String requestId) async {
    await repository.setStatus(requestId, ExchangeStatus.accepted);
  }

  Future<void> reject(String requestId) async {
    await repository.setStatus(requestId, ExchangeStatus.rejected);
  }

  Future<void> markSeenByOwner(String exchangeId) {
    return repository.markSeenByOwner(exchangeId);
  }

  Future<void> markSeenByRequester(String exchangeId) {
    return repository.markSeenByRequester(exchangeId);
  }

  Future<void> complete(String exchangeId, String completedBy) async {
    await repository.markAsCompleted(exchangeId, completedBy);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
