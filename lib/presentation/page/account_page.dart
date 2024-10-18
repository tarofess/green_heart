import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/application/state/delete_account_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/viewmodel/account_page_viewmodel.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpandedList = useState<List<bool>>([false, false, false]);
    final providerName = useState('');
    final registrationDate = useState('');

    useEffect(() {
      void setProviderName() {
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
      }

      void setRegistrationDate() {
        final creationTime =
            ref.read(authStateProvider).value?.metadata.creationTime;
        registrationDate.value = DateUtil.formatCreationTime(creationTime);
      }

      setProviderName();
      setRegistrationDate();
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
                return const ListTile(title: Text('ログイン方法'));
              },
              body: ListTile(title: Text('${providerName.value}アカウントでログイン')),
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
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(title: Text('登録日'));
              },
              body: ListTile(title: Text(registrationDate.value)),
              isExpanded: isExpandedList.value[2],
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
          content: 'アカウントを削除すると復元ができませんが、本当にアカウントを削除しますか？',
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
            await LoadingOverlay.of(context).during(() async {
              await ref.read(accountPageViewModelProvider).deleteAccount();
              ref.read(deleteAccountStateProvider.notifier).state = true;
            });
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
