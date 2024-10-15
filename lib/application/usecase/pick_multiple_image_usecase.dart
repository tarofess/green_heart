import 'package:green_heart/application/interface/picture_service.dart';

class PickMultipleImageUsecase {
  final PictureService _pictureService;

  PickMultipleImageUsecase(this._pictureService);

  Future<List<String?>> execute() async {
    try {
      return await _pictureService.pickMultipleImagesFromGallery();
    } catch (e) {
      throw Exception('写真の選択に失敗しました。');
    }
  }
}
