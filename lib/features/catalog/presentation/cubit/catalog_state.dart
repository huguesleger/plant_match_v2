import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';

sealed class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  final List<Catalog> boneMocks = List.generate(4, (_) => Catalog.boneMock());

  CatalogLoading();
}

class CatalogLoaded extends CatalogState {
  final List<Catalog> catalogs;
  final Catalog catalog;
  final CatalogSortOption sortOption;

  const CatalogLoaded(
    this.catalogs,
    this.catalog, {
    this.sortOption = CatalogSortOption.newest,
  });
}

class CatalogError extends CatalogState {
  final Failure failure;

  const CatalogError(this.failure);
}
