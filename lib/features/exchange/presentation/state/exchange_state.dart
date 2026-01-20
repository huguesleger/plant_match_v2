import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

sealed class ExchangeState {}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangeLoaded extends ExchangeState {
  final Exchange? exchange;

  ExchangeLoaded(this.exchange);
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

class ExchangeError extends ExchangeState {
  final String message;

  ExchangeError(this.message);
}
