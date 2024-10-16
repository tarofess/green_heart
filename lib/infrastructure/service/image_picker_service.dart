import 'package:image_picker/image_picker.dart';

import 'package:green_heart/application/interface/picture_service.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class ImagePickerService implements PictureService {
  @override
  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 80,
      );
      return photo?.path;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('写真の撮影に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 80,
      );
      return image?.path;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('写真の選択に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<String>> pickMultipleImagesFromGallery() async {
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 80,
        limit: 4,
      );
      return images.map((image) => image.path).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('写真の選択に失敗しました。再度お試しください。');
    }
  }
}
