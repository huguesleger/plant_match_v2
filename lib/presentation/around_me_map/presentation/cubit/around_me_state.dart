import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

sealed class AroundMeState {}

class AroundMeInitial extends AroundMeState {}

class AroundMeLoading extends AroundMeState {}

class AroundMeLoaded extends AroundMeState {
  final List<ProfilUser> users;
  final ProfilUser currentUser;

  AroundMeLoaded({required this.users, required this.currentUser});
}

class AroundMeError extends AroundMeState {
  final String message;

  AroundMeError(this.message);
}
