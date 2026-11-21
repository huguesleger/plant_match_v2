import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class FamilyExplorerState {
  final Family family;
  final CatalogFilter filter;

  const FamilyExplorerState({required this.family, required this.filter});

  FamilyExplorerState copyWith({
    Option<CatalogFilter> filter = const None(),
  }) =>
      FamilyExplorerState(
        family: family,
        filter: filter.getOrElse(() => this.filter),
      );
}
