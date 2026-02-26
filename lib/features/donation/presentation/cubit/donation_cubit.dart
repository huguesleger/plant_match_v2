import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';

class DonationCubit extends Cubit<DonationState> {
  final DonationRepository repository;
  StreamSubscription<Donation?>? _sub;

  DonationCubit({required this.repository}) : super(DonationInitial());

  void listen(String chatId) {
    _sub?.cancel();

    _sub = repository.watchDonation(chatId).listen(
      (donation) {
        if (donation == null) {
          emit(DonationInitial());
          return;
        }

        switch (donation.status) {
          case DonationStatus.pending:
            emit(DonationPending(donation));
            break;
          case DonationStatus.accepted:
            emit(DonationAccepted(donation));
            break;
          case DonationStatus.rejected:
            emit(DonationRejected(donation));
            break;
          case DonationStatus.completed:
            emit(DonationCompleted(donation));
            break;
        }
      },
      onError: (_) => emit(DonationError('Erreur donation')),
    );
  }

  Future<void> request(Donation donation) async {
    try {
      await repository.createDonation(donation);
    } catch (e) {
      emit(DonationError(e.toString()));
    }
  }

  Future<void> accept(String donationId) async {
    await repository.setStatus(donationId, DonationStatus.accepted);
  }

  Future<void> reject(String donationId) async {
    await repository.setStatus(donationId, DonationStatus.rejected);
  }

  Future<void> complete(String donationId, String completedBy) async {
    await repository.markAsCompleted(donationId, completedBy);
  }

  Future<void> markSeenByOwner(String donationId) {
    return repository.markSeenByOwner(donationId);
  }

  Future<void> markSeenByRequester(String donationId) {
    return repository.markSeenByRequester(donationId);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
