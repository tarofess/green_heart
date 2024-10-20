import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/post_notifier.dart';
import 'package:green_heart/domain/type/post.dart';

final postNotifierProvider = AsyncNotifierProvider<PostNotifier, List<Post>>(
  () => PostNotifier(),
);
