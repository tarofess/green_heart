import 'dart:async';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';

class ProfileSaveUsecase {
  final ProfileRepository _profileRepository;

  ProfileSaveUsecase(this._profileRepository);

  Future<Profile> execute(
    String uid,
    String name,
    String birthday,
    String bio,
    String? imagePath,
    String? oldImageUrl,
  ) async {
    final firebaseStorePath = await processImage(uid, imagePath, oldImageUrl);

    final profile = Profile(
      uid: uid,
      name: name,
      birthday: DateUtil.convertToDateTime(birthday),
      bio: bio,
      imageUrl: firebaseStorePath,
      updatedAt: DateTime.now(),
    );

    final savedProfile = await _profileRepository.saveProfile(profile);
    return savedProfile;
  }

  Future<String?> processImage(
    String uid,
    String? imagePath,
    String? oldImageUrl,
  ) async {
    String? firebaseStorePath;
    if (isImageChanged(imagePath, oldImageUrl)) {
      firebaseStorePath = await _profileRepository.uploadImage(uid, imagePath);
      await deleteOldProfileImage(oldImageUrl);
    } else if (isImageDeleted(imagePath, oldImageUrl)) {
      firebaseStorePath = null;
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

  bool isImageChanged(String? imagePath, String? oldImageUrl) {
    return imagePath != null && imagePath != oldImageUrl;
  }

  bool isImageDeleted(String? imagePath, String? oldImageUrl) {
    return imagePath == null && imagePath != oldImageUrl;
  }
}
