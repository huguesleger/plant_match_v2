import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/user_points/domain/repository/user_points_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  final CatalogRepository catalogRepository;
  final UserPointsRepository userPointsRepository;

  UserCubit({
    required this.userRepository,
    required this.catalogRepository,
    required this.userPointsRepository,
  }) : super(UserInitial());

  Future<void> fetchUser(String uid) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getUserUid(uid);
      final userCatalogs = <String, List<Catalog>>{};
      final catalogs = await catalogRepository.getCatalogsByUserId(user.uid);
      final userPoints = await userPointsRepository.getPoints(user.uid);
      final level = userPoints.level;
      userCatalogs[user.uid] = catalogs;
      emit(UserLoaded(user: user, userCatalogs: userCatalogs, level: level));
    } catch (e) {
      emit(UserError('Erreur lors du chargement de l\'utilisateur : $e'));
    }
  }
}
