import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  TaskEither<Failure, String> uploadImageFromUrl({
    required String path,
    required String fileName,
    required String folder,
  }) {
    return _uploadImage(path: path, fileName: fileName, folder: folder);
  }

  @override
  TaskEither<Failure, String> uploadAssetImage({
    required String assetPath,
    required String fileName,
    required String folder,
  }) {
    return TaskEither.tryCatch(
      () async {
        final byteData = await rootBundle.load(assetPath);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/${assetPath.split('/').last}');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        return _uploadImage(
          path: file.path,
          fileName: fileName,
          folder: folder,
        ).run().then((result) => result.match(
              (failure) => throw Exception(failure.message),
              (url) => url,
            ));
      },
      (error, _) => UnexpectedFailure('Erreur upload asset image: $error'),
    );
  }

  TaskEither<Failure, String> _uploadImage(
      {required String path,
      required String fileName,
      required String folder}) {
    return TaskEither.tryCatch(
      () async {
        final file = File(path);
        final ref = _firebaseStorage.ref().child('$folder/$fileName');
        final uploadTask = await ref.putFile(file);
        final imageUrl = await uploadTask.ref.getDownloadURL();
        return imageUrl;
      },
      (error, _) => UnexpectedFailure('Erreur upload image: $error'),
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
      (error, _) => UnexpectedFailure('Erreur suppression image: $error'),
    );
  }
}
