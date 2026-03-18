import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';

sealed class ExchangeHistoryState {
  const ExchangeHistoryState();
}

class ExchangeHistoryInitial extends ExchangeHistoryState {
  const ExchangeHistoryInitial();
}

class ExchangeHistoryLoading extends ExchangeHistoryState {
  const ExchangeHistoryLoading();
}

class ExchangeHistoryLoaded extends ExchangeHistoryState {
  final List<HistoryItem> items;
  final HistoryStatusFilter currentFilter;

  const ExchangeHistoryLoaded({
    required this.items,
    required this.currentFilter,
  });
}

class ExchangeHistoryError extends ExchangeHistoryState {
  final String message;

  const ExchangeHistoryError(this.message);
}
