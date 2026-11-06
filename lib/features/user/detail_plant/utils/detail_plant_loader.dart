import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
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
  static TaskEither<Failure, DetailPlantData> load({
    required Catalog catalog,
    required Option<ProfilUser> owner,
    required String currentUserId,
  }) =>
      TaskEither(() async {
        final (resolvedCatalog, resolvedOwner, currentUser) = await (
          _resolveCatalog(catalog).run(),
          _resolveOwner(catalog.userId, owner).run(),
          _fetchUser(currentUserId).run(),
        ).wait;
        return resolvedCatalog.flatMap(
          (found) => resolvedOwner.map(
            (foundOwner) => DetailPlantData(
              catalog: found,
              owner: foundOwner,
              currentUser: currentUser,
            ),
          ),
        );
      });

  static Option<String> _catalogId(Catalog catalog) =>
      catalog.catalogId.filter((id) => id.isNotEmpty);

  static Task<Unit> incrementViews(Catalog catalog, String currentUserId) =>
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

  static TaskEither<Failure, Catalog> _resolveCatalog(Catalog catalog) =>
      _catalogId(catalog).match(
        () => TaskEither.right(catalog),
        (id) => FirebaseCatalogRepository().getCatalogById(id).flatMap(
              (found) => TaskEither.fromOption(
                found,
                () => const NotFoundFailure('Catalog not found'),
              ),
            ),
      );

  static TaskEither<Failure, ProfilUser> _resolveOwner(
    String ownerId,
    Option<ProfilUser> owner,
  ) =>
      owner.match(
        () => ownerId.isEmpty
            ? TaskEither.left(const NotFoundFailure('Owner not found'))
            : FirebaseUser().getUserUid(ownerId),
        TaskEither.right,
      );

  static Task<Option<ProfilUser>> _fetchUser(String uid) => uid.isEmpty
      ? Task.of(const None())
      : FirebaseUser().getUserUid(uid).match<Option<ProfilUser>>(
            (_) => const None(),
            (user) => Some(user),
          );
}
