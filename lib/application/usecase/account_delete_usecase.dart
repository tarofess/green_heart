import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/account_repository.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';
import 'package:green_heart/domain/type/profile.dart';

class AccountDeleteUsecase {
  final FirebaseAuthService _authService;
  final AccountRepository _accountRepository;
  final ProfileRepository _profileRepository;
  final PostRepository _postRepository;
  final NotificationRepository _notificationRepository;
  final ProfileNotifier _profileNotifierProvider;

  AccountDeleteUsecase(
    this._authService,
    this._accountRepository,
    this._profileRepository,
    this._postRepository,
    this._notificationRepository,
    this._profileNotifierProvider,
  );

  Future<void> execute(User user, Profile? profile) async {
    if (profile == null) {
      throw Exception('現在アカウントを削除できません。のちほどお試しください。');
    }

    try {
      await reauthenticate(user);
      await deleteNotificationToken(user);
      await deletePosts(user);
      await deleteProfile(user, profile);
      await deleteAccount(user);
    } catch (e) {
      throw AppException(
        'アカウントの削除に途中で失敗しました。\n'
        '完全にアカウントを削除するために後ほどもう一度お試しください。',
        e,
      );
    }
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
    await _notificationRepository.deleteFcmToken(user.uid);
  }

  Future<void> deletePosts(User user) async {
    await _postRepository.deleteAllPosts(user.uid);
    await _postRepository.deleteAllImages(user.uid);
  }

  Future<void> deleteProfile(User user, Profile? profile) async {
    if (profile!.imageUrl != null) {
      await _profileRepository.deleteImage(profile.imageUrl!);
    }
    await _profileRepository.deleteProfile(user.uid);
    _profileNotifierProvider.setProfile(null);
  }

  Future<void> deleteAccount(User user) async {
    await _accountRepository.deleteAccount(user);
  }
}
