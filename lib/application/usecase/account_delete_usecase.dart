import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/account_repository.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';
import 'package:green_heart/application/usecase/account_reauth_usecase.dart';
import 'package:green_heart/application/usecase/comment_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/follow_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/like_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/notification_delete_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/profile_delete_usecase.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/result.dart';

class AccountDeleteUsecase {
  final AccountReauthUsecase _accountReauthUsecase;
  final NotificationDeleteUsecase _notificationDeleteUsecase;
  final LikeDeleteAllUsecase _likeDeleteAllUsecase;
  final CommentDeleteAllUsecase _commentDeleteAllUsecase;
  final FollowDeleteAllUsecase _followDeleteAllUsecase;
  final ProfileDeleteUsecase _profileDeleteUsecase;
  final PostDeleteAllUsecase _postDeleteAllUsecase;
  final AccountStateNotifier _accountStateNotifier;
  final AccountRepository _accountRepository;

  AccountDeleteUsecase(
    this._accountReauthUsecase,
    this._notificationDeleteUsecase,
    this._likeDeleteAllUsecase,
    this._commentDeleteAllUsecase,
    this._followDeleteAllUsecase,
    this._profileDeleteUsecase,
    this._postDeleteAllUsecase,
    this._accountStateNotifier,
    this._accountRepository,
  );

  Future<Result> execute(User? user, Profile? profile) async {
    if (profile == null || user == null) {
      return const Failure('現在アカウント情報が取得できないためアカウントを削除できません。のちほどお試しください。');
    }
    try {
      final result = await _accountReauthUsecase.execute(user);

      if (result is Failure) {
        return result;
      }

      final deleteTasks = Future.wait([
        _notificationDeleteUsecase.execute(user),
        _likeDeleteAllUsecase.execute(user),
        _commentDeleteAllUsecase.execute(user),
        _followDeleteAllUsecase.execute(user),
        _profileDeleteUsecase.execute(user, profile),
        _postDeleteAllUsecase.execute(user),
      ]);

      await deleteTasks;

      Future.microtask(() {
        _accountStateNotifier.setAccountDeletedState(true);
      });

      await _accountRepository.deleteAccount(user);
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
