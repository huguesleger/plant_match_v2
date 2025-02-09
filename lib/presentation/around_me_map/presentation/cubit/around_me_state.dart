import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

import '../../domain/entity/around_me.dart';

sealed class AroundMeState {}

class AroundMeInitial extends AroundMeState {}

class AroundMeLoading extends AroundMeState {}

class AroundMeLoaded extends AroundMeState {
  final List<AroundMe> users;
  final ProfilUser profilUser;

  AroundMeLoaded(this.users, this.profilUser);
}

class AroundMeError extends AroundMeState {
  final String message;

  AroundMeError(this.message);
}
