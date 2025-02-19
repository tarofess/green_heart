import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/timeline_page.dart';
import 'package:green_heart/presentation/page/notification_page.dart';
import 'package:green_heart/application/state/notification_setup_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/application/state/selected_tab_index_notifier.dart';
import 'package:green_heart/infrastructure/service/messaging_handlers_service.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';

class TabPage extends HookConsumerWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSetupState = ref.watch(notificationSetupNotifierProvider);
    final selectedIndex = ref.watch(selectedTabIndexNotifierProvider);
    final isCompletedSetup = useState(false);

    useEffect(() {
      void setupNotificationHandlers() {
        final selectedIndexNotifier =
            ref.read(selectedTabIndexNotifierProvider.notifier);

        MessagingHandlersService(selectedIndexNotifier)
            .setupNotificationHandlers();
      }

      setupNotificationHandlers();

      return null;
    }, const []);

    return Scaffold(
      bottomNavigationBar: isCompletedSetup.value == true
          ? BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 24.r),
                  label: 'ホーム',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feed_outlined, size: 24.r),
                  label: 'みんなの投稿',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none_outlined, size: 24.r),
                  label: '通知',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (int index) {
                ref
                    .read(selectedTabIndexNotifierProvider.notifier)
                    .setSelectedIndex(
                      index,
                    );
              },
            )
          : null,
      body: notificationSetupState.when(
        data: (data) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isCompletedSetup.value = true;
          });

          return IndexedStack(
            index: selectedIndex,
            children: [
              const HomePage(),
              if (selectedIndex == 1)
                const TimelinePage()
              else
                const SizedBox.shrink(),
              if (selectedIndex == 2)
                const NotificationPage()
              else
                const SizedBox.shrink(),
            ],
          );
        },
        loading: () {
          return const Center(
            child: LoadingIndicator(message: 'アプリの準備中'),
          );
        },
        error: (e, stackTrace) {
          return AsyncErrorWidget(
            error: e,
            retry: () => ref.refresh(notificationSetupNotifierProvider),
          );
        },
      ),
    );
  }
}
