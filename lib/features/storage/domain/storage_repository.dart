import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/storage/domain/storage_cache_policy.dart';

abstract class StorageRepository {
  TaskEither<Failure, String> uploadImageFromUrl({
    required String path,
    required String fileName,
    required String folder,
    StorageCachePolicy cachePolicy = const DefaultStorageCache(),
  });

  TaskEither<Failure, String> uploadAssetImage(
      {required String assetPath,
      required String fileName,
      required String folder});

  TaskEither<Failure, String> deleteImage({required String imageUrl});
}
