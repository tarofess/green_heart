import 'package:green_heart/application/interface/profile_repository.dart';

class ProfileImageUploadUsecase {
  final ProfileRepository _profileRepository;

  ProfileImageUploadUsecase(this._profileRepository);

  Future<String> execute(String path) async {
    try {
      return await _profileRepository.uploadImage(path);
    } catch (e) {
      throw Exception('画像のアップロードに失敗しました。');
    }
  }
}
