import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_recommendation.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

sealed class HomeState {
  final CatalogFilter filter;
  final HomeRecommendation recommendation;
  final Option<int> leaves;

  const HomeState({
    required this.filter,
    required this.recommendation,
    required this.leaves,
  });

  HomeState copyWith({
    Option<CatalogFilter> filter = const None(),
    Option<HomeRecommendation> recommendation = const None(),
    Option<int> leaves = const None(),
  });
}

class HomeLoading extends HomeState {
  final Home boneMock = Home.boneMock();

  HomeLoading({
    required super.filter,
    required super.recommendation,
    required super.leaves,
  });

  @override
  HomeLoading copyWith({
    Option<CatalogFilter> filter = const None(),
    Option<HomeRecommendation> recommendation = const None(),
    Option<int> leaves = const None(),
  }) =>
      HomeLoading(
        filter: filter.getOrElse(() => this.filter),
        recommendation: recommendation.getOrElse(() => this.recommendation),
        leaves: leaves.alt(() => this.leaves),
      );
}

class HomeLoaded extends HomeState {
  final Home home;

  const HomeLoaded({
    required this.home,
    required super.filter,
    required super.recommendation,
    required super.leaves,
  });

  @override
  HomeLoaded copyWith({
    Option<CatalogFilter> filter = const None(),
    Option<HomeRecommendation> recommendation = const None(),
    Option<int> leaves = const None(),
  }) =>
      HomeLoaded(
        home: filter.match(() => home, home.withFilter),
        filter: filter.getOrElse(() => this.filter),
        recommendation: recommendation.getOrElse(() => this.recommendation),
        leaves: leaves.alt(() => this.leaves),
      );
}

class HomeError extends HomeState {
  final Failure failure;

  const HomeError({
    required this.failure,
    required super.filter,
    required super.recommendation,
    required super.leaves,
  });

  @override
  HomeError copyWith({
    Option<CatalogFilter> filter = const None(),
    Option<HomeRecommendation> recommendation = const None(),
    Option<int> leaves = const None(),
  }) =>
      HomeError(
        failure: failure,
        filter: filter.getOrElse(() => this.filter),
        recommendation: recommendation.getOrElse(() => this.recommendation),
        leaves: leaves.alt(() => this.leaves),
      );
}
