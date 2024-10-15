import 'package:image_picker/image_picker.dart';

import 'package:green_heart/application/interface/picture_service.dart';

class ImagePickerService implements PictureService {
  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 80,
    );
    return photo?.path;
  }

  @override
  Future<String?> pickImageFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 80,
    );
    return image?.path;
  }

  @override
  Future<List<String>> pickMultipleImagesFromGallery() async {
    final List<XFile> images = await ImagePicker().pickMultiImage(
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 80,
      limit: 4,
    );
    return images.map((image) => image.path).toList();
  }
}
