import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/storage/domain/storage_cache_policy.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  TaskEither<Failure, String> uploadImageFromUrl({
    required String path,
    required String fileName,
    required String folder,
    StorageCachePolicy cachePolicy = const DefaultStorageCache(),
  }) {
    return _uploadImage(
      path: path,
      fileName: fileName,
      folder: folder,
      cachePolicy: cachePolicy,
    );
  }

  @override
  TaskEither<Failure, String> uploadAssetImage({
    required String assetPath,
    required String fileName,
    required String folder,
  }) {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final byteData = await rootBundle.load(assetPath);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/${assetPath.split('/').last}');
        await file.writeAsBytes(byteData.buffer.asUint8List());
        return file.path;
      },
      (error, _) => mapError(error),
    ).flatMap(
      (filePath) => _uploadImage(
        path: filePath,
        fileName: fileName,
        folder: folder,
      ),
    );
  }

  static const _immutableCacheControl = 'public, max-age=31536000, immutable';

  TaskEither<Failure, String> _uploadImage({
    required String path,
    required String fileName,
    required String folder,
    StorageCachePolicy cachePolicy = const DefaultStorageCache(),
  }) {
    final Option<SettableMetadata> metadata = switch (cachePolicy) {
      ImmutableStorageCache() =>
        Some(SettableMetadata(cacheControl: _immutableCacheControl)),
      DefaultStorageCache() => const None(),
    };

    return TaskEither.tryCatch(
      () async {
        final file = File(path);
        final ref = _firebaseStorage.ref().child('$folder/$fileName');
        final uploadTask = await ref.putFile(file, metadata.toNullable());
        final imageUrl = await uploadTask.ref.getDownloadURL();
        return imageUrl;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, String> deleteImage({required String imageUrl}) {
    return TaskEither.tryCatch(
      () async {
        final ref = _firebaseStorage.refFromURL(imageUrl);
        await ref.delete();
        return imageUrl;
      },
      (error, _) => mapError(error),
    );
  }
}
