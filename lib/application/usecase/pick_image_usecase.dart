import 'package:green_heart/application/interface/picture_repository.dart';

class PickImageUsecase {
  final PictureRepository _pictureRepository;

  PickImageUsecase(this._pictureRepository);

  Future<String?> execute() async {
    try {
      return await _pictureRepository.pickImageFromGallery();
    } catch (e) {
      throw Exception('写真の選択に失敗しました。');
    }
  }
}
