import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class User {
  final ProfilUser user;
  final Map<String, List<Catalog>> userCatalogs;
  final int level;
  final CatalogFilter selectedFilter;

  const User({
    required this.user,
    required this.userCatalogs,
    required this.level,
    this.selectedFilter = CatalogFilter.all,
  });

  User copyWith({
    ProfilUser? user,
    Map<String, List<Catalog>>? userCatalogs,
    int? level,
    CatalogFilter? selectedFilter,
  }) {
    return User(
      user: user ?? this.user,
      userCatalogs: userCatalogs ?? this.userCatalogs,
      level: level ?? this.level,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
