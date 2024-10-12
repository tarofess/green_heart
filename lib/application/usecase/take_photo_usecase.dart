import 'package:green_heart/application/interface/picture_service.dart';

class TakePhotoUsecase {
  final PictureService _pictureService;

  TakePhotoUsecase(this._pictureService);

  Future<String?> execute() async {
    try {
      return await _pictureService.takePhoto();
    } catch (e) {
      throw Exception('写真の撮影に失敗しました。');
    }
  }
}
