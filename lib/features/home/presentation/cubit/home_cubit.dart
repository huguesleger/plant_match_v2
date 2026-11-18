import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_state.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class HomeCubit extends SafeCubit<HomeState> {
  HomeCubit()
      : super(
          HomeLoading(
            filter: CatalogFilter.all,
            leaves: const None(),
          ),
        );

  void syncAroundMe(AroundMeState aroundMe) => emit(_fromAroundMe(aroundMe));

  void syncProfil(ProfilState profil) => emit(switch (profil) {
        ProfilLoaded(:final profilUser) =>
          state.copyWith(leaves: Some(profilUser.leaves)),
        ProfilInitial() ||
        ProfilLoading() ||
        ProfilError() ||
        ProfilImageUploading() =>
          state,
      });

  void selectFilter(CatalogFilter filter) =>
      emit(state.copyWith(filter: Some(filter)));

  HomeState _fromAroundMe(AroundMeState aroundMe) => switch (aroundMe) {
        AroundMeInitial() || AroundMeLoading() => HomeLoading(
            filter: state.filter,
            leaves: state.leaves,
          ),
        AroundMeError(:final failure) => HomeError(
            failure: failure,
            filter: state.filter,
            leaves: state.leaves,
          ),
        AroundMeLoaded(:final currentUser, :final users, :final userCatalogs) =>
          HomeLoaded(
            home: Home.fromAroundMe(
              currentUser: currentUser,
              users: users,
              userCatalogs: userCatalogs,
              filter: state.filter,
            ),
            filter: state.filter,
            leaves: state.leaves,
          ),
      };
}
