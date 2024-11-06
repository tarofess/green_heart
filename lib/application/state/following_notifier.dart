import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow_data.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowingNotifier extends FamilyAsyncNotifier<List<FollowData>, String?> {
  @override
  Future<List<FollowData>> build(String? arg) async {
    if (arg == null) {
      throw AppException('ユーザー情報の取得に失敗しました。再度お試しください。');
    }

    final follows = await ref.read(followingGetUsecaseProvider).execute(arg);
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

  Future<void> addFollow(String myUid, String targetUid) async {
    final newFollow = Follow(
      uid: myUid,
      followingUid: targetUid,
      createdAt: DateTime.now(),
    );
    final profile =
        await ref.read(profileGetUsecaseProvider).execute(targetUid);

    if (profile == null) {
      throw AppException('フォローするユーザーが存在しません。再度お試しください。');
    }

    final followData = FollowData(follow: newFollow, profile: profile);
    state.whenData((followDataList) {
      followDataList.add(followData);
      return followDataList;
    });
  }

  Future<void> removeFollow(String myUid, String targetUid) async {
    state.whenData((followDataList) {
      followDataList.removeWhere((followData) =>
          followData.follow.followingUid == targetUid &&
          followData.follow.uid == myUid);
      return followDataList;
    });
  }
}

final followingNotifierProvider =
    AsyncNotifierProviderFamily<FollowingNotifier, List<FollowData>, String?>(
  FollowingNotifier.new,
);
