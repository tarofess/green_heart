import 'package:flutter/foundation.dart';

import 'package:green_heart/application/usecase/pick_image_usecase.dart';
import 'package:green_heart/application/usecase/pick_multiple_image_usecase.dart';
import 'package:green_heart/domain/type/result.dart';

class PickPostImagesUsecase {
  final PickImageUsecase _pickImageUsecase;
  final PickMultipleImageUsecase _pickMultipleImageUsecase;

  PickPostImagesUsecase(this._pickImageUsecase, this._pickMultipleImageUsecase);

  Future<Result> execute(ValueNotifier<List<String>> selectedImages) async {
    try {
      final int remainingSlots = 5 - selectedImages.value.length;

      if (remainingSlots > 1) {
        final List<String> images = await _pickMultipleImageUsecase.execute();
        if (selectedImages.value.length + images.length > 5) {
          return const Failure('画像は全部で5枚までしか選択できません。\n5枚以下で選択し直してください。');
        }

        selectedImages.value = [...selectedImages.value, ...images];
      } else {
        final result = await _pickImageUsecase.execute();
        switch (result) {
          case Success(value: final image):
            if (image != null) {
              selectedImages.value = [...selectedImages.value, image];
            }
            break;
          case Failure(message: final message):
            return Failure(message);
        }
      }

      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
