import 'dart:async';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangeCubit extends SafeCubit<ExchangeState> {
  final ExchangeRepository repository;
  final ChatPlantRepository chatRepository;
  Option<StreamSubscription<Option<Exchange>>> _sub = const None();

  final _catalogRepo = FirebaseCatalogRepository();
  List<Catalog> _userPlants = [];
  Option<({String targetPlantId, String targetOwnerId, String chatId})>
      _pickingTarget = const None();

  ExchangeCubit({
    required this.repository,
    required this.chatRepository,
  }) : super(ExchangeInitial());

  void listen(String chatId) {
    _sub.map((sub) => sub.cancel());

    _sub = Some(repository.watchExchange(chatId).listen(
          (found) => emit(
            found.match(
              () => ExchangeInitial(),
              (request) => switch (request.status) {
                ExchangeStatus.pending => ExchangePending(request),
                ExchangeStatus.accepted => ExchangeAccepted(request),
                ExchangeStatus.rejected => ExchangeRejected(request),
                ExchangeStatus.waitingValidation =>
                  ExchangeWaitingValidation(request),
                ExchangeStatus.completed => ExchangeCompleted(request),
              },
            ),
          ),
          onError: (_) => emit(ExchangeError('Erreur échange')),
        ));
  }

  void initExchange({
    required String userId,
    required String targetPlantId,
    required String targetOwnerId,
    required String chatId,
  }) {
    _pickingTarget = Some((
      targetPlantId: targetPlantId,
      targetOwnerId: targetOwnerId,
      chatId: chatId,
    ));

    emit(ExchangeLoading());

    _catalogRepo
        .getCatalogsByUserId(userId)
        .match(
          (failure) =>
              ExchangeError('Erreur lors de l\'initialisation de l\'échange'),
          (userPlants) {
            _userPlants = userPlants
                .where(
                  (p) =>
                      p.offerType == OfferType.exchange &&
                      p.status == CatalogStatus.published,
                )
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
    _pickingTarget.map(
      (target) => emit(ExchangePickingPlant(
        userPlants: _userPlants,
        targetPlantId: target.targetPlantId,
        targetOwnerId: target.targetOwnerId,
        chatId: target.chatId,
      )),
    );
  }

  Future<void> propose(Exchange exchange) {
    emit(ExchangeLoading());

    return chatRepository
        .payFirstContact(
          chatId: exchange.chatId,
          senderId: exchange.requestedBy,
          receiverId: exchange.ownerId,
        )
        .flatMap((_) => repository.createExchange(exchange))
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

  Future<Option<String>> accept(String requestId) => repository
      .setStatus(requestId, ExchangeStatus.accepted)
      .match<Option<String>>(
        (failure) => Some(failure.message),
        (_) => const None(),
      )
      .run();

  Future<Option<String>> reject(String requestId) => repository
      .setStatus(requestId, ExchangeStatus.rejected)
      .match<Option<String>>(
        (failure) => Some(failure.message),
        (_) => const None(),
      )
      .run();

  void markSeenByOwner(String exchangeId) {
    repository.markSeenByOwner(exchangeId).run();
  }

  void markSeenByRequester(String exchangeId) {
    repository.markSeenByRequester(exchangeId).run();
  }

  Future<Option<String>> generateCode(String exchangeId) => repository
      .generateValidationCode(exchangeId)
      .match<Option<String>>(
        (failure) => Some(failure.message),
        (_) => const None(),
      )
      .run();

  Future<Option<String>> validateCode(
    String exchangeId,
    String code,
    UserPointsCubit pointsCubit,
  ) =>
      pointsCubit
          .track(repository.validateCode(exchangeId, code))
          .then((result) => result.match(
                (failure) => Some(failure.message),
                (_) => const None(),
              ));

  Stream<Option<String>> validationCode(String exchangeId) =>
      repository.watchValidationCode(exchangeId);

  @override
  Future<void> close() {
    _sub.map((sub) => sub.cancel());
    return super.close();
  }
}
