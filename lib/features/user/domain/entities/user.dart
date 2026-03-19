import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class User {
  final ProfilUser user;
  final Map<String, List<Catalog>> userCatalogs;
  final int level;
  final int exchangeCount;
  final CatalogFilter selectedFilter;

  const User({
    required this.user,
    required this.userCatalogs,
    required this.level,
    this.exchangeCount = 0,
    this.selectedFilter = CatalogFilter.all,
  });

  User copyWith({
    ProfilUser? user,
    Map<String, List<Catalog>>? userCatalogs,
    int? level,
    int? exchangeCount,
    CatalogFilter? selectedFilter,
  }) {
    return User(
      user: user ?? this.user,
      userCatalogs: userCatalogs ?? this.userCatalogs,
      level: level ?? this.level,
      exchangeCount: exchangeCount ?? this.exchangeCount,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
