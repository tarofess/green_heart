import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/picture_di.dart';

class PostPageViewModel {
  Future<void> pickImages(
      WidgetRef ref, ValueNotifier<List<String?>> selectedImages) async {
    if (selectedImages.value.length >= 4) {
      return;
    }

    try {
      final int remainingSlots = 4 - selectedImages.value.length;
      if (remainingSlots > 1) {
        final List<String?> images =
            await ref.read(pickMultipleImageUsecaseProvider).execute();
        selectedImages.value = [...selectedImages.value, ...images];
      } else {
        final String? image =
            await ref.read(pickImageUsecaseProvider).execute();
        if (image != null) {
          selectedImages.value = [...selectedImages.value, image];
        }
      }
    } catch (e) {
      throw Exception('画像の取得に失敗しました。再度お試しください。');
    }
  }
}

final postPageViewModel = Provider((ref) => PostPageViewModel());
