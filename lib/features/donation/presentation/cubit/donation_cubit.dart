import 'dart:async';

import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';

class DonationCubit extends SafeCubit<DonationState> {
  final DonationRepository repository;
  final ChatPlantRepository chatRepository;
  Option<StreamSubscription<Option<Donation>>> _sub = const None();

  DonationCubit({
    required this.repository,
    required this.chatRepository,
  }) : super(DonationInitial());

  void listen(String chatId) {
    _sub.map((sub) => sub.cancel());

    _sub = Some(repository.watchDonation(chatId).listen(
          (found) => emit(
            found.match(
              () => DonationInitial(),
              (donation) => switch (donation.status) {
                DonationStatus.pending => DonationPending(donation),
                DonationStatus.accepted => DonationAccepted(donation),
                DonationStatus.rejected => DonationRejected(donation),
                DonationStatus.waitingValidation =>
                  DonationWaitingValidation(donation),
                DonationStatus.completed => DonationCompleted(donation),
              },
            ),
          ),
          onError: (Object error) => emit(DonationError(mapError(error))),
        ));
  }

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
          (failure) => DonationError(failure),
          (_) => state,
        )
        .map(emit)
        .run();
  }

  Future<Option<Failure>> accept(String donationId) => repository
      .setStatus(donationId, DonationStatus.accepted)
      .match<Option<Failure>>(
        (failure) => Some(failure),
        (_) => const None(),
      )
      .run();

  Future<Option<Failure>> reject(String donationId) => repository
      .setStatus(donationId, DonationStatus.rejected)
      .match<Option<Failure>>(
        (failure) => Some(failure),
        (_) => const None(),
      )
      .run();

  void markSeenByOwner(String donationId) {
    repository.markSeenByOwner(donationId).run();
  }

  void markSeenByRequester(String donationId) {
    repository.markSeenByRequester(donationId).run();
  }

  Future<Option<Failure>> generateCode(String donationId) => repository
      .generateValidationCode(donationId)
      .match<Option<Failure>>(
        (failure) => Some(failure),
        (_) => const None(),
      )
      .run();

  Future<Option<Failure>> validateCode(
    String donationId,
    String code,
    UserPointsCubit pointsCubit,
  ) =>
      pointsCubit
          .track(repository.validateCode(donationId, code))
          .then((result) => result.match(
                (failure) => Some(failure),
                (_) => const None(),
              ));

  Stream<Option<String>> validationCode(String donationId) =>
      repository.watchValidationCode(donationId);

  @override
  Future<void> close() {
    _sub.map((sub) => sub.cancel());
    return super.close();
  }
}
