import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileSaveUsecase {
  final ProfileRepository _repository;
  final Profile profile;

  ProfileSaveUsecase(this._repository, this.profile);

  Future<void> execute() async {
    try {
      await _repository.saveProfile(profile);
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }
}
