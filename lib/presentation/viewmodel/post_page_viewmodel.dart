import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/picture_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/usecase/pick_image_usecase.dart';
import 'package:green_heart/application/usecase/pick_multiple_image_usecase.dart';
import 'package:green_heart/application/usecase/post_upload_usecase.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/my_post_notifier.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';
import 'package:green_heart/domain/type/profile.dart';

class PostPageViewModel {
  final PickImageUsecase _pickImageUsecase;
  final PickMultipleImageUsecase _pickMultipleImageUsecase;
  final PostUploadUsecase _postUploadUsecase;
  final MyPostNotifier postNotifier;
  final User? _user;

  PostPageViewModel(
    this._pickImageUsecase,
    this._pickMultipleImageUsecase,
    this._postUploadUsecase,
    this.postNotifier,
    this._user,
  );

  Future<void> pickImages(ValueNotifier<List<String>> selectedImages) async {
    if (selectedImages.value.length >= 4) {
      return;
    }

    final int remainingSlots = 4 - selectedImages.value.length;
    if (remainingSlots > 1) {
      final List<String> images = await _pickMultipleImageUsecase.execute();
      selectedImages.value = [...selectedImages.value, ...images];
    } else {
      final String? image = await _pickImageUsecase.execute();
      if (image != null) {
        selectedImages.value = [...selectedImages.value, image];
      }
    }
  }

  Future<void> uploadPost(String content,
      ValueNotifier<List<String>> selectedImages, Profile? profile) async {
    if (_user == null) {
      throw Exception('投稿ができません。アカウントがログアウトされている可能性があります。');
    }

    final post = await _postUploadUsecase.execute(
      _user.uid,
      content,
      selectedImages.value,
    );

    final postWithProfile = PostWithProfile(post: post, profile: profile!);
    postNotifier.addPost(postWithProfile);
  }
}

final postPageViewModel = Provider((ref) => PostPageViewModel(
      ref.read(pickImageUsecaseProvider),
      ref.read(pickMultipleImageUsecaseProvider),
      ref.read(postUploadUsecaseProvider),
      ref.read(myPostNotifierProvider.notifier),
      ref.watch(authStateProvider).value!,
    ));
