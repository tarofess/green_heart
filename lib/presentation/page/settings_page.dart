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

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '設定',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
      ),
      body: ListView(
        children: [
          _buildEditProfileItem(context, ref),
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
      title: Text(
        'プロフィール編集',
        style: TextStyle(fontSize: 16.sp),
      ),
      onTap: () {
        context.push('/profile_edit');
      },
    );
  }

  Widget _buildBlockItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.block,
        size: 24.r,
      ),
      title: Text(
        'ブロックリスト',
        style: TextStyle(fontSize: 16.sp),
      ),
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
      title: Text(
        'お問い合わせ',
        style: TextStyle(fontSize: 16.sp),
      ),
      onTap: () async {
        await ref.read(emailSendUsecaseProvider).execute();
      },
    );
  }

  Widget _buildAppInfoItem(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.info,
        size: 24.r,
      ),
      title: Text(
        'アプリの情報',
        style: TextStyle(fontSize: 16.sp),
      ),
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
      title: Text(
        'アカウントの情報',
        style: TextStyle(fontSize: 16.sp),
      ),
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
      title: Text(
        'ログアウト',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
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
            ref.read(timelineScrollStateNotifierProvider.notifier).reset();
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
