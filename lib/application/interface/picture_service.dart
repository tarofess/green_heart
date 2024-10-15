abstract class PictureService {
  Future<String?> takePhoto();
  Future<String?> pickImageFromGallery();
  Future<List<String>> pickMultipleImagesFromGallery();
}
