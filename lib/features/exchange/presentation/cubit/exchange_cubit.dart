import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
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

        emit(
          switch (request.status) {
            ExchangeStatus.pending => ExchangePending(request),
            ExchangeStatus.accepted => ExchangeAccepted(request),
            ExchangeStatus.rejected => ExchangeRejected(request),
            ExchangeStatus.completed => ExchangeCompleted(request),
          },
        );
      },
      onError: (_) => emit(ExchangeError('Erreur échange')),
    );
  }

  // ─── initExchange ──────────────────────────────────────────────────────────

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

    _catalogRepo
        .getCatalogsByUserId(userId)
        .match(
          (failure) =>
              ExchangeError('Erreur lors de l\'initialisation de l\'échange'),
          (userPlants) {
            _userPlants = userPlants
                .where((p) => p.offerType == OfferType.exchange)
                .toList();

            return ExchangePickingPlant(
              userPlants: _userPlants,
              targetPlantId: targetPlantId,
              targetOwnerId: targetOwnerId,
              chatId: chatId,
            );
          },
        )
        .map(emit)
        .run();
  }

  // ─── selectPlant ───────────────────────────────────────────────────────────

  void selectPlant({
    required Catalog offeredPlant,
    required String targetPlantId,
    required String chatId,
  }) {
    emit(ExchangeLoading());

    _catalogRepo
        .getCatalogById(targetPlantId)
        .match(
          (failure) =>
              ExchangeError('Erreur lors du chargement de la plante cible'),
          (option) => option.match(
            () => ExchangeError('Plante cible non trouvée'),
            (targetPlant) => ExchangeConfirming(
              targetPlant: targetPlant,
              offeredPlant: offeredPlant,
              chatId: chatId,
            ),
          ),
        )
        .map(emit)
        .run();
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

  // ─── propose ───────────────────────────────────────────────────────────────

  void propose(Exchange exchange) {
    emit(ExchangeLoading());

    repository
        .createExchange(exchange)
        .flatMap((_) => chatRepository.sendPlantExchangeMessage(
              chatId: exchange.chatId,
              senderId: exchange.requestedBy,
              receiverId: exchange.ownerId,
              plantId: exchange.offeredPlantId,
              plantName: exchange.offeredPlantName,
              plantImage: exchange.offeredPlantImage,
            ))
        .match(
          (failure) => ExchangeError(failure.message),
          (_) => ExchangeSuccess(),
        )
        .map(emit)
        .run();
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
