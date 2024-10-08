import 'package:green_heart/application/interface/picture_repository.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerRepository implements PictureRepository {
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
}