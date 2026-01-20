import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final ExchangeRepository repository;
  StreamSubscription<Exchange?>? _sub;

  ExchangeCubit({required this.repository}) : super(ExchangeInitial());

  void listen(String chatId) {
    _sub?.cancel();

    _sub = repository.watchExchange(chatId).listen(
      (request) {
        if (request == null) {
          emit(ExchangeInitial());
          return;
        }

        switch (request.status) {
          case ExchangeStatus.pending:
            emit(ExchangePending(request));
            break;
          case ExchangeStatus.accepted:
            emit(ExchangeAccepted(request));
            break;
          case ExchangeStatus.rejected:
            emit(ExchangeRejected(request));
            break;
        }
      },
      onError: (_) => emit(ExchangeError('Erreur échange')),
    );
  }

  Future<void> propose(Exchange exchange) async {
    try {
      await repository.createExchange(exchange);
    } catch (e) {
      emit(ExchangeError(e.toString()));
    }
  }

  Future<void> accept(String requestId) async {
    await repository.setStatus(requestId, ExchangeStatus.accepted);
  }

  Future<void> reject(String requestId) async {
    await repository.setStatus(requestId, ExchangeStatus.rejected);
  }

  Future<void> markSeenByOwner(String exchangeId) {
    return repository.markSeenByOwner(exchangeId);
  }

  Future<void> markSeenByRequester(String exchangeId) {
    return repository.markSeenByRequester(exchangeId);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
