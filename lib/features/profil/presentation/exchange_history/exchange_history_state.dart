import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';

sealed class ExchangeHistoryState {}

class ExchangeHistoryInitial extends ExchangeHistoryState {}

class ExchangeHistoryLoading extends ExchangeHistoryState {}

class ExchangeHistoryLoaded extends ExchangeHistoryState {
  final List<HistoryItem> items;
  final HistoryStatusFilter currentFilter;

  ExchangeHistoryLoaded({
    required this.items,
    required this.currentFilter,
  });
}

class ExchangeHistoryError extends ExchangeHistoryState {
  final String message;
  ExchangeHistoryError(this.message);
}
