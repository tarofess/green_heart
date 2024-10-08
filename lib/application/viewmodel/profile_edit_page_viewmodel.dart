import 'package:flutter/material.dart';
import 'package:green_heart/application/state/profile_provider.dart';
import 'package:green_heart/application/state/shared_preferences_provider.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/presentation/router/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditPageViewModel {
  Future<void> saveProfile(
    WidgetRef ref,
    ValueNotifier<String> imagePath,
    TextEditingController nameTextController,
    TextEditingController birthYearTextController,
    TextEditingController birthMonthTextController,
    TextEditingController birthDayTextController,
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
      birthDate: DateTime(
        int.parse(birthYearTextController.text),
        int.parse(birthMonthTextController.text),
        int.parse(birthDayTextController.text),
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