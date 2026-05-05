import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';

abstract class DonationRepository {
  Stream<Donation?> watchDonation(String chatId);

  TaskEither<Failure, Unit> createDonation(Donation donation);

  TaskEither<Failure, Unit> setStatus(String donationId, DonationStatus status);

  TaskEither<Failure, Unit> markSeenByOwner(String donationId);

  TaskEither<Failure, Unit> markSeenByRequester(String donationId);

  TaskEither<Failure, Unit> markAsCompleted(String donationId, String completedBy);

  TaskEither<Failure, Unit> generateValidationCode(String donationId);

  TaskEither<Failure, Unit> validateCode(String donationId, String code, String userId);

  TaskEither<Failure, List<Donation>> getCompletedDonations(String uid);
}
