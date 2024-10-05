abstract class PictureRepository {
  Future<String?> takePhoto();
  Future<String?> pickImageFromGallery();
}
