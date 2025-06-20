import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

sealed class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Catalog> catalogs;
  final Catalog catalog;

  const CatalogLoaded(this.catalogs, this.catalog);
}

class CatalogError extends CatalogState {
  final String message;

  CatalogError(this.message);
}
