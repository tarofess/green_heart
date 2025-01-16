import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/state/account_info_notifier.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/domain/type/account_info.dart';
import 'package:green_heart/application/di/account_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class AccountInfoPage extends HookConsumerWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountNotifierProvider);
    final isExpandedList = useState<List<bool>>([false, false, false]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'アカウント情報',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
      ),
      body: _buildAccountInfo(context, ref, accountState, isExpandedList),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        child: _buildAccountDeleteButton(context, ref),
      ),
    );
  }

  Widget _buildAccountInfo(
    BuildContext context,
    WidgetRef ref,
    AccountInfo accountInfo,
    ValueNotifier<List<bool>> isExpandedList,
  ) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          isExpandedList.value = isExpandedList.value
              .asMap()
              .map((i, value) => MapEntry(i, i == index ? !value : value))
              .values
              .toList();
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  'ログインサービス',
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            },
            body: ListTile(
              title: Text(
                '${accountInfo.providerName}アカウントでログイン',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            isExpanded: isExpandedList.value[0],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  'メールアドレス',
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            },
            body: ListTile(
              title: Text(
                accountInfo.email,
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            isExpanded: isExpandedList.value[1],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  '登録日',
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            },
            body: ListTile(
              title: Text(
                accountInfo.registrationDate,
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            isExpanded: isExpandedList.value[2],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDeleteButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: Text(
        'アカウントを削除する',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
      onPressed: () async {
        final result = await showConfirmationDialog(
          context: context,
          title: 'アカウント削除',
          content: 'アカウントを削除すると投稿データやプロフィールなどアカウントに紐付く全てのデータが削除されます。\n\n'
              '一度削除すると復元ができませんが、本当にアカウントを削除しますか？',
          positiveButtonText: '削除する',
          negativeButtonText: 'キャンセル',
        );
        if (!result) return;

        if (context.mounted) {
          final result2 = await showConfirmationDialog(
            context: context,
            title: '再認証',
            content: 'アカウント削除を続けるためにもう一度ログインし直してください。',
            positiveButtonText: 'ログイン',
            negativeButtonText: 'キャンセル',
          );
          if (!result2) return;
        }

        if (context.mounted) {
          final result =
              await LoadingOverlay.of(context, message: 'アカウント削除中').during(() {
            final user = ref.read(authStateProvider).value;
            final profile = ref.read(profileNotifierProvider).value;
            return ref.read(accountDeleteUsecaseProvider).execute(
                  user,
                  profile,
                );
          });

          switch (result) {
            case Success():
              break;
            case Failure(message: final message):
              if (context.mounted) {
                await showErrorDialog(
                  context: context,
                  title: 'アカウント削除エラー',
                  content: message,
                );
              }
          }
        }
      },
    );
  }
}
