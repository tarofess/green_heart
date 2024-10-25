import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/app_info_notifier.dart';

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key, required this.appInfo});

  final String? appInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfoState = ref.watch(appInfoNotifierProvider);
    final isExpandedList =
        useState<List<bool>>([false, false, false, false, false]);

    return Scaffold(
      appBar: AppBar(title: const Text('アプリの情報')),
      body: appInfoState.when(
        data: (appInfo) {
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
                    return const ListTile(title: Text('開発者'));
                  },
                  body: ListTile(title: Text(appInfo.developerName)),
                  isExpanded: isExpandedList.value[0],
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(title: Text('アプリのバージョン'));
                  },
                  body: ListTile(title: Text(appInfo.appVersion)),
                  isExpanded: isExpandedList.value[1],
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(title: Text('利用規約'));
                  },
                  body: ListTile(title: Text(appInfo.termsOfUse)),
                  isExpanded: isExpandedList.value[2],
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(title: Text('プライバシーポリシー'));
                  },
                  body: ListTile(title: Text(appInfo.privacyPolicy)),
                  isExpanded: isExpandedList.value[3],
                ),
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(title: Text('更新履歴'));
                  },
                  body: ListTile(title: Text(appInfo.updateHistory)),
                  isExpanded: isExpandedList.value[4],
                ),
              ],
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, _) {
          return Center(child: Text('エラーが発生しました。$error'));
        },
      ),
    );
  }
}
