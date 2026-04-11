import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class FavoriteState {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> plants;
  final List<ProfilUser> users;

  const FavoriteLoaded({
    required this.plants,
    required this.users,
  });
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);
}
