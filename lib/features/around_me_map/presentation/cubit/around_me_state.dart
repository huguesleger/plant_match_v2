import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class AroundMeState {}

class AroundMeInitial extends AroundMeState {}

class AroundMeLoading extends AroundMeState {}

class AroundMeLoaded extends AroundMeState {
  final List<ProfilUser> users;
  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;

  AroundMeLoaded(
      {required this.users,
      required this.currentUser,
      required this.userCatalogs});
}

class AroundMeError extends AroundMeState {
  final String message;

  AroundMeError(this.message);
}
