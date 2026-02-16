import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_cubit.dart';

sealed class ExchangeHistoryState {}

class ExchangeHistoryInitial extends ExchangeHistoryState {}

class ExchangeHistoryLoading extends ExchangeHistoryState {}

class ExchangeHistoryLoaded extends ExchangeHistoryState {
  final List<Exchange> exchanges;
  final ExchangeStatusFilter currentFilter;

  ExchangeHistoryLoaded({
    required this.exchanges,
    required this.currentFilter,
  });
}

class ExchangeHistoryError extends ExchangeHistoryState {
  final String message;

  ExchangeHistoryError(this.message);
}
