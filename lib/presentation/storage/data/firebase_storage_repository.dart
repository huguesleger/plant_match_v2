import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:plant_match_v2/presentation/storage/domain/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String?> uploadImageFromUrl(
      {required String path, required String fileName}) {
    return _uploadImage(
        path: path, fileName: fileName, folder: "profile_images");
  }

  Future<String?> _uploadImage(
      {required String path, required String fileName, required folder}) async {
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
