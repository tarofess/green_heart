import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';

class TimelineNotifier extends AsyncNotifier<List<PostData>> {
  @override
  Future<List<PostData>> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    List<PostData> postData = [];

    for (var post in posts) {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(post.uid);
      final commentCount =
          await ref.read(commentGetUsecaseProvider).execute(post.id);

      postData.add(
        PostData(
          post: post,
          userProfile: profile,
          commentCount: commentCount.length,
        ),
      );
    }

    return postData;
  }
}

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostData>>(
  () => TimelineNotifier(),
);
