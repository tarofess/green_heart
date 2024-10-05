import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileSaveUsecase {
  final ProfileRepository _repository;

  ProfileSaveUsecase(this._repository);

  Future<void> execute(String uid, Profile profile) async {
    try {
      await _repository.saveProfile(uid, profile);
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }
}
