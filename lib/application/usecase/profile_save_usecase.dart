import 'dart:async';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileSaveUsecase {
  final ProfileRepository _profileRepository;

  ProfileSaveUsecase(this._profileRepository);

  Future<Profile> execute(
    String uid,
    Profile profile,
    String imagePath,
    String? oldImageUrl,
  ) async {
    final firebaseStorePath = await processImage(
      uid,
      profile,
      imagePath,
      oldImageUrl,
    );

    profile = profile.copyWith(imageUrl: firebaseStorePath);
    await _profileRepository.saveProfile(uid, profile);
    return profile;
  }

  Future<String?> processImage(
    String uid,
    Profile profile,
    String imagePath,
    String? oldImageUrl,
  ) async {
    String? firebaseStorePath;
    if (isImageChanged(imagePath, oldImageUrl)) {
      firebaseStorePath = await _profileRepository.uploadImage(uid, imagePath);
      await deleteOldProfileImage(oldImageUrl);
    } else if (isImageDeleted(imagePath, oldImageUrl)) {
      firebaseStorePath = '';
      await deleteOldProfileImage(oldImageUrl);
    } else {
      firebaseStorePath = oldImageUrl;
    }
    return firebaseStorePath;
  }

  Future<void> deleteOldProfileImage(String? oldImageUrl) async {
    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      await _profileRepository.deleteImage(oldImageUrl);
    }
  }

  bool isImageChanged(String imagePath, String? oldImageUrl) {
    return imagePath.isNotEmpty && imagePath != oldImageUrl;
  }

  bool isImageDeleted(String imagePath, String? oldImageUrl) {
    return imagePath.isEmpty && imagePath != oldImageUrl;
  }
}
