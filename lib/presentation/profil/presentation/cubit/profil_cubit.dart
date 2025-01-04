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
  }) async {
    emit(ProfilLoading());
    try {
      final currentUser = await profilRepository.getProfilUser(uid);

      if (currentUser == null) {
        emit(ProfilError('Profil introuvable'));
        return;
      }

      String? imageDownloadUrl;

      if (imageUrl != null) {
        imageDownloadUrl = await storageRepository.uploadImageFromUrl(
            path: imageUrl, fileName: currentUser.uid);
      }

      if (imageUrl == null && imageDownloadUrl == null) {
        emit(ProfilError('Erreur lors de l\'upload de l\'image'));
        return;
      }

      final updatedProfilUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfilImg: imageDownloadUrl ?? currentUser.profilImg,
        newUserName: newUserName ?? currentUser.userName,
        newLocalisation: newLocalisation ?? currentUser.localisation,
        newCountry: newCountry ?? currentUser.country,
        newBirthdayDate: newBirthdayDate ?? currentUser.birthdayDate,
      );

      await profilRepository.updateProfilUser(updatedProfilUser);
      await getProfilUser(uid);
      emit(ProfilLoaded(updatedProfilUser));
    } catch (e) {
      emit(ProfilError(e.toString()));
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
}
