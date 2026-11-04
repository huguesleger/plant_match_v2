import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';

class FirebaseDonation implements DonationRepository {
  final _firestore = FirebaseFirestore.instance;
  late final _col = _firestore.collection('plant_donations');

  @override
  Stream<Donation?> watchDonation(String chatId) {
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
          return Donation.fromJson(d.id, d.data());
        });
  }

  @override
  TaskEither<Failure, Unit> createDonation(Donation donation) {
    return TaskEither.tryCatch(
      () async {
        final data = donation.toJson();
        data['createdAt'] = FieldValue.serverTimestamp();
        await _col.add(data);
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur création donation: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> setStatus(
      String donationId, DonationStatus status) {
    return TaskEither.tryCatch(
      () async {
        await _col.doc(donationId).update({
          'status': status.name,
          'seenByRequester': false,
        });
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur statut donation: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> markSeenByOwner(String donationId) {
    return TaskEither.tryCatch(
      () async {
        await _col.doc(donationId).update({'seenByOwner': true});
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur marquage vu (owner): $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> markSeenByRequester(String donationId) {
    return TaskEither.tryCatch(
      () async {
        await _col.doc(donationId).update({'seenByRequester': true});
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur marquage vu (requester): $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> generateValidationCode(String donationId) {
    return TaskEither.tryCatch(
      () async {
        final code = (100000 + Random().nextInt(900000)).toString();
        await _col.doc(donationId).update({
          'validationCode': code,
          'status': DonationStatus.waitingValidation.name,
        });
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur génération code PIN: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> validateCode(
    String donationId,
    String code,
    String userId,
  ) =>
      TaskEither.tryCatch(
        () => _firestore.runTransaction((transaction) async {
          final donationRef = _col.doc(donationId);
          final donationDoc = await transaction.get(donationRef);
          final donation = Donation.fromJson(
            donationDoc.id,
            Option.fromNullable(donationDoc.data()).getOrElse(
              () => throw const NotFoundFailure('Don introuvable'),
            ),
          );
          final plantRef =
              _firestore.collection('catalogs').doc(donation.plantId);
          final plantDoc = await transaction.get(plantRef);

          _ensure(
            donation.status == DonationStatus.waitingValidation,
            'Ce don a déjà été validé',
          );
          _ensure(
            donation.requestedBy == userId,
            'Seul le demandeur peut valider ce don',
          );
          _ensure(
            donation.validationCode.getOrElse(() => '') == code,
            'Code incorrect',
          );
          _ensure(
            plantDoc.data()?['status'] == CatalogStatus.published.name,
            'Cette plante n\'est plus disponible',
          );

          transaction.update(donationRef, {
            'status': DonationStatus.completed.name,
            'completedAt': FieldValue.serverTimestamp(),
            'completedBy': userId,
          });
          transaction.update(
            _firestore.collection('plant_chats').doc(donation.chatId),
            {'isDonationCompleted': true},
          );
          transaction.update(
            plantRef,
            {'status': CatalogStatus.archived.name},
          );
          return unit;
        }),
        (error, _) => switch (error) {
          Failure() => error,
          _ => UnexpectedFailure('Erreur validation don: $error'),
        },
      );

  void _ensure(bool condition, String message) =>
      condition ? null : throw ValidationFailure(message);

  @override
  TaskEither<Failure, List<Donation>> getCompletedDonations(String uid) {
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

        final uniqueDonations = results
            .expand((snap) => snap.docs)
            .map((doc) => Donation.fromJson(doc.id, doc.data()))
            .fold<Map<String, Donation>>(
              {},
              (map, donation) => map..putIfAbsent(donation.id, () => donation),
            )
            .values
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return uniqueDonations;
      },
      (error, _) => UnexpectedFailure(
          'Erreur lors de la récupération des donations : $error'),
    );
  }

  @override
  Stream<int> unreadDonationCount(String uid) {
    return FirebaseFirestore.instance
        .collection('plant_donations')
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
  Stream<List<Donation>> watchUnreadDonations(String uid) {
    return FirebaseFirestore.instance
        .collection('plant_donations')
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
          .map((doc) => Donation.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
