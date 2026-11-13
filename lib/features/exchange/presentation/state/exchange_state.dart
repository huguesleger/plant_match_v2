import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

sealed class ExchangeState {}

class ExchangeInitial extends ExchangeState {}

class ExchangeError extends ExchangeState {
  final Failure failure;
  ExchangeError(this.failure);
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
