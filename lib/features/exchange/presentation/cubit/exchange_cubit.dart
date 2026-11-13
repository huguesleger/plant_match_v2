import 'dart:async';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangeCubit extends SafeCubit<ExchangeState> {
  final ExchangeRepository repository;
  Option<StreamSubscription<Option<Exchange>>> _sub = const None();

  ExchangeCubit({
    required this.repository,
  }) : super(ExchangeInitial());

  void listen(String chatId) {
    _sub.map((sub) => sub.cancel());

    _sub = Some(repository.watchExchange(chatId).listen(
          (found) => emit(
            found.match(
              () => ExchangeInitial(),
              (request) => switch (request.status) {
                ExchangeStatus.pending => ExchangePending(request),
                ExchangeStatus.accepted => ExchangeAccepted(request),
                ExchangeStatus.rejected => ExchangeRejected(request),
                ExchangeStatus.waitingValidation =>
                  ExchangeWaitingValidation(request),
                ExchangeStatus.completed => ExchangeCompleted(request),
              },
            ),
          ),
          onError: (Object error) => emit(ExchangeError(mapError(error))),
        ));
  }

  Future<Option<Failure>> accept(String requestId) => repository
      .setStatus(requestId, ExchangeStatus.accepted)
      .match<Option<Failure>>(
        (failure) => Some(failure),
        (_) => const None(),
      )
      .run();

  Future<Option<Failure>> reject(String requestId) => repository
      .setStatus(requestId, ExchangeStatus.rejected)
      .match<Option<Failure>>(
        (failure) => Some(failure),
        (_) => const None(),
      )
      .run();

  void markSeenByOwner(String exchangeId) {
    repository.markSeenByOwner(exchangeId).run();
  }

  void markSeenByRequester(String exchangeId) {
    repository.markSeenByRequester(exchangeId).run();
  }

  Future<Option<Failure>> generateCode(String exchangeId) => repository
      .generateValidationCode(exchangeId)
      .match<Option<Failure>>(
        (failure) => Some(failure),
        (_) => const None(),
      )
      .run();

  Future<Option<Failure>> validateCode(
    String exchangeId,
    String code,
    UserPointsCubit pointsCubit,
  ) =>
      pointsCubit
          .track(repository.validateCode(exchangeId, code))
          .then((result) => result.match(
                (failure) => Some(failure),
                (_) => const None(),
              ));

  Stream<Option<String>> validationCode(String exchangeId) =>
      repository.watchValidationCode(exchangeId);

  @override
  Future<void> close() {
    _sub.map((sub) => sub.cancel());
    return super.close();
  }
}
