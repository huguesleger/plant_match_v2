import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/task_either_minimal_delay/task_either_minimal_delay.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/core/widgets/skeleton/skeleton_effect.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_recommendation.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_state.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/recommendation/domain/repositories/recommendation_repository.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class HomeCubit extends SafeCubit<HomeState> {
  final RecommendationRepository recommendationRepository;
  final String userId;

  HomeCubit({
    required this.recommendationRepository,
    required this.userId,
  }) : super(
          HomeLoading(
            filter: CatalogFilter.all,
            recommendation: HomeRecommendationLoading(),
            leaves: const None(),
          ),
        );

  void syncAroundMe(AroundMeState aroundMe) {
    final catalogsChanged = _loadedCatalogs(state).match(
      () => false,
      (previous) => switch (aroundMe) {
        AroundMeLoaded(:final userCatalogs) =>
          !identical(previous, userCatalogs),
        AroundMeInitial() || AroundMeLoading() || AroundMeError() => false,
      },
    );
    emit(_fromAroundMe(aroundMe));
    if (catalogsChanged) refreshRecommendations();
  }

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

  void loadRecommendations() {
    emit(state.copyWith(recommendation: Some(HomeRecommendationLoading())));
    _withRecommendation(
      _fetchRecommendation()
          .withMinimalDelay(SkeletonEffect.shimmerMinimumDelay),
    ).map(emit).run();
  }

  void refreshRecommendations() =>
      _withRecommendation(_fetchRecommendation()).map(emit).run();

  HomeState _fromAroundMe(AroundMeState aroundMe) => switch (aroundMe) {
        AroundMeInitial() || AroundMeLoading() => HomeLoading(
            filter: state.filter,
            recommendation: state.recommendation,
            leaves: state.leaves,
          ),
        AroundMeError(:final failure) => HomeError(
            failure: failure,
            filter: state.filter,
            recommendation: state.recommendation,
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
            recommendation: state.recommendation,
            leaves: state.leaves,
          ),
      };

  Option<Map<String, List<Catalog>>> _loadedCatalogs(HomeState current) =>
      switch (current) {
        HomeLoaded(:final home) => Some(home.userCatalogs),
        HomeLoading() || HomeError() => const None(),
      };

  Task<HomeState> _withRecommendation(
    TaskEither<Failure, HomeRecommendation> task,
  ) =>
      task
          .match<HomeRecommendation>(
            HomeRecommendationError.new,
            (recommendation) => recommendation,
          )
          .map((recommendation) =>
              state.copyWith(recommendation: Some(recommendation)));

  TaskEither<Failure, HomeRecommendation> _fetchRecommendation() =>
      recommendationRepository.getSavedAnswers(userId).flatMap(
            (answers) => answers.match(
              () => TaskEither.of(const HomeRecommendationMissing()),
              (saved) => recommendationRepository
                  .getRecommendedPlants(userId, saved)
                  .map(HomeRecommendationLoaded.new),
            ),
          );
}
