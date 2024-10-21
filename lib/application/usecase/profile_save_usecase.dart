import 'dart:async';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileSaveUsecase {
  final ProfileRepository _profileRepository;

  ProfileSaveUsecase(this._profileRepository);

  Future<Profile> execute(
    String uid,
    Profile profile,
    String? imagePath,
    String? oldImageUrl,
  ) async {
    String? firebaseStorePath;
    if (isImageChanged(imagePath, oldImageUrl)) {
      firebaseStorePath = await _profileRepository.uploadImage(uid, imagePath!);
      profile = profile.copyWith(imageUrl: firebaseStorePath);
      await deleteOldProfileImageIfExists(oldImageUrl);
    } else {
      profile = profile.copyWith(imageUrl: oldImageUrl);
    }
    try {
      await _profileRepository.saveProfile(uid, profile);
    } catch (e) {
      if (firebaseStorePath != null) {
        await _rollbackUploadImage(firebaseStorePath);
      }
      rethrow;
    }

    return profile;
  }

  Future<void> deleteOldProfileImageIfExists(String? oldImageUrl) async {
    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      await _profileRepository.deleteImage(oldImageUrl);
    }
  }

  Future<void> _rollbackUploadImage(String firebaseStorePath) async {
    await _profileRepository.deleteImage(firebaseStorePath);
  }

  bool isImageChanged(String? imagePath, String? oldImageUrl) {
    return imagePath != null &&
        imagePath.isNotEmpty &&
        imagePath != oldImageUrl;
  }
}
