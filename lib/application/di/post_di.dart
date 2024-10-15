import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_upload_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';

final postUploadUsecaseProvider = Provider(
  (ref) => PostUploadUsecase(FirebasePostRepository()),
);
