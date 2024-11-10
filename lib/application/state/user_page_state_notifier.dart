import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/user_page_state.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/state/profile_notifier.dart';

class UserPageStateNotifier
    extends FamilyAsyncNotifier<UserPageState, String?> {
  @override
  Future<UserPageState> build(String? arg) async {
    try {
      if (arg == null) {
        throw Exception('ユーザー情報が取得できません。再度お試しください。');
      }

      final currentUid = ref.watch(authStateProvider).value?.uid;

      final profile = currentUid == arg
          ? ref.watch(profileNotifierProvider).value
          : await ref.read(profileGetUsecaseProvider).execute(arg);
      final isFollowing = await ref.read(followCheckUsecaseProvider).execute(
            currentUid,
            arg,
          );
      final isBlocked = await ref.read(blockCheckUsecaseProvider).execute(
            currentUid,
            arg,
          );

      return UserPageState(
        profile: profile,
        isFollowing: isFollowing,
        isBlocked: isBlocked,
      );
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ユーザーデータの取得に失敗しました。再度お試しください。');
    }
  }

  void setIsFollowing(bool isFollowing) {
    state.whenData((currentState) {
      state = AsyncValue.data(currentState.copyWith(isFollowing: isFollowing));
    });
  }

  void setIsBlocked(bool isBlocked) {
    state.whenData((currentState) {
      state = AsyncValue.data(currentState.copyWith(isBlocked: isBlocked));
    });
  }
}

final userPageStateNotifierProvider =
    AsyncNotifierProviderFamily<UserPageStateNotifier, UserPageState, String?>(
  UserPageStateNotifier.new,
);
