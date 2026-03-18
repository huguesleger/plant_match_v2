import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';

class FirebaseExchange implements ExchangeRepository {
  final _col = FirebaseFirestore.instance.collection('plant_exchanges');

  @override
  Stream<Exchange?> watchExchange(String chatId) {
    return _col
        .where('chatId', isEqualTo: chatId)
        .where('status',
            whereIn: ['pending', 'accepted', 'rejected', 'completed'])
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
  TaskEither<Failure, Unit> markAsCompleted(String exchangeId, String completedBy) {
    return TaskEither.tryCatch(
      () async {
        // Récupérer l'échange pour obtenir le chatId et les IDs des plantes
        final exchangeDoc = await _col.doc(exchangeId).get();
        final exchangeData = exchangeDoc.data();

        if (exchangeData == null) throw Exception('Echange introuvable');

        final chatId = exchangeData['chatId'] as String;
        final targetPlantId = exchangeData['targetPlantId'] as String;
        final offeredPlantId = exchangeData['offeredPlantId'] as String;

        // Marquer l'échange comme terminé
        await _col.doc(exchangeId).update({
          'status': ExchangeStatus.completed.name,
          'completedAt': FieldValue.serverTimestamp(),
          'completedBy': completedBy,
        });

        // Marquer le chat comme clôturé
        await FirebaseFirestore.instance
            .collection('plant_chats')
            .doc(chatId)
            .update({'isExchangeCompleted': true});

        // Marquer les deux plantes comme archivées (retirées du catalogue public)
        await FirebaseFirestore.instance
            .collection('catalogs')
            .doc(targetPlantId)
            .update({'status': 'archived'});

        await FirebaseFirestore.instance
            .collection('catalogs')
            .doc(offeredPlantId)
            .update({'status': 'archived'});
            
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur complétion échange: $error'),
    );
  }

  @override
  Stream<List<Exchange>> getCompletedExchanges(String uid) {
    return _col
        .where(Filter.or(
          Filter('ownerId', isEqualTo: uid),
          Filter('requestedBy', isEqualTo: uid),
        ))
        .where(Filter.or(
          Filter('status', isEqualTo: 'accepted'),
          Filter('status', isEqualTo: 'completed'),
          Filter('status', isEqualTo: 'rejected'),
        ))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Exchange.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
