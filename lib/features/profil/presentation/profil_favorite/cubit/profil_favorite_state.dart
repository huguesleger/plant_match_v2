import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class ProfilFavoriteState {
  const ProfilFavoriteState();
}

class ProfilFavoriteInitial extends ProfilFavoriteState {}

class ProfilFavoriteLoading extends ProfilFavoriteState {}

class ProfilFavoriteLoaded extends ProfilFavoriteState {
  final List<Map<String, dynamic>> plants;
  final List<ProfilUser> users;

  const ProfilFavoriteLoaded({
    required this.plants,
    required this.users,
  });
}

class ProfilFavoriteError extends ProfilFavoriteState {
  final String message;

  const ProfilFavoriteError(this.message);
}
