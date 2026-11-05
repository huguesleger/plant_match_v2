import 'dart:async';

import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';

class DonationCubit extends SafeCubit<DonationState> {
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

  Future<void> request(Donation donation) {
    emit(DonationLoading());

    return chatRepository
        .payFirstContact(
          chatId: donation.chatId,
          senderId: donation.requestedBy,
          receiverId: donation.ownerId,
        )
        .flatMap((_) => repository.createDonation(donation))
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

  void markSeenByOwner(String donationId) {
    repository.markSeenByOwner(donationId).run();
  }

  void markSeenByRequester(String donationId) {
    repository.markSeenByRequester(donationId).run();
  }

  Future<Option<String>> generateCode(String donationId) => repository
      .generateValidationCode(donationId)
      .match<Option<String>>(
        (failure) => Some(failure.message),
        (_) => const None(),
      )
      .run();

  Future<Option<String>> validateCode(
    String donationId,
    String code,
    UserPointsCubit pointsCubit,
  ) =>
      pointsCubit
          .track(repository.validateCode(donationId, code))
          .then((result) => result.match(
                (failure) => Some(failure.message),
                (_) => const None(),
              ));

  Stream<Option<String>> validationCode(String donationId) =>
      repository.watchValidationCode(donationId);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
