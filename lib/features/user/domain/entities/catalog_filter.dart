import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

enum CatalogFilter {
  all(LucideIcons.list),
  donation(LucideIcons.gift),
  exchange(LucideIcons.heart_handshake),
  outdoor(LucideIcons.trees),
  indoor(LucideIcons.house);

  final IconData icon;

  const CatalogFilter(this.icon);
}

extension CatalogFilterExtension on CatalogFilter {
  String get label => switch (this) {
        CatalogFilter.all => t.user.filters.all,
        CatalogFilter.donation => t.user.filters.donation,
        CatalogFilter.exchange => t.user.filters.exchange,
        CatalogFilter.outdoor => t.user.filters.outdoor,
        CatalogFilter.indoor => t.user.filters.indoor,
      };

  bool accepts(Catalog catalog) => switch (this) {
        CatalogFilter.all => true,
        CatalogFilter.donation => catalog.offerType == OfferType.donation,
        CatalogFilter.exchange => catalog.offerType == OfferType.exchange,
        CatalogFilter.outdoor => catalog.environment == Environment.outdoor,
        CatalogFilter.indoor => catalog.environment == Environment.indoor,
      };
}
