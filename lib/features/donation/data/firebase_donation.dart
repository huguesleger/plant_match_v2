import 'package:plant_match_v2/core/util/json_reader.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/firebase/cloud_function.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';

class FirebaseDonation implements DonationRepository {
  final _firestore = FirebaseFirestore.instance;
  late final _col = _firestore.collection('plant_donations');

  @override
  Stream<Option<Donation>> watchDonation(String chatId) {
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
              .map((d) => Donation.fromJson(d.id, d.data())),
        );
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
  TaskEither<Failure, Unit> generateValidationCode(String donationId) =>
      CloudFunction.call(
        'generateHandoverCode',
        {'kind': 'donation', 'id': donationId},
      ).map((_) => unit);

  @override
  Stream<Option<String>> watchValidationCode(String donationId) => _col
      .doc(donationId)
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
    String donationId,
    String code,
  ) =>
      CloudFunction.call(
        'validateHandover',
        {'kind': 'donation', 'id': donationId, 'code': code},
      ).map(PointsUpdate.fromJson);

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
