import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class ProfilState {
  const ProfilState();
}

class ProfilInitial extends ProfilState {
  final ProfilUser boneMock = ProfilUser.boneMock();
}

class ProfilLoading extends ProfilState {
  final ProfilUser boneMock = ProfilUser.boneMock();
}

class ProfilLoaded extends ProfilState {
  final ProfilUser profilUser;
  final int leavesGained;
  final Option<String> rewardMessage;

  ProfilLoaded(
    this.profilUser, {
    this.leavesGained = 0,
    this.rewardMessage = const None(),
  });
}

class ProfilError extends ProfilState {
  final Failure failure;

  ProfilError(this.failure);
}

class ProfilImageUploading extends ProfilState {
  final String uid;
  final String imagePath;
  final ProfilUser boneMock = ProfilUser.boneMock();

  ProfilImageUploading({required this.uid, required this.imagePath});
}
