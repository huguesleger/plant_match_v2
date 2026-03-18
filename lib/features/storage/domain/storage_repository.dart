import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

abstract class StorageRepository {
  TaskEither<Failure, String> uploadImageFromUrl(
      {required String path, required String fileName, required String folder});

  TaskEither<Failure, String> uploadAssetImage(
      {required String assetPath,
      required String fileName,
      required String folder});

  TaskEither<Failure, String> deleteImage({required String imageUrl});
}
