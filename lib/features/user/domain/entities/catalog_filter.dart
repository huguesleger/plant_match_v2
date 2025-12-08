import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum CatalogFilter {
  all('Tous', LucideIcons.list),
  donation('Donations', LucideIcons.gift),
  exchange('Échanges', LucideIcons.heart_handshake),
  outdoor('Extérieur', LucideIcons.trees),
  indoor('Intérieur', LucideIcons.house);

  final String label;
  final IconData icon;

  const CatalogFilter(this.label, this.icon);
}
