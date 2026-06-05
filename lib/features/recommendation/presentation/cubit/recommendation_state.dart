import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';

sealed class RecommendationState {
  const RecommendationState();
}

class RecommendationInitial extends RecommendationState {
  const RecommendationInitial();
}

class RecommendationQuestionStep extends RecommendationState {
  final int stepIndex;
  final RecommendationAnswers answers;

  const RecommendationQuestionStep({
    required this.stepIndex,
    required this.answers,
  });
}

class RecommendationLoading extends RecommendationState {
  const RecommendationLoading();
}

class RecommendationResult extends RecommendationState {
  final List<Catalog> suggestedPlants;

  const RecommendationResult({
    required this.suggestedPlants,
  });
}

class RecommendationError extends RecommendationState {
  final String message;

  const RecommendationError({
    required this.message,
  });
}

extension RecommendationStateMatch on RecommendationState {
  T match<T>({
    required T Function(RecommendationInitial initial) initial,
    required T Function(RecommendationQuestionStep step) step,
    required T Function(RecommendationLoading loading) loading,
    required T Function(RecommendationResult result) result,
    required T Function(RecommendationError error) error,
  }) {
    final state = this;
    return switch (state) {
      RecommendationInitial() => initial(state),
      RecommendationQuestionStep() => step(state),
      RecommendationLoading() => loading(state),
      RecommendationResult() => result(state),
      RecommendationError() => error(state),
    };
  }
}
