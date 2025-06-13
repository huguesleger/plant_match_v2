import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

sealed class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Catalog> catalogs;

  const CatalogLoaded(this.catalogs);
}

class CatalogError extends CatalogState {
  final String message;

  CatalogError(this.message);
}
