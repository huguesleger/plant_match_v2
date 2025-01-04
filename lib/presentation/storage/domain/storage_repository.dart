abstract class StorageRepository {
  Future<String?> uploadImageFromUrl(
      {required String path, required String fileName});

  Future<String?> deleteImage({required String imageUrl});
}
