import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';

abstract class DonationRepository {
  Stream<Option<Donation>> watchDonation(String chatId);

  TaskEither<Failure, Unit> createDonation(Donation donation);

  TaskEither<Failure, Unit> setStatus(String donationId, DonationStatus status);

  TaskEither<Failure, Unit> markSeenByOwner(String donationId);

  TaskEither<Failure, Unit> markSeenByRequester(String donationId);

  TaskEither<Failure, Unit> generateValidationCode(String donationId);

  TaskEither<Failure, PointsUpdate> validateCode(
      String donationId, String code);

  Stream<Option<String>> watchValidationCode(String donationId);

  TaskEither<Failure, List<Donation>> getCompletedDonations(String uid);

  Stream<int> unreadDonationCount(String uid);

  Stream<List<Donation>> watchUnreadDonations(String uid);
}
