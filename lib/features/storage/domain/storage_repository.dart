abstract class StorageRepository {
  Future<String?> uploadImageFromUrl(
      {required String path, required String fileName, required String folder});

  Future<String?> uploadAssetImage(
      {required String assetPath,
      required String fileName,
      required String folder});

  Future<String?> deleteImage({required String imageUrl});
}
