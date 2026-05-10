import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';

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
}
