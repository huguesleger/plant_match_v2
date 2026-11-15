import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class PublishQuota {
  static const int maxIdenticalPlants = 5;
  static const Duration window = Duration(hours: 48);

  static bool isReached({
    required List<Catalog> owned,
    required String name,
    required DateTime now,
  }) =>
      owned
          .where(
            (catalog) =>
                _normalize(catalog.name) == _normalize(name) &&
                now.difference(catalog.createdAt) < window,
          )
          .length >=
      maxIdenticalPlants;

  static String _normalize(String name) =>
      name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
