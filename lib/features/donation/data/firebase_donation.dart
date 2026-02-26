import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> createDonation(Donation donation) async {
    final data = donation.toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _col.add(data);
  }

  @override
  Future<void> setStatus(String donationId, DonationStatus status) async {
    await _col.doc(donationId).update({
      'status': status.name,
      'seenByRequester': false,
    });
  }

  @override
  Future<void> markSeenByOwner(String donationId) {
    return _col.doc(donationId).update({'seenByOwner': true});
  }

  @override
  Future<void> markSeenByRequester(String donationId) {
    return _col.doc(donationId).update({'seenByRequester': true});
  }

  @override
  Future<void> markAsCompleted(String donationId, String completedBy) async {
    final doc = await _col.doc(donationId).get();
    final data = doc.data();
    if (data == null) return;

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
  }

  @override
  Stream<List<Donation>> getCompletedDonations(String uid) {
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
        .map((snap) =>
            snap.docs.map((d) => Donation.fromJson(d.id, d.data())).toList());
  }
}
