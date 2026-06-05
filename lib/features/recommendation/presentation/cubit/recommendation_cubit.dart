import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/repositories/recommendation_repository.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_state.dart';

class RecommendationCubit extends SafeCubit<RecommendationState> {
  final RecommendationRepository _repository;
  final String _userId;

  RecommendationCubit({
    required RecommendationRepository repository,
    required String userId,
  })  : _repository = repository,
        _userId = userId,
        super(const RecommendationInitial());

  void startQuestionnaire() {
    emit(RecommendationQuestionStep(
      stepIndex: 0,
      answers: RecommendationAnswers.empty(),
    ));
  }

  void selectEnvironment(EnvironmentType type) {
    state.match(
      initial: (_) {},
      step: (stepState) {
        emit(RecommendationQuestionStep(
          stepIndex: stepState.stepIndex,
          answers: stepState.answers.copyWith(environment: some(type)),
        ));
      },
      loading: (_) {},
      result: (_) {},
      error: (_) {},
    );
  }

  void selectLight(LightType type) {
    state.match(
      initial: (_) {},
      step: (stepState) {
        emit(RecommendationQuestionStep(
          stepIndex: stepState.stepIndex,
          answers: stepState.answers.copyWith(light: some(type)),
        ));
      },
      loading: (_) {},
      result: (_) {},
      error: (_) {},
    );
  }

  void selectCareLevel(CareLevelType type) {
    state.match(
      initial: (_) {},
      step: (stepState) {
        emit(RecommendationQuestionStep(
          stepIndex: stepState.stepIndex,
          answers: stepState.answers.copyWith(careLevel: some(type)),
        ));
      },
      loading: (_) {},
      result: (_) {},
      error: (_) {},
    );
  }

  void selectPetSafety(PetSafetyType type) {
    state.match(
      initial: (_) {},
      step: (stepState) {
        emit(RecommendationQuestionStep(
          stepIndex: stepState.stepIndex,
          answers: stepState.answers.copyWith(petSafety: some(type)),
        ));
      },
      loading: (_) {},
      result: (_) {},
      error: (_) {},
    );
  }

  void nextStep() {
    state.match(
      initial: (_) {},
      step: (stepState) {
        if (stepState.stepIndex < 3) {
          emit(RecommendationQuestionStep(
            stepIndex: stepState.stepIndex + 1,
            answers: stepState.answers,
          ));
        } else {
          _submitAnswers(stepState.answers);
        }
      },
      loading: (_) {},
      result: (_) {},
      error: (_) {},
    );
  }

  void previousStep() {
    state.match(
      initial: (_) {},
      step: (stepState) {
        if (stepState.stepIndex > 0) {
          emit(RecommendationQuestionStep(
            stepIndex: stepState.stepIndex - 1,
            answers: stepState.answers,
          ));
        }
      },
      loading: (_) {},
      result: (_) {},
      error: (_) {},
    );
  }

  void _submitAnswers(RecommendationAnswers answers) {
    emit(const RecommendationLoading());
    _repository
        .saveAnswers(_userId, answers)
        .flatMap((_) => _repository.getRecommendedPlants(answers))
        .match(
          (failure) => emit(RecommendationError(message: failure.message)),
          (plants) => emit(RecommendationResult(suggestedPlants: plants)),
        )
        .run();
  }

  void reset() {
    startQuestionnaire();
  }
}
