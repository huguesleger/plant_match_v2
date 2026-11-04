import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';

class FirebaseExchange implements ExchangeRepository {
  final _col = FirebaseFirestore.instance.collection('plant_exchanges');

  @override
  Stream<Exchange?> watchExchange(String chatId) {
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
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          final d = snap.docs.first;
          return Exchange.fromJson(d.id, d.data());
        });
  }

  @override
  TaskEither<Failure, Unit> createExchange(Exchange exchange) {
    return TaskEither.tryCatch(
      () async {
        await _col.add(exchange.toJson());
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur création échange: $error'),
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
      (error, _) => UnexpectedFailure('Erreur statut échange: $error'),
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
      (error, _) => UnexpectedFailure('Erreur marquage vu (owner): $error'),
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
      (error, _) => UnexpectedFailure('Erreur marquage vu (requester): $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> generateValidationCode(String exchangeId) {
    return TaskEither.tryCatch(
      () async {
        final code = (100000 + Random().nextInt(900000)).toString();
        await _col.doc(exchangeId).update({
          'validationCode': code,
          'status': ExchangeStatus.waitingValidation.name,
        });
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur génération code PIN: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> validateCode(
    String exchangeId,
    String code,
    String userId,
  ) =>
      TaskEither.tryCatch(
        () => FirebaseFirestore.instance.runTransaction((transaction) async {
          final firestore = FirebaseFirestore.instance;
          final exchangeRef = _col.doc(exchangeId);
          final exchangeDoc = await transaction.get(exchangeRef);
          final exchange = Exchange.fromJson(
            exchangeDoc.id,
            Option.fromNullable(exchangeDoc.data()).getOrElse(
              () => throw const NotFoundFailure('Échange introuvable'),
            ),
          );
          final plantRefs = [exchange.targetPlantId, exchange.offeredPlantId]
              .map((id) => firestore.collection('catalogs').doc(id))
              .toList();
          final plantDocs = [
            for (final ref in plantRefs) await transaction.get(ref),
          ];

          _ensure(
            exchange.status == ExchangeStatus.waitingValidation,
            'Cet échange a déjà été validé',
          );
          _ensure(
            exchange.requestedBy == userId,
            'Seul le demandeur peut valider cet échange',
          );
          _ensure(
            exchange.validationCode.getOrElse(() => '') == code,
            'Code incorrect',
          );
          _ensure(
            plantDocs.every(
              (doc) => doc.data()?['status'] == CatalogStatus.published.name,
            ),
            'Une des plantes n\'est plus disponible',
          );

          transaction.update(exchangeRef, {
            'status': ExchangeStatus.completed.name,
            'completedAt': FieldValue.serverTimestamp(),
            'completedBy': userId,
          });
          transaction.update(
            firestore.collection('plant_chats').doc(exchange.chatId),
            {'isExchangeCompleted': true},
          );
          for (final ref in plantRefs) {
            transaction.update(ref, {'status': CatalogStatus.archived.name});
          }
          return unit;
        }),
        (error, _) => switch (error) {
          Failure() => error,
          _ => UnexpectedFailure('Erreur validation échange: $error'),
        },
      );

  void _ensure(bool condition, String message) =>
      condition ? null : throw ValidationFailure(message);

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
      (error, _) => UnexpectedFailure(
          'Erreur lors de la récupération des échanges : $error'),
    );
  }
}
