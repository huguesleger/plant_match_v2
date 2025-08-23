import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_match_v2/presentation/storage/domain/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String?> uploadImageFromUrl({
    required String path,
    required String fileName,
    required String folder,
  }) {
    return _uploadImage(path: path, fileName: fileName, folder: folder);
  }

  @override
  Future<String?> uploadAssetImage({
    required String assetPath,
    required String fileName,
    required String folder,
  }) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${assetPath.split('/').last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      return await _uploadImage(
        path: file.path,
        fileName: fileName,
        folder: folder,
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> _uploadImage(
      {required String path,
      required String fileName,
      required String folder}) async {
    try {
      final file = File(path);
      final ref = _firebaseStorage.ref().child('$folder/$fileName');
      final uploadTask = await ref.putFile(file);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> deleteImage({required String imageUrl}) async {
    try {
      final ref = _firebaseStorage.refFromURL(imageUrl);
      await ref.delete();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}
