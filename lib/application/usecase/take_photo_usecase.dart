import 'package:green_heart/application/interface/picture_service.dart';

class TakePhotoUsecase {
  final PictureService _pictureService;

  TakePhotoUsecase(this._pictureService);

  Future<String?> execute() async {
    return await _pictureService.takePhoto();
  }
}
