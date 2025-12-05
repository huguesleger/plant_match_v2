import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final ProfilUser user;
  final Map<String, List<Catalog>> userCatalogs;
  final int level;

  UserLoaded({
    required this.user,
    required this.userCatalogs,
    required this.level,
  });
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
