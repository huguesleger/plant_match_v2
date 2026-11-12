import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/task_either_minimal_delay/task_either_minimal_delay.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogCubit extends SafeCubit<CatalogState> {
  final CatalogRepository catalogRepository;
  final StorageRepository storageRepository;

  CatalogCubit({
    required this.catalogRepository,
    required this.storageRepository,
  }) : super(const CatalogInitial());

  void emitLoaded(List<Catalog> catalogs, Catalog catalog) {
    emit(CatalogLoaded(catalogs, catalog, sortOption: _currentSortFromState()));
  }

  CatalogSortOption _currentSortFromState() {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      return currentState.sortOption;
    }
    return CatalogSortOption.newest;
  }

  void changeSortOption(CatalogSortOption sortOption) async {
    final currentState = state;
    if (currentState is CatalogLoaded) {
      emit(CatalogLoaded(
        currentState.catalogs,
        currentState.catalog,
        sortOption: sortOption,
      ));
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('catalog_sort_option', sortOption.name);
  }

  void getCatalogsByUserId(String userId) async {
    emit(const CatalogLoading());

    final prefs = await SharedPreferences.getInstance();
    final sortName = prefs.getString('catalog_sort_option');
    final sortOption = CatalogSortOption.values.firstWhere(
      (e) => e.name == sortName,
      orElse: () => CatalogSortOption.newest,
    );

    catalogRepository
        .getCatalogsByUserId(userId)
        .match<CatalogState>(
          (failure) => CatalogError(failure),
          (catalogs) => CatalogLoaded(catalogs, Catalog.empty(userId),
              sortOption: sortOption),
        )
        .map(emit)
        .run();
  }

  Future<void> refresh(String userId) => catalogRepository
      .getCatalogsByUserId(userId)
      .match<CatalogState>(
        (failure) => switch (state) {
          CatalogLoaded() => state,
          CatalogInitial() ||
          CatalogLoading() ||
          CatalogError() =>
            CatalogError(failure),
        },
        (catalogs) => CatalogLoaded(
          catalogs,
          Catalog.empty(userId),
          sortOption: _currentSortFromState(),
        ),
      )
      .map(emit)
      .run();

  TaskEither<Failure, String> publishNewCatalog(
    Catalog catalog, {
    Duration minDuration = Duration.zero,
  }) {
    final previous = state;
    emit(const CatalogLoading());

    return _withTimeout(_publishNewCatalog(catalog))
        .withMinimalDelay(minDuration)
        .mapLeft((failure) {
      emit(previous);
      return failure;
    });
  }

  TaskEither<Failure, String> _publishNewCatalog(Catalog catalog) {
    final id = catalogRepository.reserveCatalogId();

    return TaskEither.sequenceList(
      catalog.images
          .filter((image) => !_isRemote(image))
          .toList()
          .indexed
          .map(
            (entry) => storageRepository.uploadImageFromUrl(
              path: entry.$2,
              fileName: _uniqueFileName(id, entry.$1, entry.$2),
              folder: 'catalog_images',
            ),
          )
          .toList(),
    )
        .flatMap(
          (uploaded) => catalogRepository
              .createCatalog(
                catalog.copyWith(
                  newCatalogId: Some(Some(id)),
                  newImages:
                      Some([...catalog.images.filter(_isRemote), ...uploaded]),
                ),
              )
              .orElse(
                (failure) => TaskEither<Failure, String>.fromTask(
                  _discardImages(uploaded).map((_) => id),
                ).flatMap((_) => TaskEither.left(failure)),
              ),
        )
        .map((_) => id);
  }

  static const Duration _saveTimeout = Duration(seconds: 90);

  static TaskEither<Failure, T> _withTimeout<T>(TaskEither<Failure, T> task) =>
      TaskEither(
        () => task.run().timeout(
              _saveTimeout,
              onTimeout: () =>
                  const Left(NetworkFailure('Catalog save timeout')),
            ),
      );

  static bool _isRemote(String image) => image.startsWith('http');

  static String _uniqueFileName(String id, int index, String path) {
    final extension = path.contains('.') ? path.split('.').last : 'jpg';
    return '${id}_${DateTime.now().microsecondsSinceEpoch}_$index.$extension';
  }

  Task<Unit> _discardImages(List<String> urls) => TaskEither.sequenceList(
        urls
            .map((url) => storageRepository.deleteImage(imageUrl: url))
            .toList(),
      ).match((_) => unit, (_) => unit);

  void updateCatalog(Catalog catalog) {
    emit(const CatalogLoading());

    catalogRepository
        .updateCatalog(catalog)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
        .match(
          (failure) => CatalogError(failure),
          (catalogs) => CatalogLoaded(catalogs, catalog,
              sortOption: _currentSortFromState()),
        )
        .map(emit)
        .run();
  }

  void editCatalog(Catalog catalog) {
    emit(const CatalogLoading());

    catalogRepository
        .updateCatalog(catalog)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
        .match(
          (failure) => CatalogError(failure),
          (catalogs) => CatalogLoaded(catalogs, catalog,
              sortOption: _currentSortFromState()),
        )
        .map(emit)
        .run();
  }

  TaskEither<Failure, Catalog> saveEditedCatalog({
    required Catalog original,
    required Catalog edited,
    Duration minDuration = Duration.zero,
  }) {
    final previous = state;
    emit(const CatalogLoading());

    return _withTimeout(_saveEditedCatalog(original: original, edited: edited))
        .withMinimalDelay(minDuration)
        .mapLeft((failure) {
      emit(previous);
      return failure;
    });
  }

  TaskEither<Failure, Catalog> _saveEditedCatalog({
    required Catalog original,
    required Catalog edited,
  }) {
    final id = edited.catalogId.getOrElse(() => '');

    return TaskEither.sequenceList(
      edited.images
          .filter((image) => !_isRemote(image))
          .toList()
          .indexed
          .map(
            (entry) => storageRepository.uploadImageFromUrl(
              path: entry.$2,
              fileName: _uniqueFileName(id, entry.$1, entry.$2),
              folder: 'catalog_images',
            ),
          )
          .toList(),
    )
        .flatMap((uploaded) {
          final saved = edited.copyWith(
            newImages: Some([...edited.images.filter(_isRemote), ...uploaded]),
          );
          return catalogRepository
              .updateCatalog(saved)
              .map((_) => saved)
              .orElse(
                (failure) => TaskEither<Failure, Catalog>.fromTask(
                  _discardImages(uploaded).map((_) => saved),
                ).flatMap((_) => TaskEither.left(failure)),
              );
        })
        .flatMap(
          (saved) => TaskEither<Failure, Catalog>.fromTask(
            _discardImages(
              original.images
                  .filter(_isRemote)
                  .filter((image) => !saved.images.contains(image))
                  .toList(),
            ).map((_) => saved),
          ),
        );
  }

  Task<List<Catalog>> _refreshCatalogs(String userId) =>
      catalogRepository.getCatalogsByUserId(userId).getOrElse((_) => const []);

  TaskEither<Failure, Catalog> deleteImageCatalog({
    required Catalog catalog,
    required String imageUrl,
  }) {
    emit(const CatalogLoading());

    return storageRepository.deleteImage(imageUrl: imageUrl).flatMap((_) {
      final updatedImages =
          catalog.images.where((img) => img != imageUrl).toList();
      final updatedCatalog = catalog.copyWith(newImages: Some(updatedImages));

      return catalogRepository
          .updateCatalog(updatedCatalog)
          .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
          .flatMap((catalogs) {
        return TaskEither<Failure, Catalog>.tryCatch(
          () async {
            emit(CatalogLoaded(catalogs, updatedCatalog,
                sortOption: _currentSortFromState()));
            return updatedCatalog;
          },
          (error, _) => mapError(error),
        );
      });
    });
  }

  TaskEither<Failure, Catalog> getCatalogById(String catalogId) {
    emit(const CatalogLoading());

    return catalogRepository.getCatalogById(catalogId).flatMap((option) =>
        option.match(
          () => TaskEither.left(const NotFoundFailure('Catalog not found')),
          (catalog) {
            return TaskEither<Failure, Catalog>.tryCatch(
              () async {
                emit(CatalogLoaded([catalog], catalog,
                    sortOption: _currentSortFromState()));
                return catalog;
              },
              (error, _) => mapError(error),
            );
          },
        ));
  }

  TaskEither<Failure, Unit> deleteCatalog(Catalog catalog) {
    final previous = state;
    final sortOption = _currentSortFromState();
    emit(const CatalogLoading());

    return catalog.catalogId
        .match(
          () => TaskEither<Failure, Unit>.left(
            const UnexpectedFailure('catalogId is required to delete a catalog'),
          ),
          catalogRepository.deleteCatalog,
        )
        .flatMap(
          (_) => TaskEither<Failure, Unit>.fromTask(
            _discardImages(catalog.images.filter(_isRemote).toList())
                .flatMap((_) => _refreshCatalogs(catalog.userId))
                .map((catalogs) {
              emit(CatalogLoaded(catalogs, Catalog.empty(catalog.userId),
                  sortOption: sortOption));
              return unit;
            }),
          ),
        )
        .mapLeft((failure) {
      emit(previous);
      return failure;
    });
  }
}
