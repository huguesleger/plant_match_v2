import 'package:flutter_bloc/flutter_bloc.dart';
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

  // ─── getProfilUser ─────────────────────────────────────────────────────────

  void getProfilUser(String uid) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .match(
          (failure) => ProfilError(failure.message),
          (option) => option.match(
            () => ProfilError('Profil introuvable'),
            (user) => ProfilLoaded(user),
          ),
        )
        .map(emit)
        .run();
  }

  // ─── updateProfilUser ───────────────────────────────────────────────────────

  void updateProfilUser({
    required String uid,
    String? newBio,
    String? imageUrl,
    String? newUserName,
    String? newLocalisation,
    String? newZipCode,
    String? newCountry,
    DateTime? newBirthdayDate,
    double? newLatitude,
    double? newLongitude,
  }) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .flatMap((option) => option.match(
              () => TaskEither.left(const AuthFailure('Profil introuvable')),
              (currentUser) => imageUrl != null
                  ? storageRepository
                      .uploadImageFromUrl(
                        path: imageUrl,
                        fileName: uid,
                        folder: 'profile_images',
                      )
                      .map((imageDownloadUrl) => currentUser.copyWith(
                            newBio: Option.fromNullable(newBio),
                            newProfilImg: imageDownloadUrl,
                            newUserName: Option.fromNullable(newUserName),
                            newLocalisation:
                                newLocalisation ?? currentUser.localisation,
                            newCountry: newCountry ?? currentUser.country,
                            newZipCode: newZipCode ?? currentUser.zipCode,
                            newBirthdayDate:
                                Option.fromNullable(newBirthdayDate),
                            newLatitude: Option.fromNullable(newLatitude),
                            newLongitude: Option.fromNullable(newLongitude),
                          ))
                  : TaskEither.right(currentUser.copyWith(
                      newBio: Option.fromNullable(newBio),
                      newUserName: Option.fromNullable(newUserName),
                      newLocalisation:
                          newLocalisation ?? currentUser.localisation,
                      newCountry: newCountry ?? currentUser.country,
                      newZipCode: newZipCode ?? currentUser.zipCode,
                      newBirthdayDate: Option.fromNullable(newBirthdayDate),
                      newLatitude: Option.fromNullable(newLatitude),
                      newLongitude: Option.fromNullable(newLongitude),
                    )),
            ))
        .flatMap((updatedUser) => profilRepository
            .updateProfilUser(updatedUser)
            .map((_) => updatedUser))
        .match(
          (failure) => ProfilError(failure.message),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  // ─── updateProfilImage ─────────────────────────────────────────────────────

  void updateProfilImage({
    required String uid,
    required String imagePath,
    bool isAsset = false,
  }) {
    emit(ProfilImageUploading(uid: uid, imagePath: imagePath));

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
                      TaskEither.left(const AuthFailure('Profil introuvable')),
                  (user) => TaskEither.right(user),
                )))
        .match(
          (failure) => ProfilError(failure.message),
          (user) => ProfilLoaded(user),
        )
        .map(emit)
        .run();
  }

  // ─── deleteImageProfile ────────────────────────────────────────────────────

  void deleteImageProfile(String imageUrl) {
    final currentState = state;
    if (currentState is! ProfilLoaded) {
      emit(ProfilError('Impossible de supprimer l\'image, profil non chargé.'));
      return;
    }

    final currentUser = currentState.profilUser;
    final isStorageUrl = imageUrl.startsWith('http') || imageUrl.startsWith('gs://');

    final TaskEither<Failure, String> deleteStorageTask = isStorageUrl
        ? storageRepository.deleteImage(imageUrl: imageUrl)
        : TaskEither.right(imageUrl);

    deleteStorageTask
        .flatMap((_) {
          final updatedProfilUser = currentUser.copyWith(newProfilImg: '');
          return profilRepository
              .updateProfilUser(updatedProfilUser)
              .map((_) => updatedProfilUser);
        })
        .match(
          (failure) => ProfilError(failure.message),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  // ─── saveProfilUser ────────────────────────────────────────────────────────

  void saveProfilUser(ProfilUser profilUser) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(profilUser.uid)
        .flatMap((option) => option.match(
              () => profilRepository.createProfilUser(profilUser),
              (existing) => profilRepository.updateProfilUser(profilUser),
            ))
        .match(
          (failure) => ProfilError(failure.message),
          (_) => ProfilLoaded(profilUser),
        )
        .map(emit)
        .run();
  }

  // ─── clearField ────────────────────────────────────────────────────────────

  void clearField({
    required String uid,
    required String fieldName,
  }) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .flatMap((option) => option.match(
              () => TaskEither.left(const AuthFailure('Profil introuvable')),
              (currentUser) {
                final updatedProfilUser = currentUser.copyWith(
                  newUserName: fieldName == 'userName' ? const None() : null,
                  newBio: fieldName == 'bio' ? const None() : null,
                  newLocalisation: fieldName == 'localisation' ? '' : null,
                  newCountry: fieldName == 'country' ? '' : null,
                  newZipCode: fieldName == 'zipCode' ? '' : null,
                  newLatitude: fieldName == 'latitude' ? const None() : null,
                  newLongitude: fieldName == 'longitude' ? const None() : null,
                  newBirthdayDate:
                      fieldName == 'birthdayDate' ? const None() : null,
                );

                return profilRepository
                    .updateProfilUser(updatedProfilUser)
                    .map((_) => updatedProfilUser);
              },
            ))
        .match(
          (failure) => ProfilError(failure.message),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  // ─── clearLocation ──────────────────────────────────────────────────────────

  void clearLocation(String uid) {
    emit(ProfilLoading());

    profilRepository
        .getProfilUser(uid)
        .flatMap((option) => option.match(
              () => TaskEither.left(const AuthFailure('Profil introuvable')),
              (currentUser) {
                final updatedProfilUser = currentUser.copyWith(
                  newLocalisation: '',
                  newCountry: '',
                  newZipCode: '',
                  newLatitude: const None(),
                  newLongitude: const None(),
                );

                return profilRepository
                    .updateProfilUser(updatedProfilUser)
                    .map((_) => updatedProfilUser);
              },
            ))
        .match(
          (failure) => ProfilError(failure.message),
          (updatedUser) => ProfilLoaded(updatedUser),
        )
        .map(emit)
        .run();
  }

  // ─── updateLocation ────────────────────────────────────────────────────────

  void updateLocation(String uid) {
    emit(ProfilLoading());

    locationService
        .getCurrentPosition()
        .flatMap((position) => locationService
            .getPlacemarkFromPosition(position)
            .map((placemark) => (position, placemark)))
        .flatMap((data) {
          final position = data.$1;
          final placemark = data.$2;
          return profilRepository.getProfilUser(uid).flatMap((option) =>
              option.match(
                () => TaskEither.left(const AuthFailure('Profil introuvable')),
                (user) {
                  final updatedUser = user.copyWith(
                    newLocalisation: placemark.locality ?? '',
                    newCountry: placemark.country ?? '',
                    newZipCode: placemark.postalCode ?? '',
                    newLatitude: Some(position.latitude),
                    newLongitude: Some(position.longitude),
                  );
                  return profilRepository
                      .updateProfilUser(updatedUser)
                      .map((_) => updatedUser);
                },
              ));
        })
        .match(
          (failure) => ProfilError(failure.message),
          (user) => ProfilLoaded(user),
        )
        .map(emit)
        .run();
  }
}
