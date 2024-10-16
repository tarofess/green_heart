import 'package:green_heart/application/interface/picture_service.dart';

class PickMultipleImageUsecase {
  final PictureService _pictureService;

  PickMultipleImageUsecase(this._pictureService);

  Future<List<String>> execute() async {
    return await _pictureService.pickMultipleImagesFromGallery();
  }
}
