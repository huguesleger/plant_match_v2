import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class AroundMeState {
  const AroundMeState();
}

class AroundMeInitial extends AroundMeState {
  const AroundMeInitial();
}

class AroundMeLoading extends AroundMeState {
  const AroundMeLoading();
}

class AroundMeLoaded extends AroundMeState {
  final List<ProfilUser> users;
  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;
  final bool locating;
  final Option<String> locationError;

  const AroundMeLoaded({
    required this.users,
    required this.currentUser,
    required this.userCatalogs,
    this.locating = false,
    this.locationError = const None(),
  });

  AroundMeLoaded copyWith({
    Option<bool> locating = const None(),
    Option<Option<String>> locationError = const None(),
  }) =>
      AroundMeLoaded(
        users: users,
        currentUser: currentUser,
        userCatalogs: userCatalogs,
        locating: locating.getOrElse(() => this.locating),
        locationError: locationError.getOrElse(() => this.locationError),
      );
}

class AroundMeError extends AroundMeState {
  final String message;

  const AroundMeError(this.message);
}
