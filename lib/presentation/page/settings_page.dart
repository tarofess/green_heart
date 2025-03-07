import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/application/di/settings_di.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/infrastructure/util/permission_util.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          _buildEditProfileItem(context, ref),
          _buildNotificationSettingItem(context, ref),
          _buildBlockItem(context, ref),
          _buildContactItem(context, ref),
          _buildAppInfoItem(context, ref),
          _buildAccountInfoItem(context, ref),
          _buildLogoutItem(context, ref),
        ],
      ),
    );
  }

  Widget _buildEditProfileItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.edit,
        size: 24.r,
      ),
      title: const Text('プロフィール編集'),
      onTap: () {
        context.push('/profile_edit');
      },
    );
  }

  Widget _buildNotificationSettingItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.notifications,
        size: 24.r,
      ),
      title: const Text('通知設定'),
      onTap: () async {
        if (await PermissionUtil.requestNotificationPermission(context)) {
          if (context.mounted) context.push('/notification_setting');
        }
      },
    );
  }

  Widget _buildBlockItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.block,
        size: 24.r,
      ),
      title: const Text('ブロックリスト'),
      onTap: () {
        context.push('/block_list');
      },
    );
  }

  Widget _buildContactItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.mail,
        size: 24.r,
      ),
      title: const Text('お問い合わせ'),
      onTap: () async {
        final result =
            await LoadingOverlay.of(context, backgroundColor: Colors.white10)
                .during(
          () => ref.read(emailSendUsecaseProvider).execute(),
        );

        switch (result) {
          case Success():
            break;
          case Failure(message: final message):
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
        }
      },
    );
  }

  Widget _buildAppInfoItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.info,
        size: 24.r,
      ),
      title: const Text('アプリの情報'),
      onTap: () async {
        try {
          final appInfo =
              await ref.read(appVersionGetUsecaseProvider).execute();
          if (context.mounted) {
            context.push('/app_info', extra: {'app_info': appInfo});
          }
        } catch (e) {
          if (context.mounted) {
            showErrorDialog(
              context: context,
              title: 'アプリ情報取得エラー',
              content: e.toString(),
            );
          }
        }
      },
    );
  }

  Widget _buildAccountInfoItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        size: 24.r,
      ),
      title: const Text('アカウントの情報'),
      onTap: () {
        context.push('/account_info');
      },
    );
  }

  Widget _buildLogoutItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.logout,
        size: 24.r,
      ),
      title: const Text(
        'ログアウト',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        final isConfirmed = await showConfirmationDialog(
          context: context,
          title: 'ログアウト',
          content: 'アカウントからログアウトしますか？',
          positiveButtonText: 'ログアウト',
          negativeButtonText: 'キャンセル',
        );
        if (!isConfirmed) return;

        final result = await ref.read(signOutUseCaseProvider).execute();
        switch (result) {
          case Success():
            final uid = ref.read(authStateProvider).value?.uid;
            if (uid == null) return;

            ref.read(timelineScrollStateNotifierProvider.notifier).reset();
            ref.read(userPostScrollStateNotifierProvider(uid).notifier).reset();
            break;
          case Failure(message: final message):
            if (context.mounted) {
              showErrorDialog(
                context: context,
                title: 'ログアウトエラー',
                content: message,
              );
            }
        }
      },
    );
  }
}
