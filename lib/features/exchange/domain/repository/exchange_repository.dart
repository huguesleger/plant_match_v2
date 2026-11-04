import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

abstract class ExchangeRepository {
  Stream<Exchange?> watchExchange(String chatId);

  TaskEither<Failure, Unit> createExchange(Exchange exchange);

  TaskEither<Failure, Unit> setStatus(String requestId, ExchangeStatus status);

  Stream<int> unreadExchangeCount(String uid);
  Stream<List<Exchange>> watchUnreadExchanges(String uid);

  TaskEither<Failure, Unit> markSeenByOwner(String exchangeId);
  TaskEither<Failure, Unit> markSeenByRequester(String exchangeId);

  TaskEither<Failure, Unit> generateValidationCode(String exchangeId);
  TaskEither<Failure, PointsUpdate> validateCode(String exchangeId, String code);

  Stream<Option<String>> watchValidationCode(String exchangeId);
  TaskEither<Failure, List<Exchange>> getCompletedExchanges(String uid);

  /// Nombre d'échanges terminés de n'importe quel utilisateur (agrégé côté serveur).
  TaskEither<Failure, int> completedExchangeCount(String uid);
}
