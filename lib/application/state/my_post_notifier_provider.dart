import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/my_post_notifier.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

final myPostNotifierProvider =
    AsyncNotifierProvider<MyPostNotifier, List<PostWithProfile>>(
  () => MyPostNotifier(),
);
