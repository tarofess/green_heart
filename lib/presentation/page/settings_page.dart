import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/application/di/settings_di.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          _buildEditProfileItem(context, ref),
          _buildBlockItem(context, ref),
          _buildContactItem(context, ref),
          _buildAppInfoItem(context, ref),
          _buildAccountItem(context, ref),
          _buildLogoutItem(context, ref),
        ],
      ),
    );
  }

  Widget _buildEditProfileItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.edit),
      title: const Text('プロフィール編集'),
      onTap: () {
        context.push('/profile_edit');
      },
    );
  }

  Widget _buildBlockItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.block),
      title: const Text('ブロックリスト'),
      onTap: () {
        context.push('/block_list');
      },
    );
  }

  Widget _buildContactItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.mail),
      title: const Text('お問い合わせ'),
      onTap: () async {
        await ref.read(emailSendUsecaseProvider).execute();
      },
    );
  }

  Widget _buildAppInfoItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.info),
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

  Widget _buildAccountItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: const Text('アカウントの情報'),
      onTap: () {
        context.push('/account');
      },
    );
  }

  Widget _buildLogoutItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text(
        'ログアウト',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        try {
          final result = await showConfirmationDialog(
            context: context,
            title: 'ログアウト',
            content: 'アカウントからログアウトしますか？',
            positiveButtonText: 'ログアウト',
            negativeButtonText: 'キャンセル',
          );
          if (!result) return;

          await ref.read(signOutUseCaseProvider).execute();
          ref.read(timelineScrollStateNotifierProvider.notifier)
            ..updateLastDocument(null)
            ..updateHasMore(true);
        } catch (e) {
          if (context.mounted) {
            showErrorDialog(
              context: context,
              title: 'ログアウトエラー',
              content: e.toString(),
            );
          }
        }
      },
    );
  }
}
