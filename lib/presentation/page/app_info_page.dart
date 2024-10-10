import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/settings_di.dart';

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key, required this.appInfo});

  final String? appInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpandedList =
        useState<List<bool>>([false, false, false, false, false]);
    final termsOfUse = useState('');
    final privacyPolicy = useState('');
    final updateHistoryText = useState('');

    useEffect(() {
      Future<void> getFilesText() async {
        termsOfUse.value = await ref
                .read(appInfoReadTextFileUsecaseProvider)
                .execute('terms_of_use.txt') ??
            '利用規約を取得できませんでした。';
        privacyPolicy.value = await ref
                .read(appInfoReadTextFileUsecaseProvider)
                .execute('privacy_policy.txt') ??
            'プライバシーポリシーを取得できませんでした。';
        updateHistoryText.value = await ref
                .read(appInfoReadTextFileUsecaseProvider)
                .execute('update_history.txt') ??
            '更新履歴を取得できませんでした。';
      }

      try {
        getFilesText();
      } catch (e) {
        return;
      }
      return;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('アプリの情報')),
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
                return const ListTile(title: Text('開発者'));
              },
              body: const ListTile(title: Text('ところやまたろう')),
              isExpanded: isExpandedList.value[0],
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(title: Text('アプリのバージョン'));
              },
              body: ListTile(title: Text(appInfo ?? '不明')),
              isExpanded: isExpandedList.value[1],
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(title: Text('利用規約'));
              },
              body: ListTile(title: Text(termsOfUse.value)),
              isExpanded: isExpandedList.value[2],
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(title: Text('プライバシーポリシー'));
              },
              body: ListTile(title: Text(privacyPolicy.value)),
              isExpanded: isExpandedList.value[3],
            ),
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(title: Text('更新履歴'));
              },
              body: ListTile(title: Text(updateHistoryText.value)),
              isExpanded: isExpandedList.value[4],
            ),
          ],
        ),
      ),
    );
  }
}
