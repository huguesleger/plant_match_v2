import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/domain/repository/profil_repository.dart';
import 'package:plant_match_v2/presentation/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/presentation/storage/domain/storage_repository.dart';

class ProfilCubit extends Cubit<ProfilState> {
  final ProfilRepository profilRepository;
  final StorageRepository storageRepository;

  ProfilCubit({
    required this.profilRepository,
    required this.storageRepository,
  }) : super(ProfilInitial());

  Future<void> getProfilUser(String uid) async {
    try {
      final profilUser = await profilRepository.getProfilUser(uid);

      if (profilUser != null) {
        emit(ProfilLoaded(profilUser));
      } else {
        emit(ProfilError('Profil introuvable'));
      }
    } catch (e) {
      emit(ProfilError(e.toString()));
    }
  }

  Future<void> updateProfilUser({
    required String uid,
    String? newBio,
    String? imageUrl,
    String? newUserName,
    String? newLocalisation,
    String? newCountry,
    DateTime? newBirthdayDate,
    double? newLatitude,
    double? newLongitude,
  }) async {
    emit(ProfilLoading());
    try {
      final currentUser = await profilRepository.getProfilUser(uid);

      if (currentUser == null) {
        emit(ProfilError('Profil introuvable'));
        return;
      }

      String? imageDownloadUrl = currentUser.profilImg;

      if (imageUrl != null) {
        imageDownloadUrl = await storageRepository.uploadImageFromUrl(
          path: imageUrl,
          fileName: uid,
          folder: 'profile_images',
        );
      }

      final updatedProfilUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfilImg: imageDownloadUrl,
        newUserName: newUserName ?? currentUser.userName,
        newLocalisation: newLocalisation ?? currentUser.localisation,
        newCountry: newCountry ?? currentUser.country,
        newBirthdayDate: newBirthdayDate ?? currentUser.birthdayDate,
        newLatitude: newLatitude ?? currentUser.latitude,
        newLongitude: newLongitude ?? currentUser.longitude,
      );

      await profilRepository.updateProfilUser(updatedProfilUser);
      emit(ProfilLoaded(updatedProfilUser));
    } catch (e) {
      emit(ProfilError(e.toString()));
    }
  }

  Future<void> updateProfilImage({
    required String uid,
    required String imagePath,
    bool isAsset = false,
  }) async {
    try {
      emit(ProfilImageUploading(uid: uid, imagePath: imagePath));

      String? finalImageUrl;

      if (isAsset) {
        finalImageUrl = await storageRepository.uploadAssetImage(
          assetPath: imagePath,
          fileName: uid,
          folder: 'profile_images/avatar',
        );
      } else {
        finalImageUrl = await storageRepository.uploadImageFromUrl(
          path: imagePath,
          fileName: uid,
          folder: 'profile_images',
        );
      }

      if (finalImageUrl == null) {
        emit(ProfilError("Erreur lors de l'upload de l'image"));
        return;
      }

      if (state is ProfilLoaded) {
        final currentUser = (state as ProfilLoaded).profilUser;
        emit(ProfilLoaded(currentUser.copyWith(newProfilImg: finalImageUrl)));
      }

      await profilRepository.updateProfilField(
        uid: uid,
        field: 'profilImg',
        value: finalImageUrl,
      );

      final updatedUserFromDb = await profilRepository.getProfilUser(uid);
      if (updatedUserFromDb != null) {
        emit(ProfilLoaded(updatedUserFromDb));
      }
    } catch (e) {
      emit(ProfilError('Erreur lors de la mise à jour de l\'image : $e'));
    }
  }

  Future<void> deleteImageProfile(String imageUrl) async {
    try {
      final currentState = state;

      if (currentState is ProfilLoaded) {
        await storageRepository.deleteImage(imageUrl: imageUrl);

        final updatedProfilUser = currentState.profilUser.copyWith(
          newProfilImg: '',
        );

        await profilRepository.updateProfilUser(updatedProfilUser);
        emit(ProfilLoaded(updatedProfilUser));
      } else {
        emit(ProfilError(
            'Impossible de supprimer l\'image, profil non chargé.'));
      }
    } catch (e) {
      emit(ProfilError('Erreur lors de la suppression de l\'image: $e'));
    }
  }

  Future<void> saveProfilUser(ProfilUser profilUser) async {
    emit(ProfilLoading());
    try {
      final existingUser = await profilRepository.getProfilUser(profilUser.uid);

      if (existingUser == null) {
        await profilRepository.createProfilUser(profilUser);
        emit(ProfilLoaded(profilUser));
      } else {
        await profilRepository.updateProfilUser(profilUser);
        emit(ProfilLoaded(profilUser));
      }
    } catch (e) {
      emit(ProfilError('Erreur lors de l\'enregistrement du profil : $e'));
    }
  }

  Future<void> clearField({
    required String uid,
    required String fieldName,
  }) async {
    emit(ProfilLoading());
    try {
      final currentUser = await profilRepository.getProfilUser(uid);

      if (currentUser == null) {
        emit(ProfilError('Profil introuvable'));
        return;
      }

      final updatedProfilUser = currentUser.copyWith(
        newUserName: fieldName == 'userName' ? '' : null,
        newBio: fieldName == 'bio' ? '' : null,
        newLocalisation: fieldName == 'localisation' ? '' : null,
        newCountry: fieldName == 'country' ? '' : null,
        newLatitude: fieldName == 'latitude' ? 0 : null,
        newLongitude: fieldName == 'longitude' ? 0 : null,
      );

      await profilRepository.updateProfilUser(updatedProfilUser);
      emit(ProfilLoaded(updatedProfilUser));
    } catch (e) {
      emit(ProfilError('Erreur lors de la réinitialisation du champ : $e'));
    }
  }
}
