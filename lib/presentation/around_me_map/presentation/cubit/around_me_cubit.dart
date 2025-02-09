import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/around_me_map/domain/entity/around_me.dart';
import 'package:plant_match_v2/presentation/around_me_map/domain/repository/around_me_repository.dart';
import 'package:plant_match_v2/presentation/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/presentation/profil/domain/repository/profil_repository.dart';

class AroundMeCubit extends Cubit<AroundMeState> {
  final AroundMeRepository aroundMeRepository;
  final ProfilRepository profilRepository;
  AroundMe? _currentPlace;

  AroundMeCubit(
      {required this.aroundMeRepository, required this.profilRepository})
      : super(AroundMeInitial());

  AroundMe? get currentPlace => _currentPlace;

  Future<void> fetchPlacesAroundMe(
      String uid, double latitude, double longitude) async {
    emit(AroundMeLoading());
    try {
      final places =
          await aroundMeRepository.getPlacesAroundMe(uid, latitude, longitude);
      final profilUser = await profilRepository.getProfilUser(uid);
      emit(AroundMeLoaded(places, profilUser!));
    } catch (e) {
      emit(AroundMeError('Erreur: $e'));
    }
  }

  Future<void> fetchAllUsers(String uid) async {
    emit(AroundMeLoading());
    try {
      final users = await aroundMeRepository.getAllUsers(uid);
      final profilUser = await profilRepository.getProfilUser(uid);
      emit(AroundMeLoaded(users, profilUser!));
    } catch (e) {
      emit(AroundMeError('Erreur: $e'));
    }
  }
}
