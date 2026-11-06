import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_item.dart';

sealed class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<HistoryItem> items;
  final HistoryStatusFilter currentFilter;

  const HistoryLoaded({
    required this.items,
    required this.currentFilter,
  });
}

class HistoryError extends HistoryState {
  final Failure failure;

  const HistoryError(this.failure);
}
