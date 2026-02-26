import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';

abstract class DonationRepository {
  Stream<Donation?> watchDonation(String chatId);

  Future<void> createDonation(Donation donation);

  Future<void> setStatus(String donationId, DonationStatus status);

  Future<void> markSeenByOwner(String donationId);

  Future<void> markSeenByRequester(String donationId);

  Future<void> markAsCompleted(String donationId, String completedBy);

  Stream<List<Donation>> getCompletedDonations(String uid);
}
