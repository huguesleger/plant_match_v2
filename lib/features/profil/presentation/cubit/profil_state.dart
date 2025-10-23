import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class ProfilState {
  const ProfilState();
}

class ProfilInitial extends ProfilState {}

class ProfilLoading extends ProfilState {}

class ProfilLoaded extends ProfilState {
  final ProfilUser profilUser;

  ProfilLoaded(this.profilUser);
}

class ProfilError extends ProfilState {
  final String message;

  ProfilError(this.message);
}

class ProfilImageUploading extends ProfilState {
  final String uid;
  final String imagePath;

  ProfilImageUploading({required this.uid, required this.imagePath});
}
