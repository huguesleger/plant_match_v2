import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class FamilyOverview {
  final Family family;
  final int count;

  const FamilyOverview({required this.family, required this.count});

  bool get isEmpty => count == 0;

  static List<FamilyOverview> fromPlants(List<Catalog> plants) => Family.values
      .map((family) => FamilyOverview(
            family: family,
            count:
                plants.where((plant) => plant.family.contains(family)).length,
          ))
      .toList()
    ..sort((a, b) => a.count != b.count
        ? b.count.compareTo(a.count)
        : a.family.index.compareTo(b.family.index));

  static List<FamilyOverview> boneMocks() => Family.values
      .take(4)
      .map((family) => FamilyOverview(family: family, count: 12))
      .toList();
}
