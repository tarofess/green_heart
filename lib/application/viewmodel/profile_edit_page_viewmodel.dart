import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/usecase/profile_image_upload_usecase.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/application/usecase/string_save_shared_pref_usecase.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/di/shared_pref_di.dart';
import 'package:green_heart/application/state/profile_notifier_provider.dart';

class ProfileEditPageViewModel {
  final ProfileImageUploadUsecase _profileImageUploadUsecase;
  final ProfileSaveUsecase _profileSaveUsecase;
  final StringSaveSharedPrefUsecase _stringSaveSharedPrefUsecase;
  final ProfileNotifier _profileNotifier;
  final User? _user;

  ProfileEditPageViewModel(
    this._profileImageUploadUsecase,
    this._profileSaveUsecase,
    this._stringSaveSharedPrefUsecase,
    this._profileNotifier,
    this._user,
  );

  Future<void> saveProfile(
    ValueNotifier<String> imagePath,
    TextEditingController nameTextController,
    TextEditingController birthdayTextController,
    TextEditingController bioTextController,
  ) async {
    String firebaseStorePath = '';
    if (imagePath.value != '') {
      firebaseStorePath =
          await _profileImageUploadUsecase.execute(imagePath.value);
    }

    final profile = Profile(
      name: nameTextController.text,
      birthDate: DateTime.parse(
        DateUtil.convertToYYYYMMDD(birthdayTextController.text),
      ),
      bio: bioTextController.text,
      imageUrl: firebaseStorePath,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final uid = _user?.uid;
    if (uid == null) {
      throw Exception('ユーザーIDが取得できませんでした。'
          '再度お試しください。');
    }

    await _profileSaveUsecase.execute(uid, profile);
    await _stringSaveSharedPrefUsecase.execute('uid', uid);
    _profileNotifier.setProfile(profile);
  }
}

final profileEditPageViewModelProvider = Provider(
  (ref) => ProfileEditPageViewModel(
    ref.read(profileImageUploadUsecaseProvider),
    ref.read(profileSaveUsecaseProvider),
    ref.read(stringSaveSharedPrefUsecaseProvider),
    ref.read(profileNotifierProvider.notifier),
    ref.read(authStateProvider).value,
  ),
);
