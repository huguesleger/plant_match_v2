import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';

class DonationCubit extends Cubit<DonationState> {
  final DonationRepository repository;
  final ChatPlantRepository chatRepository;
  StreamSubscription<Donation?>? _sub;

  DonationCubit({
    required this.repository,
    required this.chatRepository,
  }) : super(DonationInitial());

  void listen(String chatId) {
    _sub?.cancel();

    _sub = repository.watchDonation(chatId).listen(
      (donation) {
        if (donation == null) {
          emit(DonationInitial());
          return;
        }

        if (!isClosed) {
          emit(
            switch (donation.status) {
              DonationStatus.pending => DonationPending(donation),
              DonationStatus.accepted => DonationAccepted(donation),
              DonationStatus.rejected => DonationRejected(donation),
              DonationStatus.waitingValidation =>
                DonationWaitingValidation(donation),
              DonationStatus.completed => DonationCompleted(donation),
            },
          );
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
        .flatMap((_) => chatRepository.sendPlantDonationMessage(
              chatId: donation.chatId,
              senderId: donation.requestedBy,
              receiverId: donation.ownerId,
              plantId: donation.plantId,
              plantName: donation.plantName,
              plantImage: donation.plantImage,
            ))
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

  void generateCode(String donationId) {
    repository.generateValidationCode(donationId).run();
  }

  void validateCode(String donationId, String code, String userId) {
    repository.validateCode(donationId, code, userId).run();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
