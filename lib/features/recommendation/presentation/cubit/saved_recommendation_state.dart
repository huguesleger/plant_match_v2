import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';

sealed class SavedRecommendationState {
  const SavedRecommendationState();

  T match<T>({
    required T Function(SavedRecommendationInitial state) initial,
    required T Function(SavedRecommendationLoading state) loading,
    required T Function(SavedRecommendationLoaded state) loaded,
    required T Function(SavedRecommendationError state) error,
  }) {
    return switch (this) {
      SavedRecommendationInitial s => initial(s),
      SavedRecommendationLoading s => loading(s),
      SavedRecommendationLoaded s => loaded(s),
      SavedRecommendationError s => error(s),
    };
  }
}

class SavedRecommendationInitial extends SavedRecommendationState {
  const SavedRecommendationInitial();
}

class SavedRecommendationLoading extends SavedRecommendationState {
  const SavedRecommendationLoading();
}

class SavedRecommendationLoaded extends SavedRecommendationState {
  final Option<RecommendationAnswers> answers;
  final List<Catalog> suggestedPlants;

  const SavedRecommendationLoaded({
    required this.answers,
    required this.suggestedPlants,
  });
}

class SavedRecommendationError extends SavedRecommendationState {
  final String message;

  const SavedRecommendationError({required this.message});
}
