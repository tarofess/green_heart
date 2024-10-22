import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostWithProfile>>(
  () => TimelineNotifier(),
);
