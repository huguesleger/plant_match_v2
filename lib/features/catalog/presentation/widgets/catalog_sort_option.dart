import 'package:plant_match_v2/core/i18n/translations.g.dart';

enum CatalogSortOption {
  newest,
  nameAsc,
  nameDesc,
}

extension CatalogSortOptionExtension on CatalogSortOption {
  String get label => switch (this) {
        CatalogSortOption.newest => t.catalog.sort.newest,
        CatalogSortOption.nameAsc => t.catalog.sort.nameAsc,
        CatalogSortOption.nameDesc => t.catalog.sort.nameDesc,
      };
}
