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

  // ─── request ───────────────────────────────────────────────────────────────

  void request(Donation donation) {
    emit(DonationLoading());

    repository
        .createDonation(donation)
        .match(
          (failure) => DonationError(failure.message),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  // ─── accept ────────────────────────────────────────────────────────────────

  void accept(String donationId) {
    repository
        .setStatus(donationId, DonationStatus.accepted)
        .match(
          (failure) => DonationError(failure.message),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  // ─── reject ────────────────────────────────────────────────────────────────

  void reject(String donationId) {
    repository
        .setStatus(donationId, DonationStatus.rejected)
        .match(
          (failure) => DonationError(failure.message),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  // ─── complete ──────────────────────────────────────────────────────────────

  void complete(String donationId, String completedBy) {
    repository
        .markAsCompleted(donationId, completedBy)
        .match(
          (failure) => DonationError(failure.message),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  void markSeenByOwner(String donationId) {
    repository.markSeenByOwner(donationId).run();
  }

  void markSeenByRequester(String donationId) {
    repository.markSeenByRequester(donationId).run();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
