import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

sealed class ExchangeState {}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangePickingPlant extends ExchangeState {
  final List<Catalog> userPlants;
  final String targetPlantId;
  final String targetOwnerId;
  final String chatId;

  ExchangePickingPlant({
    required this.userPlants,
    required this.targetPlantId,
    required this.targetOwnerId,
    required this.chatId,
  });
}

class ExchangeConfirming extends ExchangeState {
  final Catalog targetPlant;
  final Catalog offeredPlant;
  final String chatId;

  ExchangeConfirming({
    required this.targetPlant,
    required this.offeredPlant,
    required this.chatId,
  });
}

class ExchangeSuccess extends ExchangeState {}

class ExchangeError extends ExchangeState {
  final String message;
  ExchangeError(this.message);
}

class ExchangePending extends ExchangeState {
  final Exchange exchange;
  ExchangePending(this.exchange);
}

class ExchangeAccepted extends ExchangeState {
  final Exchange exchange;
  ExchangeAccepted(this.exchange);
}

class ExchangeRejected extends ExchangeState {
  final Exchange exchange;
  ExchangeRejected(this.exchange);
}

class ExchangeWaitingValidation extends ExchangeState {
  final Exchange exchange;
  ExchangeWaitingValidation(this.exchange);
}

class ExchangeCompleted extends ExchangeState {
  final Exchange exchange;
  ExchangeCompleted(this.exchange);
}
