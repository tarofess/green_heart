import 'package:green_heart/application/interface/picture_service.dart';

class PickImageUsecase {
  final PictureService _pictureService;

  PickImageUsecase(this._pictureService);

  Future<String?> execute() async {
    return await _pictureService.pickImageFromGallery();
  }
}
