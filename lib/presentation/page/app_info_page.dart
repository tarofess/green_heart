import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_heart/application/di/settings_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key, required this.appInfo});

  final String? appInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpandedList = useState<List<bool>>([false, false, false]);
    final updateHistoryText = useState('');

    useEffect(() {
      Future<void> getUpdateHistory() async {
        updateHistoryText.value =
            await ref.read(updateHistoryUsecaseProvider).execute() ??
                '更新履歴を取得できませんでした。';
      }

      try {
        getUpdateHistory();
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
                return const ListTile(title: Text('更新履歴'));
              },
              body: ListTile(title: Text(updateHistoryText.value)),
              isExpanded: isExpandedList.value[2],
            ),
          ],
        ),
      ),
    );
  }
}
