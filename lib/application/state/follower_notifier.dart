import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow_data.dart';
import 'package:green_heart/domain/type/follow.dart';
import 'package:green_heart/application/state/following_notifier.dart';

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
      final profile = await ref
          .read(profileGetUsecaseProvider)
          .execute(follow.followingUid);
      return FollowData(
        follow: follow,
        profile: profile,
      );
    }).toList();

    return Future.wait(followDataList);
  }

  Future<void> follow(String myUid, String targetUid) async {
    final newFollow =
        await ref.read(followingAddUsecaseProvider).execute(myUid, targetUid);
    final profile = await ref.read(profileGetUsecaseProvider).execute(myUid);

    if (profile == null) {
      throw AppException('フォローされるユーザーが存在しません。再度お試しください。');
    }

    final followData = FollowData(follow: newFollow, profile: profile);
    state.whenData((followDataList) {
      followDataList.add(followData);
      return followDataList;
    });

    ref.read(followingNotifierProvider(myUid).notifier).addFollow(
          myUid,
          targetUid,
        );
  }

  Future<void> unfollow(String myUid, String targetUid) async {
    await ref.read(followingDeleteUsecaseProvider).execute(myUid, targetUid);
    state.whenData((followDataList) {
      followDataList.removeWhere((followData) =>
          followData.follow.followingUid == targetUid &&
          followData.follow.uid == myUid);
      return followDataList;
    });

    ref.read(followingNotifierProvider(myUid).notifier).removeFollow(
          myUid,
          targetUid,
        );
  }
}

final followerNotifierProvider =
    AsyncNotifierProviderFamily<FollowerNotifier, List<FollowData>, String?>(
  FollowerNotifier.new,
);
