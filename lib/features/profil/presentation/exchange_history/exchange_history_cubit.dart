import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_state.dart';

class ExchangeHistoryCubit extends Cubit<ExchangeHistoryState> {
  final ExchangeRepository repository;
  final String userId;
  StreamSubscription<List<Exchange>>? _subscription;

  ExchangeHistoryCubit({
    required this.repository,
    required this.userId,
  }) : super(ExchangeHistoryInitial());

  void load({ExchangeStatusFilter filter = ExchangeStatusFilter.all}) {
    emit(ExchangeHistoryLoading());

    _subscription?.cancel();
    _subscription = repository.getCompletedExchanges(userId).listen(
      (exchanges) {
        final filteredExchanges = _filterExchanges(exchanges, filter);
        emit(ExchangeHistoryLoaded(
          exchanges: filteredExchanges,
          currentFilter: filter,
        ));
      },
      onError: (e) {
        print(e);
        emit(ExchangeHistoryError(e.toString()));
      },
    );
  }

  List<Exchange> _filterExchanges(
    List<Exchange> exchanges,
    ExchangeStatusFilter filter,
  ) {
    switch (filter) {
      case ExchangeStatusFilter.all:
        return exchanges;
      case ExchangeStatusFilter.accepted:
        return exchanges
            .where((e) => e.status == ExchangeStatus.accepted)
            .toList();
      case ExchangeStatusFilter.completed:
        return exchanges
            .where((e) => e.status == ExchangeStatus.completed)
            .toList();
      case ExchangeStatusFilter.rejected:
        return exchanges
            .where((e) => e.status == ExchangeStatus.rejected)
            .toList();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

enum ExchangeStatusFilter {
  all,
  accepted,
  completed,
  rejected,
}
