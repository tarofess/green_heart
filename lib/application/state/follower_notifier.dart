import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow_data.dart';
import 'package:green_heart/domain/type/follow.dart';
import 'package:green_heart/application/state/profile_notifier.dart';

class FollowerNotifier extends FamilyAsyncNotifier<List<FollowData>, String?> {
  @override
  Future<List<FollowData>> build(String? arg) async {
    if (arg == null) {
      throw AppException('ユーザー情報の取得に失敗しました。再度お試しください。');
    }

    final follows = await ref.read(followerGetUsecaseProvider).execute(arg);
    final followDataList = await _createFollowDataList(follows);
    return followDataList;
  }

  Future<List<FollowData>> _createFollowDataList(List<Follow> follows) async {
    final followDataList = follows.map((follow) async {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(follow.uid);
      return FollowData(
        follow: follow,
        profile: profile,
      );
    }).toList();

    return Future.wait(followDataList);
  }

  void addFollower(String myUid, String targetUid) {
    final newFollower = Follow(
      uid: myUid,
      followingUid: targetUid,
      createdAt: DateTime.now(),
    );

    final myProfile = ref.read(profileNotifierProvider).value;

    final followData = FollowData(follow: newFollower, profile: myProfile);
    state.whenData((followDataList) {
      state = AsyncValue.data(followDataList..add(followData));
    });
  }

  void removeFollower(String myUid, String targetUid) {
    state.whenData((followDataList) {
      final updatedState = followDataList
          .where((followData) =>
              !(followData.follow.followingUid == targetUid &&
                  followData.follow.uid == myUid))
          .toList();
      state = AsyncValue.data(updatedState);
    });
  }
}

final followerNotifierProvider =
    AsyncNotifierProviderFamily<FollowerNotifier, List<FollowData>, String?>(
  FollowerNotifier.new,
);
