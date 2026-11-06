import 'package:plant_match_v2/core/util/json_reader.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/firebase/cloud_function.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';

class FirebaseExchange implements ExchangeRepository {
  final _col = FirebaseFirestore.instance.collection('plant_exchanges');

  @override
  Stream<Option<Exchange>> watchExchange(String chatId) {
    return _col
        .where('chatId', isEqualTo: chatId)
        .where('status', whereIn: [
          'pending',
          'accepted',
          'rejected',
          'waitingValidation',
          'completed'
        ])
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map(
          (snap) => Option.fromNullable(snap.docs.firstOrNull)
              .map((d) => Exchange.fromJson(d.id, d.data())),
        );
  }

  @override
  TaskEither<Failure, Unit> createExchange(Exchange exchange) {
    return TaskEither.tryCatch(
      () async {
        await _col.add({
          ...exchange.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> setStatus(String requestId, ExchangeStatus status) {
    return TaskEither.tryCatch(
      () async {
        await _col.doc(requestId).update({
          'status': status.name,
          'seenByRequester': false,
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
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
  TaskEither<Failure, Unit> markSeenByOwner(String exchangeId) {
    return TaskEither.tryCatch(
      () async {
        await FirebaseFirestore.instance
            .collection('plant_exchanges')
            .doc(exchangeId)
            .update({'seenByOwner': true});
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> markSeenByRequester(String exchangeId) {
    return TaskEither.tryCatch(
      () async {
        await FirebaseFirestore.instance
            .collection('plant_exchanges')
            .doc(exchangeId)
            .update({'seenByRequester': true});
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> generateValidationCode(String exchangeId) =>
      CloudFunction.call(
        'generateHandoverCode',
        {'kind': 'exchange', 'id': exchangeId},
      ).map((_) => unit);

  @override
  Stream<Option<String>> watchValidationCode(String exchangeId) => _col
      .doc(exchangeId)
      .collection('private')
      .doc('validation')
      .snapshots()
      .map(
        (doc) => Option.fromNullable(doc.data())
            .flatMap((data) => data.read<String>('code')),
      )
      .handleError((_) => const None());

  @override
  TaskEither<Failure, PointsUpdate> validateCode(
    String exchangeId,
    String code,
  ) =>
      CloudFunction.call(
        'validateHandover',
        {'kind': 'exchange', 'id': exchangeId, 'code': code},
      ).map(PointsUpdate.fromJson);

  @override
  TaskEither<Failure, int> completedExchangeCount(String uid) =>
      CloudFunction.call('getCompletedExchangeCount', {'uid': uid}).map(
        (data) => Option<dynamic>.fromNullable(data['count'])
            .map((value) => (value as num).toInt())
            .getOrElse(() => 0),
      );

  @override
  TaskEither<Failure, List<Exchange>> getCompletedExchanges(String uid) {
    const statuses = ['accepted', 'waitingValidation', 'completed', 'rejected'];

    return TaskEither.tryCatch(
      () async {
        final results = await Future.wait([
          _col
              .where('ownerId', isEqualTo: uid)
              .where('status', whereIn: statuses)
              .orderBy('createdAt', descending: true)
              .get(),
          _col
              .where('requestedBy', isEqualTo: uid)
              .where('status', whereIn: statuses)
              .orderBy('createdAt', descending: true)
              .get(),
        ]);

        final uniqueExchanges = results
            .expand((snap) => snap.docs)
            .map((doc) => Exchange.fromJson(doc.id, doc.data()))
            .fold<Map<String, Exchange>>(
              {},
              (map, exchange) => map..putIfAbsent(exchange.id, () => exchange),
            )
            .values
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return uniqueExchanges;
      },
      (error, _) => mapError(error),
    );
  }
}
