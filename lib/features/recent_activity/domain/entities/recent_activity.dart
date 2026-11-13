import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class RecentActivity {
  final Catalog catalog;
  final ProfilUser owner;

  const RecentActivity({required this.catalog, required this.owner});

  factory RecentActivity.boneMock() => RecentActivity(
        catalog: Catalog.boneMock(),
        owner: ProfilUser.boneMock(),
      );

  static List<RecentActivity> boneMocks() =>
      List.generate(6, (_) => RecentActivity.boneMock());

  static List<RecentActivity> fromAroundMe({
    required ProfilUser currentUser,
    required List<ProfilUser> users,
    required Map<String, List<Catalog>> userCatalogs,
  }) =>
      userCatalogs.entries
          .where((entry) => entry.key != currentUser.uid)
          .expand(
            (entry) =>
                users.where((user) => user.uid == entry.key).firstOption.match(
                      () => const <RecentActivity>[],
                      (owner) => entry.value
                          .where((catalog) =>
                              catalog.status == CatalogStatus.published)
                          .map((catalog) =>
                              RecentActivity(catalog: catalog, owner: owner)),
                    ),
          )
          .toList()
        ..sort((a, b) => b.catalog.createdAt.compareTo(a.catalog.createdAt));
}
