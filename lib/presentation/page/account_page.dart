import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/presentation/dialog/message_dialog.dart';
import 'package:green_heart/application/viewmodel/account_page_viewmodel.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpandedList = useState<List<bool>>([false, false]);
    final providerName = useState('');

    useEffect(() {
      switch (
          ref.read(authStateProvider).value?.providerData.first.providerId) {
        case 'google.com':
          providerName.value = 'Google';
          break;
        case 'apple.com':
          providerName.value = 'Apple';
          break;
        default:
          providerName.value = '不明';
          break;
      }
      return;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('アカウント情報')),
      body: SingleChildScrollView(
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
                return const ListTile(title: Text('ログイン状態'));
              },
              body: ListTile(title: Text('${providerName.value}アカウントでログイン中')),
              isExpanded: isExpandedList.value[0],
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(title: Text('メールアドレス'));
              },
              body: ListTile(
                  title:
                      Text(ref.read(authStateProvider).value?.email ?? 'なし')),
              isExpanded: isExpandedList.value[1],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.r, left: 20.r, right: 20.r),
        child: _buildAccountDeleteButton(context, ref),
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
          content: '本当にアカウントを削除しますか？',
          positiveButtonText: '削除',
          negativeButtonText: 'キャンセル',
        );
        if (!result) return;

        try {
          if (context.mounted) {
            await LoadingOverlay.of(context).during(
              () async =>
                  ref.read(accountPageViewModelProvider).deleteAccount(),
            );
          }
          if (context.mounted) {
            await showMessageDialog(
              context: context,
              title: 'アカウント削除完了',
              content: 'アカウントを削除しました。',
            );
          }
          await ref.read(signOutUseCaseProvider).execute();
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
