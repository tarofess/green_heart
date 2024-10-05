import 'package:green_heart/application/interface/picture_repository.dart';

class TakePhotoUsecase {
  final PictureRepository _pictureRepository;

  TakePhotoUsecase(this._pictureRepository);

  Future<String?> execute() async {
    try {
      return await _pictureRepository.takePhoto();
    } catch (e) {
      throw Exception('写真の撮影に失敗しました。');
    }
  }
}
