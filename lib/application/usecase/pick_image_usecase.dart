import 'package:green_heart/application/interface/picture_service.dart';

class PickImageUsecase {
  final PictureService _pictureService;

  PickImageUsecase(this._pictureService);

  Future<String?> execute() async {
    try {
      return await _pictureService.pickImageFromGallery();
    } catch (e) {
      throw Exception('写真の選択に失敗しました。');
    }
  }
}
