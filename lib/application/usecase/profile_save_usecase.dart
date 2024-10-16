import 'dart:async';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileSaveUsecase {
  final ProfileRepository _profileRepository;

  ProfileSaveUsecase(this._profileRepository);

  Future<void> execute(String uid, Profile profile, String? path) async {
    String? firebaseStorePath;
    if (path != null) {
      firebaseStorePath = await _profileRepository.uploadImage(uid, path);
      profile = profile.copyWith(imageUrl: firebaseStorePath);
    }
    try {
      await _profileRepository.saveProfile(uid, profile);
    } catch (e) {
      if (firebaseStorePath != null) {
        await _rollbackUploadImage(firebaseStorePath);
      }
      rethrow;
    }
  }

  Future<void> _rollbackUploadImage(String firebaseStorePath) async {
    await _profileRepository.deleteImage(firebaseStorePath);
  }
}
