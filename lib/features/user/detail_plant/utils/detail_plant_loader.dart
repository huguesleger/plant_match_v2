import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';

class DetailPlantData {
  final Catalog catalog;
  final ProfilUser owner;
  final Option<ProfilUser> currentUser;

  const DetailPlantData({
    required this.catalog,
    required this.owner,
    required this.currentUser,
  });
}

class DetailPlantLoader {
  static Task<Option<DetailPlantData>> load({
    required Catalog catalog,
    required Option<ProfilUser> owner,
    required String currentUserId,
  }) =>
      Task(() async {
        await _incrementViews(catalog, currentUserId).run();
        final (resolvedCatalog, resolvedOwner, currentUser) = await (
          _resolveCatalog(catalog).run(),
          _resolveOwner(catalog.userId, owner).run(),
          _fetchUser(currentUserId).run(),
        ).wait;
        return resolvedOwner.map(
          (found) => DetailPlantData(
            catalog: resolvedCatalog,
            owner: found,
            currentUser: currentUser,
          ),
        );
      });

  static Option<String> _catalogId(Catalog catalog) =>
      catalog.catalogId.filter((id) => id.isNotEmpty);

  static Task<Unit> _incrementViews(Catalog catalog, String currentUserId) =>
      _catalogId(catalog)
          .filter(
            (_) => currentUserId.isNotEmpty && currentUserId != catalog.userId,
          )
          .match(
            () => Task.of(unit),
            (id) => FirebaseCatalogRepository()
                .incrementCatalogViews(id)
                .match((_) => unit, (_) => unit),
          );

  static Task<Catalog> _resolveCatalog(Catalog catalog) =>
      _catalogId(catalog).match(
        () => Task.of(catalog),
        (id) => FirebaseCatalogRepository().getCatalogById(id).match(
              (_) => catalog,
              (found) => found.getOrElse(() => catalog),
            ),
      );

  static Task<Option<ProfilUser>> _resolveOwner(
    String ownerId,
    Option<ProfilUser> owner,
  ) =>
      owner.match<Task<Option<ProfilUser>>>(
        () => _fetchUser(ownerId),
        (found) => Task.of(Some(found)),
      );

  static Task<Option<ProfilUser>> _fetchUser(String uid) => uid.isEmpty
      ? Task.of(const None())
      : FirebaseUser().getUserUid(uid).match<Option<ProfilUser>>(
            (_) => const None(),
            (user) => Some(user),
          );
}
