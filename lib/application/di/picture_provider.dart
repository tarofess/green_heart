import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/pick_image_usecase.dart';
import 'package:green_heart/application/usecase/take_photo_usecase.dart';
import 'package:green_heart/infrastructure/repository/image_picker_repository.dart';

final takePhotoUsecaseProvider = Provider(
  (ref) => TakePhotoUsecase(ImagePickerRepository()),
);

final pickImageUsecaseProvider = Provider(
  (ref) => PickImageUsecase(ImagePickerRepository()),
);
