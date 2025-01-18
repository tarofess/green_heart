import 'package:green_heart/application/interface/picture_service.dart';
import 'package:green_heart/domain/type/result.dart';

class TakePhotoUsecase {
  final PictureService _pictureService;

  TakePhotoUsecase(this._pictureService);

  Future<Result<String?>> execute() async {
    try {
      final path = await _pictureService.takePhoto();
      return Success(path);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
