import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/unread_exhange_state.dart';

class UnreadExchangesCubit extends Cubit<UnreadExchangesState> {
  final ExchangeRepository repository;
  StreamSubscription? _sub;

  UnreadExchangesCubit({required this.repository})
      : super(const UnreadExchangesInitial());

  void listen(String uid) {
    _sub?.cancel();
    _sub = repository.unreadExchangeCount(uid).listen((count) {
      if (!isClosed) {
        emit(UnreadExchangesLoaded(count));
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
