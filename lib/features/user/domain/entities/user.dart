import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class User {
  final ProfilUser user;
  final Map<String, List<Catalog>> userCatalogs;
  final int level;
  final Option<int> exchangeCount;
  final CatalogFilter selectedFilter;

  const User({
    required this.user,
    required this.userCatalogs,
    required this.level,
    this.exchangeCount = const None(),
    this.selectedFilter = CatalogFilter.all,
  });

  User copyWith({
    Option<ProfilUser> user = const None(),
    Option<Map<String, List<Catalog>>> userCatalogs = const None(),
    Option<int> level = const None(),
    Option<Option<int>> exchangeCount = const None(),
    Option<CatalogFilter> selectedFilter = const None(),
  }) {
    return User(
      user: user.getOrElse(() => this.user),
      userCatalogs: userCatalogs.getOrElse(() => this.userCatalogs),
      level: level.getOrElse(() => this.level),
      exchangeCount: exchangeCount.getOrElse(() => this.exchangeCount),
      selectedFilter: selectedFilter.getOrElse(() => this.selectedFilter),
    );
  }
}
