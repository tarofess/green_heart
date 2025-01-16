import 'dart:async';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/util/date_util.dart';

class ProfileSaveUsecase {
  final ProfileRepository _profileRepository;
  final ProfileNotifier _profileNotifier;
  final UserPostNotifier _userPostNotifier;

  ProfileSaveUsecase(
    this._profileRepository,
    this._profileNotifier,
    this._userPostNotifier,
  );

  Future<Result> execute(
    String? uid,
    String name,
    String birthday,
    String bio,
    String? imagePath,
    String? oldImageUrl,
  ) async {
    try {
      if (uid == null) {
        return const Failure('プロフィールが保存できません。アカウントがログアウトされている可能性があります。');
      }

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
      _profileNotifier.saveProfile(savedProfile);
      _userPostNotifier.updateProfile(uid, name, savedProfile.imageUrl);

      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
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
