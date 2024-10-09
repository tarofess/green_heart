import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/profile_notifier_provider.dart';
import 'package:green_heart/application/di/shared_preferences_provider.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/profile_provider.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';

class ProfileEditPageViewModel {
  Future<void> saveProfile(
    WidgetRef ref,
    ValueNotifier<String> imagePath,
    TextEditingController nameTextController,
    TextEditingController birthdayTextController,
    TextEditingController bioTextController,
  ) async {
    String firebaseStorePath = '';
    if (imagePath.value != '') {
      firebaseStorePath = await ref
          .read(profileImageUploadUsecaseProvider)
          .execute(imagePath.value);
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

    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーIDが取得できませんでした。'
          '再度お試しください。');
    }

    await ref.read(profileSaveUsecaseProvider).execute(uid, profile);
    await ref.read(sharedPreferencesServiceProvider).saveUid(uid);
    ref.read(profileNotifierProvider.notifier).setProfile(profile);
  }
}
