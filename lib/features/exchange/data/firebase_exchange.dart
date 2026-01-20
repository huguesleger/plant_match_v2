import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';

class FirebaseExchange implements ExchangeRepository {
  final _col = FirebaseFirestore.instance.collection('plant_exchanges');

  @override
  Stream<Exchange?> watchExchange(String chatId) {
    return _col
        .where('chatId', isEqualTo: chatId)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final d = snap.docs.first;
      return Exchange.fromJson(d.id, d.data());
    });
  }

  @override
  Future<void> createExchange(Exchange exchange) async {
    await _col.add(exchange.toJson());
  }

  @override
  Future<void> setStatus(String requestId, ExchangeStatus status) async {
    await _col.doc(requestId).update({
      'status': status.name,
      'seenByRequester': false,
    });
  }

  @override
  Stream<int> unreadExchangeCount(String uid) {
    return FirebaseFirestore.instance
        .collection('plant_exchanges')
        .where(Filter.or(
          Filter.and(
            Filter('ownerId', isEqualTo: uid),
            Filter('seenByOwner', isEqualTo: false),
          ),
          Filter.and(
            Filter('requestedBy', isEqualTo: uid),
            Filter('seenByRequester', isEqualTo: false),
          ),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Stream<List<Exchange>> watchUnreadExchanges(String uid) {
    return FirebaseFirestore.instance
        .collection('plant_exchanges')
        .where(Filter.or(
          Filter.and(
            Filter('ownerId', isEqualTo: uid),
            Filter('seenByOwner', isEqualTo: false),
          ),
          Filter.and(
            Filter('requestedBy', isEqualTo: uid),
            Filter('seenByRequester', isEqualTo: false),
          ),
        ))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Exchange.fromJson(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<void> markSeenByOwner(String exchangeId) {
    return FirebaseFirestore.instance
        .collection('plant_exchanges')
        .doc(exchangeId)
        .update({'seenByOwner': true});
  }

  @override
  Future<void> markSeenByRequester(String exchangeId) {
    return FirebaseFirestore.instance
        .collection('plant_exchanges')
        .doc(exchangeId)
        .update({'seenByRequester': true});
  }
}
