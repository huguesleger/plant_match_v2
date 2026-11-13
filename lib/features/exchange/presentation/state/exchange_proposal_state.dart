import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

sealed class ExchangeProposalState {
  const ExchangeProposalState();
}

class ExchangeProposalLoading extends ExchangeProposalState {
  final List<Catalog> boneMocks = List.generate(4, (_) => Catalog.boneMock());

  ExchangeProposalLoading();
}

class ExchangeProposalPicking extends ExchangeProposalState {
  final List<Catalog> userPlants;
  final Catalog targetPlant;

  const ExchangeProposalPicking({
    required this.userPlants,
    required this.targetPlant,
  });
}

class ExchangeProposalConfirming extends ExchangeProposalState {
  final List<Catalog> userPlants;
  final Catalog targetPlant;
  final Catalog offeredPlant;

  const ExchangeProposalConfirming({
    required this.userPlants,
    required this.targetPlant,
    required this.offeredPlant,
  });
}

class ExchangeProposalSending extends ExchangeProposalState {
  const ExchangeProposalSending();
}

class ExchangeProposalSuccess extends ExchangeProposalState {
  const ExchangeProposalSuccess();
}

class ExchangeProposalError extends ExchangeProposalState {
  final Failure failure;

  const ExchangeProposalError(this.failure);
}
