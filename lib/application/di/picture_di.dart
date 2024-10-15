import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/pick_image_usecase.dart';
import 'package:green_heart/application/usecase/take_photo_usecase.dart';
import 'package:green_heart/application/usecase/pick_multiple_image_usecase.dart';
import 'package:green_heart/infrastructure/service/image_picker_service.dart';

final takePhotoUsecaseProvider = Provider(
  (ref) => TakePhotoUsecase(ImagePickerService()),
);

final pickImageUsecaseProvider = Provider(
  (ref) => PickImageUsecase(ImagePickerService()),
);

final pickMultipleImageUsecaseProvider = Provider(
  (ref) => PickMultipleImageUsecase(ImagePickerService()),
);
