import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_upload_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/application/usecase/post_get_usecase.dart';

final postUploadUsecaseProvider = Provider(
  (ref) => PostUploadUsecase(FirebasePostRepository()),
);

final postGetUsecaseProvider = Provider(
  (ref) => PostGetUsecase(FirebasePostRepository()),
);
