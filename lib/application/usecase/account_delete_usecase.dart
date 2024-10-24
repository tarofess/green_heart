import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/account_repository.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/application/state/my_post_notifier.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/usecase/signout_usecase.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';
import 'package:green_heart/domain/type/profile.dart';

class AccountDeleteUsecase {
  final FirebaseAuthService _authService;
  final AccountRepository _accountRepository;
  final ProfileRepository _profileRepository;
  final PostRepository _postRepository;
  final NotificationRepository _notificationRepository;
  final ProfileNotifier _profileNotifierProvider;
  final SignOutUseCase _signOutUseCase;
  final MyPostNotifier _postNotifierProvider;

  AccountDeleteUsecase(
    this._authService,
    this._accountRepository,
    this._profileRepository,
    this._postRepository,
    this._notificationRepository,
    this._profileNotifierProvider,
    this._signOutUseCase,
    this._postNotifierProvider,
  );

  Future<void> execute(User user, Profile? profile) async {
    if (profile == null) {
      throw Exception('現在アカウントを削除できません。のちほどお試しください。');
    }

    await reauthenticate(user);
    await deleteNotificationToken(user);
    await deletePosts(user);
    await deleteProfile(user, profile);
    await deleteAccount(user);
  }

  Future<void> reauthenticate(User user) async {
    String? providerId = user.providerData
        .firstWhere((info) =>
            info.providerId == 'google.com' || info.providerId == 'apple.com')
        .providerId;

    if (providerId == 'google.com') {
      await _authService.reauthenticateWithGoogle();
    } else if (providerId == 'apple.com') {
      await _authService.reauthenticateWithApple();
    } else {
      throw AppException('サポートされていない認証プロバイダです。');
    }
  }

  Future<void> deleteNotificationToken(User user) async {
    try {
      await _notificationRepository.deleteFcmToken(user.uid);
    } catch (e) {
      throw AppException(
        '通知トークンの削除に失敗したためアカウントが削除できませんでした。\n'
        'アカウントを削除するために後ほどもう一度お試しください。',
        e,
      );
    }
  }

  Future<void> deletePosts(User user) async {
    try {
      await Future.wait(
        [
          _postRepository.deleteAllPostsByUid(user.uid),
          _postRepository.deleteAllImagesByUid(user.uid),
        ],
        eagerError: true,
      );
      _postNotifierProvider.removeAllPosts();
    } catch (e) {
      throw AppException(
        '投稿データの削除に失敗したためアカウントが完全に削除できませんでした。\n'
        '完全にアカウントを削除するために後ほどもう一度お試しください。',
        e,
      );
    }
  }

  Future<void> deleteProfile(User user, Profile? profile) async {
    try {
      if (profile?.imageUrl != null && profile!.imageUrl!.isNotEmpty) {
        await _profileRepository.deleteImage(profile.imageUrl!);
      }
      await _profileRepository.deleteProfile(user.uid);
      _profileNotifierProvider.deleteProfile();
    } catch (e) {
      throw AppException(
        'プロフィールの削除に失敗したためアカウントが完全に削除できませんでした。\n'
        '現在投稿データは全て削除されています。\n'
        '完全にアカウントを削除するために後ほどもう一度お試しください。',
        e,
      );
    }
  }

  Future<void> deleteAccount(User user) async {
    try {
      await _accountRepository.deleteAccount(user);
    } catch (e) {
      _signOutUseCase.execute();
    }
  }
}
