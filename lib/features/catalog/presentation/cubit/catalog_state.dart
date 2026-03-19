import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

sealed class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogLoaded extends CatalogState {
  final List<Catalog> catalogs;
  final Catalog catalog;

  const CatalogLoaded(this.catalogs, this.catalog);
}

class CatalogError extends CatalogState {
  final String message;

  const CatalogError(this.message);
}
