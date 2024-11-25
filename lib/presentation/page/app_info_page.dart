import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/app_info_notifier.dart';
import 'package:green_heart/main.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage({super.key, required this.appInfo});

  final String? appInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfoState = ref.watch(appInfoNotifierProvider);
    final isExpandedList =
        useState<List<bool>>([false, false, false, false, false]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'アプリの情報',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
      ),
      body: SafeArea(
        child: appInfoState.when(
          data: (appInfo) {
            return SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  isExpandedList.value = isExpandedList.value
                      .asMap()
                      .map((i, value) =>
                          MapEntry(i, i == index ? !value : value))
                      .values
                      .toList();
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          '開発者',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        appInfo.developerName,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    isExpanded: isExpandedList.value[0],
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'アプリのバージョン',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        appInfo.appVersion,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    isExpanded: isExpandedList.value[1],
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          '利用規約',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        appInfo.termsOfUse,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    isExpanded: isExpandedList.value[2],
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'プライバシーポリシー',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        appInfo.privacyPolicy,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    isExpanded: isExpandedList.value[3],
                  ),
                ],
              ),
            );
          },
          loading: () {
            return const LoadingIndicator(message: '読み込み中');
          },
          error: (e, _) {
            return AsyncErrorWidget(
              error: e,
              retry: () => ref.refresh(appInitProvider),
            );
          },
        ),
      ),
    );
  }
}
