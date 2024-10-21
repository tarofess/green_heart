import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/domain/type/post.dart';

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<Post>>(
  () => TimelineNotifier(),
);
