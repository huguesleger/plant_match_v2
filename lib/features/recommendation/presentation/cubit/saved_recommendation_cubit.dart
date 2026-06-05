import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/repositories/recommendation_repository.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/saved_recommendation_state.dart';

class SavedRecommendationCubit extends SafeCubit<SavedRecommendationState> {
  final RecommendationRepository _repository;

  SavedRecommendationCubit({
    required RecommendationRepository repository,
  })  : _repository = repository,
        super(const SavedRecommendationInitial());

  void loadSavedRecommendations(String userId) {
    emit(const SavedRecommendationLoading());

    _repository
        .getSavedAnswers(userId)
        .flatMap((optAnswers) => optAnswers.match(
              () => TaskEither.of(
                (const Option<RecommendationAnswers>.none(), const <Catalog>[]),
              ),
              (answers) => _repository
                  .getRecommendedPlants(answers)
                  .map((plants) => (some(answers), plants)),
            ))
        .match(
          (failure) => SavedRecommendationError(message: failure.message),
          (tuple) => SavedRecommendationLoaded(
            answers: tuple.$1,
            suggestedPlants: tuple.$2,
          ),
        )
        .map(emit)
        .run();
  }

  void updateRecommendationAnswers(
    String userId,
    RecommendationAnswers answers,
  ) {
    emit(const SavedRecommendationLoading());

    _repository
        .saveAnswers(userId, answers)
        .flatMap((_) => _repository.getRecommendedPlants(answers))
        .match(
          (failure) => SavedRecommendationError(message: failure.message),
          (plants) => SavedRecommendationLoaded(
            answers: some(answers),
            suggestedPlants: plants,
          ),
        )
        .map(emit)
        .run();
  }
}
