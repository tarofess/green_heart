import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow_data.dart';

class FollowNotifier extends AsyncNotifier<List<FollowData>> {
  @override
  Future<List<FollowData>> build() async {
    return [];
  }

  Future<void> follow(String uid, String followingUid) async {
    final newFollow =
        await ref.read(followAddUsecaseProvider).execute(uid, followingUid);
    final profile =
        await ref.read(profileGetUsecaseProvider).execute(followingUid);

    if (profile == null) {
      throw AppException('フォローするユーザーが存在しません。再度お試しください。');
    }

    final followData = FollowData(
      follow: newFollow,
      profile: profile,
    );

    state.whenData((followDataList) {
      followDataList.add(followData);
      return followDataList;
    });
  }

  Future<void> unfollow(String uid, String followingUid) async {
    await ref.read(followDeleteUsecaseProvider).execute(uid, followingUid);
    state.whenData((followDataList) {
      followDataList.removeWhere((followData) =>
          followData.follow.followingUid == followingUid &&
          followData.follow.uid == uid);
      return followDataList;
    });
  }
}

final followNotifierProvider =
    AsyncNotifierProvider<FollowNotifier, List<FollowData>>(
  () => FollowNotifier(),
);
