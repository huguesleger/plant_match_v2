import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';

abstract class ExchangeRepository {
  Stream<Exchange?> watchExchange(String chatId);

  Future<void> createExchange(Exchange exchange);

  Future<void> setStatus(String requestId, ExchangeStatus status);

  Stream<int> unreadExchangeCount(String uid);
  Stream<List<Exchange>> watchUnreadExchanges(String uid);

  Future<void> markSeenByOwner(String exchangeId);
  Future<void> markSeenByRequester(String exchangeId);
}
