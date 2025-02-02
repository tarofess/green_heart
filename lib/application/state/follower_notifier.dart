import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowerNotifier extends FamilyAsyncNotifier<List<Follow>, String?> {
  @override
  Future<List<Follow>> build(String? arg) async {
    if (arg == null) {
      throw AppException('ユーザー情報の取得に失敗しました。再度お試しください。');
    }

    final followers = await ref.read(followerGetUsecaseProvider).execute(arg);
    return followers;
  }

  void addFollower(Follow follow) {
    state.whenData((followDataList) {
      state = AsyncValue.data([...followDataList, follow]);
    });
  }

  void removeFollower(String myUid) {
    state.whenData((followDataList) {
      final updatedState =
          followDataList.where((follows) => !(follows.uid == myUid)).toList();
      state = AsyncValue.data(updatedState);
    });
  }
}

final followerNotifierProvider =
    AsyncNotifierProviderFamily<FollowerNotifier, List<Follow>, String?>(
  FollowerNotifier.new,
);
