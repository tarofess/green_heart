import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileDeleteUsecase {
  final ProfileRepository _profileRepository;

  ProfileDeleteUsecase(this._profileRepository);

  Future<void> execute(User user, Profile? profile) async {
    try {
      if (profile == null) {
        throw Exception('現在プロフィールを削除できません。のちほどお試しください。');
      }

      final deleteTasks = Future.wait([
        _profileRepository.deleteImage(profile.imageUrl),
        _profileRepository.deleteProfile(user.uid),
      ]);
      await deleteTasks;
    } catch (e) {
      throw AppException('プロフィールの削除に失敗しました。再度お試しください。');
    }
  }
}
