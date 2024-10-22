import 'package:green_heart/application/state/base_post_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

class TimelineNotifier extends BasePostNotifier {
  @override
  Future<List<PostWithProfile>> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    return posts;
  }
}

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostWithProfile>>(
  () => TimelineNotifier(),
);
