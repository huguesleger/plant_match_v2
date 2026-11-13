import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/domain/repository/profil_repository.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';

import 'package:plant_match_v2/core/services/location/location_service.dart';

class ProfilCubit extends Cubit<ProfilState> {
  final ProfilRepository profilRepository;
  final StorageRepository storageRepository;
  final LocationService locationService;

  ProfilCubit({
    required this.profilRepository,
    required this.storageRepository,
    required this.locationService,
  }) : super(ProfilInitial());

  void getProfilUser(String uid) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .match(
          (failure) => ProfilError(failure),
          (option) => option.match(
            () => ProfilError(const NotFoundFailure('Profil not found')),
            (user) => ProfilLoaded(user),
          ),
        )
        .map(emit)
        .run();
  }

  void updateProfilImage({
    required String uid,
    required String imagePath,
    bool isAsset = false,
  }) {
    emit(ProfilImageUploading(
      uid: uid,
      imagePath: imagePath,
      profilUser: _currentProfilUser(),
    ));

    final uploadTask = isAsset
        ? storageRepository.uploadAssetImage(
            assetPath: imagePath,
            fileName: uid,
            folder: 'profile_images/avatar',
          )
        : storageRepository.uploadImageFromUrl(
            path: imagePath,
            fileName: uid,
            folder: 'profile_images',
          );

    uploadTask
        .flatMap((finalImageUrl) => profilRepository
            .updateProfilField(
              uid: uid,
              field: 'profilImg',
              value: finalImageUrl,
            )
            .flatMap((_) => profilRepository.getProfilUser(uid))
            .flatMap((option) => option.match(
                  () =>
                      TaskEither.left(const NotFoundFailure('Profil not found')),
                  (user) => TaskEither.right(user),
                )))
        .match(
          (failure) => ProfilError(failure),
          (user) => ProfilLoaded(user),
        )
        .map(emit)
        .run();
  }

  Option<ProfilUser> _currentProfilUser() => switch (state) {
        ProfilLoaded(:final profilUser) => Some(profilUser),
        ProfilImageUploading(:final profilUser) => profilUser,
        ProfilInitial() || ProfilLoading() || ProfilError() => const None(),
      };

  void deleteImageProfile(String imageUrl) {
    final currentState = state;
    if (currentState is! ProfilLoaded) {
      emit(ProfilError(
        const UnexpectedFailure('Delete image while profil not loaded'),
      ));
      return;
    }

    final currentUser = currentState.profilUser;
    final isStorageUrl =
        imageUrl.startsWith('http') || imageUrl.startsWith('gs://');

    final TaskEither<Failure, String> deleteStorageTask = isStorageUrl
        ? storageRepository.deleteImage(imageUrl: imageUrl)
        : TaskEither.right(imageUrl);

    deleteStorageTask
        .flatMap((_) {
          final updatedProfilUser = currentUser.copyWith(newProfilImg: const Some(''));
          return profilRepository
              .updateProfilUser(updatedProfilUser)
              .map((_) => updatedProfilUser);
        })
        .match(
          (failure) => ProfilError(failure),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  TaskEither<Failure, Unit> saveProfilUser(ProfilUser profilUser) {
    final previous = state;
    emit(ProfilLoading());

    return profilRepository
        .getProfilUser(profilUser.uid)
        .flatMap((existing) => existing
            .match(
              () => profilRepository.createProfilUser(profilUser),
              (_) => profilRepository.updateProfilUser(profilUser),
            )
            .flatMap((_) => _applyReferral(
                  profilUser,
                  existing.flatMap((user) => user.referredBy),
                )))
        .flatMap(
            (gained) => _loadUser(profilUser.uid).map((user) => (user, gained)))
        .map((result) {
          emit(ProfilLoaded(
            result.$1,
            leavesGained: result.$2,
            rewardMessage: Option.fromPredicate(
              t.levelAwarded.rewards.referral,
              (_) => result.$2 > 0,
            ),
          ));
          return unit;
        })
        .mapLeft((failure) {
          emit(previous);
          return failure;
        });
  }

  TaskEither<Failure, int> _applyReferral(
    ProfilUser user,
    Option<String> alreadyReferredBy,
  ) =>
      alreadyReferredBy.isSome()
          ? TaskEither.right(0)
          : user.referredBy
              .map((code) => code.trim().toUpperCase())
              .filter((code) => code.isNotEmpty && code != user.referralCode)
              .match(
                () => TaskEither.right(0),
                profilRepository.applyReferral,
              );

  TaskEither<Failure, ProfilUser> _loadUser(String uid) =>
      profilRepository.getProfilUser(uid).flatMap((option) => option.match(
            () => TaskEither.left(const NotFoundFailure('Profil not found')),
            TaskEither.right,
          ));

  void clearField({
    required String uid,
    required String fieldName,
  }) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .flatMap((option) => option.match(
              () => TaskEither.left(const NotFoundFailure('Profil not found')),
              (currentUser) {
                Option<T> cleared<T>(String field, T empty) =>
                    fieldName == field ? Some(empty) : const None();
                final updatedProfilUser = currentUser.copyWith(
                  newUserName: cleared('userName', const None()),
                  newBio: cleared('bio', const None()),
                  newLocalisation: cleared('localisation', ''),
                  newCountry: cleared('country', ''),
                  newZipCode: cleared('zipCode', ''),
                  newLatitude: cleared('latitude', const None()),
                  newLongitude: cleared('longitude', const None()),
                  newBirthdayDate: cleared('birthdayDate', const None()),
                );

                return profilRepository
                    .updateProfilUser(updatedProfilUser)
                    .map((_) => updatedProfilUser);
              },
            ))
        .match(
          (failure) => ProfilError(failure),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  void clearLocation(String uid) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .flatMap((option) => option.match(
              () => TaskEither.left(const NotFoundFailure('Profil not found')),
              (currentUser) {
                final updatedProfilUser = currentUser.copyWith(
                  newLocalisation: const Some(''),
                  newCountry: const Some(''),
                  newZipCode: const Some(''),
                  newLatitude: const Some(None()),
                  newLongitude: const Some(None()),
                );

                return profilRepository
                    .updateProfilUser(updatedProfilUser)
                    .map((_) => updatedProfilUser);
              },
            ))
        .match(
          (failure) => ProfilError(failure),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  TaskEither<Failure, ProfilUser> updateLocation(String uid) {
    final previous = state;
    emit(ProfilLoading());

    return locationService
        .getCurrentPosition()
        .flatMap((position) => locationService
            .getPlacemarkFromPosition(position)
            .map<Option<Placemark>>(Some.new)
            .alt(() => TaskEither.right(const None()))
            .map((placemark) => (position, placemark)))
        .flatMap<ProfilUser>((data) {
          final position = data.$1;
          final placemark = data.$2;
          return profilRepository.getProfilUser(uid).flatMap((option) =>
              option.match(
                () => TaskEither.left(const NotFoundFailure('Profil not found')),
                (user) {
                  final updatedUser = user.copyWith(
                    newLocalisation: Some(placemark
                        .map((p) => Option.fromNullable(p.locality).getOrElse(() => ''))
                        .getOrElse(() => user.localisation)),
                    newCountry: Some(placemark
                        .map((p) => Option.fromNullable(p.country).getOrElse(() => ''))
                        .getOrElse(() => user.country)),
                    newZipCode: Some(placemark
                        .map((p) => Option.fromNullable(p.postalCode).getOrElse(() => ''))
                        .getOrElse(() => user.zipCode)),
                    newLatitude: Some(Some(position.latitude)),
                    newLongitude: Some(Some(position.longitude)),
                  );
                  return profilRepository
                      .updateProfilUser(updatedUser)
                      .map((_) => updatedUser);
                },
              ));
        })
        .map((user) {
          emit(ProfilLoaded(user));
          return user;
        })
        .mapLeft((failure) {
          emit(previous);
          return failure;
        });
  }

  void reset() => emit(ProfilInitial());

  void refreshLeaves(String uid) {
    _loadUser(uid)
        .match(
          (failure) => ProfilError(failure),
          (user) => ProfilLoaded(user),
        )
        .map(emit)
        .run();
  }
}
