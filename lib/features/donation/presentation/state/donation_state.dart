import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';

sealed class DonationState {}

class DonationInitial extends DonationState {}

class DonationLoading extends DonationState {}

class DonationPending extends DonationState {
  final Donation donation;
  DonationPending(this.donation);
}

class DonationAccepted extends DonationState {
  final Donation donation;
  DonationAccepted(this.donation);
}

class DonationRejected extends DonationState {
  final Donation donation;
  DonationRejected(this.donation);
}

class DonationCompleted extends DonationState {
  final Donation donation;
  DonationCompleted(this.donation);
}

class DonationError extends DonationState {
  final String message;
  DonationError(this.message);
}
