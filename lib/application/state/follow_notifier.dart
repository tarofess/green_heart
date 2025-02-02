import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow.dart';
import 'package:green_heart/application/state/follower_notifier.dart';

class FollowNotifier extends FamilyAsyncNotifier<List<Follow>, String?> {
  @override
  Future<List<Follow>> build(String? arg) async {
    if (arg == null) {
      throw AppException('ユーザー情報の取得に失敗しました。再度お試しください。');
    }

    final follows = await ref.read(followGetUsecaseProvider).execute(arg);
    return follows;
  }

  Future<void> follow(String targetUid, Follow follow, Follow follower) async {
    state.whenData((followDataList) {
      state = AsyncValue.data([...followDataList, follow]);
    });

    ref.read(followerNotifierProvider(targetUid).notifier).addFollower(
          follower,
        );
  }

  void unfollow(String myUid, String targetUid) {
    state.whenData((followDataList) {
      final updatedState = followDataList
          .where((follows) => !(follows.uid == targetUid))
          .toList();
      state = AsyncValue.data(updatedState);
    });

    ref.read(followerNotifierProvider(targetUid).notifier).removeFollower(
          myUid,
        );
  }
}

final followNotifierProvider =
    AsyncNotifierProviderFamily<FollowNotifier, List<Follow>, String?>(
  FollowNotifier.new,
);
