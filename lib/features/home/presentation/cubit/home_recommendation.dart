import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

sealed class HomeRecommendation {
  const HomeRecommendation();
}

class HomeRecommendationLoading extends HomeRecommendation {
  final List<Catalog> boneMocks = List.generate(3, (_) => Catalog.boneMock());

  HomeRecommendationLoading();
}

class HomeRecommendationMissing extends HomeRecommendation {
  const HomeRecommendationMissing();
}

class HomeRecommendationLoaded extends HomeRecommendation {
  final List<Catalog> plants;

  const HomeRecommendationLoaded(this.plants);
}

class HomeRecommendationError extends HomeRecommendation {
  final Failure failure;

  const HomeRecommendationError(this.failure);
}
