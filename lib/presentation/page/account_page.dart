import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/state/account_notifier.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/domain/type/account.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountNotifierProvider);
    final isExpandedList = useState<List<bool>>([false, false, false]);

    return Scaffold(
      appBar: AppBar(title: const Text('アカウント情報')),
      body: _buildAccountInfo(context, ref, accountState, isExpandedList),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.r, left: 20.r, right: 20.r),
        child: _buildAccountDeleteButton(context, ref),
      ),
    );
  }

  Widget _buildAccountInfo(
    BuildContext context,
    WidgetRef ref,
    Account account,
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
              return const ListTile(title: Text('ログイン方法'));
            },
            body: ListTile(title: Text('${account.providerName}アカウントでログイン')),
            isExpanded: isExpandedList.value[0],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(title: Text('メールアドレス'));
            },
            body: ListTile(title: Text(account.email)),
            isExpanded: isExpandedList.value[1],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(title: Text('登録日'));
            },
            body: ListTile(title: Text(account.registrationDate)),
            isExpanded: isExpandedList.value[2],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDeleteButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: const Text(
        'アカウントを削除する',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
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

        try {
          if (context.mounted) {
            await LoadingOverlay.of(context).during(
              () async =>
                  ref.read(accountNotifierProvider.notifier).deleteAccount(),
            );
          }
        } catch (e) {
          if (context.mounted) {
            await showErrorDialog(
              context: context,
              title: 'アカウント削除エラー',
              content: e.toString(),
            );
          }
        }
      },
    );
  }
}
