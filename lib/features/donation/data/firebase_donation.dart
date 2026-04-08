import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';

class FirebaseDonation implements DonationRepository {
  final _col = FirebaseFirestore.instance.collection('plant_donations');

  @override
  Stream<Donation?> watchDonation(String chatId) {
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
  TaskEither<Failure, Unit> setStatus(String donationId, DonationStatus status) {
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
  TaskEither<Failure, Unit> markAsCompleted(String donationId, String completedBy) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _col.doc(donationId).get();
        final data = doc.data();
        if (data == null) throw Exception('Donation introuvable');

        final chatId = data['chatId'] as String;
        final plantId = data['plantId'] as String;

        // Marquer la donation comme terminée
        await _col.doc(donationId).update({
          'status': DonationStatus.completed.name,
          'completedAt': FieldValue.serverTimestamp(),
          'completedBy': completedBy,
        });

        // Marquer le chat comme clôturé
        await FirebaseFirestore.instance
            .collection('plant_chats')
            .doc(chatId)
            .update({'isDonationCompleted': true});

        // Archiver la plante donnée
        await FirebaseFirestore.instance
            .collection('catalogs')
            .doc(plantId)
            .update({'status': 'archived'});
            
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur complétion donation: $error'),
    );
  }

  @override
  TaskEither<Failure, List<Donation>> getCompletedDonations(String uid) {
    const statuses = ['accepted', 'completed', 'rejected'];

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
      (error, _) => UnexpectedFailure('Erreur lors de la récupération des donations : $error'),
    );
  }
}
