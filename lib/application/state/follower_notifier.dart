import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow_data.dart';
import 'package:green_heart/domain/type/follow.dart';

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

  Future<void> addFollower(String myUid, String targetUid) async {
    final newFollower = Follow(
      uid: myUid,
      followingUid: targetUid,
      createdAt: DateTime.now(),
    );
    final profile = await ref.read(profileGetUsecaseProvider).execute(
          myUid,
        );

    if (profile == null) {
      throw AppException('フォローされるユーザーが存在しません。再度お試しください。');
    }

    final followData = FollowData(follow: newFollower, profile: profile);
    state.whenData((followDataList) {
      state = AsyncValue.data(followDataList..add(followData));
    });
  }

  Future<void> removeFollower(String myUid, String targetUid) async {
    state = state.whenData((followDataList) {
      followDataList.removeWhere((followData) =>
          followData.follow.followingUid == targetUid &&
          followData.follow.uid == myUid);
      return followDataList;
    });
  }
}

final followerNotifierProvider =
    AsyncNotifierProviderFamily<FollowerNotifier, List<FollowData>, String?>(
  FollowerNotifier.new,
);
