import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class FavoriteState {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  final List<Catalog> plantBoneMocks =
      List.generate(4, (_) => Catalog.boneMock());
  final List<ProfilUser> userBoneMocks =
      List.generate(4, (_) => ProfilUser.boneMock());

  FavoriteLoading();
}

class FavoriteLoaded extends FavoriteState {
  final List<Catalog> plants;
  final List<ProfilUser> users;

  const FavoriteLoaded({
    required this.plants,
    required this.users,
  });
}

class FavoriteError extends FavoriteState {
  final Failure failure;

  const FavoriteError(this.failure);
}
