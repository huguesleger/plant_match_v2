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

  const AroundMeLoaded({
    required this.users,
    required this.currentUser,
    required this.userCatalogs,
  });
}

class AroundMeError extends AroundMeState {
  final String message;

  const AroundMeError(this.message);
}
