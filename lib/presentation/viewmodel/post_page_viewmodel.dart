import 'package:flutter/material.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/picture_di.dart';
import 'package:green_heart/application/usecase/pick_image_usecase.dart';
import 'package:green_heart/application/usecase/pick_multiple_image_usecase.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';

class PostPageViewModel {
  final PickImageUsecase _pickImageUsecase;
  final PickMultipleImageUsecase _pickMultipleImageUsecase;
  final UserPostNotifier postNotifier;

  PostPageViewModel(
    this._pickImageUsecase,
    this._pickMultipleImageUsecase,
    this.postNotifier,
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
}

final postPageViewModel = Provider((ref) => PostPageViewModel(
      ref.read(pickImageUsecaseProvider),
      ref.read(pickMultipleImageUsecaseProvider),
      ref.read(userPostNotifierProvider(ref.watch(authStateProvider).value?.uid)
          .notifier),
    ));
