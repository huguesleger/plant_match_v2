import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/task_either_minimal_delay/task_either_minimal_delay.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/core/widgets/skeleton/skeleton_effect.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_proposal_state.dart';

class ExchangeProposalCubit extends SafeCubit<ExchangeProposalState> {
  final CatalogRepository catalogRepository;
  final ExchangeRepository exchangeRepository;
  final ChatPlantRepository chatRepository;
  final String userId;
  final String targetPlantId;
  final String chatId;

  ExchangeProposalCubit({
    required this.catalogRepository,
    required this.exchangeRepository,
    required this.chatRepository,
    required this.userId,
    required this.targetPlantId,
    required this.chatId,
  }) : super(ExchangeProposalLoading());

  void load() {
    emit(ExchangeProposalLoading());
    _fetch()
        .withMinimalDelay(SkeletonEffect.shimmerMinimumDelay)
        .match(
          (failure) => ExchangeProposalError(failure),
          (data) => ExchangeProposalPicking(
            userPlants: data.$1,
            targetPlant: data.$2,
          ),
        )
        .map(emit)
        .run();
  }

  void selectPlant(Catalog offeredPlant) => emit(switch (state) {
        ExchangeProposalPicking(:final userPlants, :final targetPlant) =>
          ExchangeProposalConfirming(
            userPlants: userPlants,
            targetPlant: targetPlant,
            offeredPlant: offeredPlant,
          ),
        ExchangeProposalLoading() ||
        ExchangeProposalConfirming() ||
        ExchangeProposalSending() ||
        ExchangeProposalSuccess() ||
        ExchangeProposalError() =>
          state,
      });

  void cancelSelection() => emit(switch (state) {
        ExchangeProposalConfirming(:final userPlants, :final targetPlant) =>
          ExchangeProposalPicking(
            userPlants: userPlants,
            targetPlant: targetPlant,
          ),
        ExchangeProposalLoading() ||
        ExchangeProposalPicking() ||
        ExchangeProposalSending() ||
        ExchangeProposalSuccess() ||
        ExchangeProposalError() =>
          state,
      });

  Future<Unit> propose({
    required Catalog targetPlant,
    required Catalog offeredPlant,
  }) {
    final exchange = Exchange.proposal(
      chatId: chatId,
      requestedBy: userId,
      targetPlant: targetPlant,
      offeredPlant: offeredPlant,
    );
    emit(const ExchangeProposalSending());
    return chatRepository
        .payFirstContact(
          chatId: exchange.chatId,
          senderId: exchange.requestedBy,
          receiverId: exchange.ownerId,
        )
        .flatMap((_) => exchangeRepository.createExchange(exchange))
        .flatMap((_) => chatRepository.sendPlantExchangeMessage(
              chatId: exchange.chatId,
              senderId: exchange.requestedBy,
              receiverId: exchange.ownerId,
              plantId: exchange.offeredPlantId,
              plantName: exchange.offeredPlantName,
              plantImage: exchange.offeredPlantImage,
            ))
        .match<ExchangeProposalState>(
          (failure) => ExchangeProposalError(failure),
          (_) => const ExchangeProposalSuccess(),
        )
        .map(emit)
        .map((_) => unit)
        .run();
  }

  TaskEither<Failure, (List<Catalog>, Catalog)> _fetch() => catalogRepository
      .getCatalogsByUserId(userId)
      .map((plants) => plants.where(_isExchangeable).toList())
      .flatMap(
        (plants) => catalogRepository.getCatalogById(targetPlantId).flatMap(
              (target) => target.match(
                () => TaskEither.left(
                  const NotFoundFailure('Target plant not found'),
                ),
                (plant) => TaskEither.right((plants, plant)),
              ),
            ),
      );

  static bool _isExchangeable(Catalog plant) =>
      plant.offerType == OfferType.exchange &&
      plant.status == CatalogStatus.published;
}
