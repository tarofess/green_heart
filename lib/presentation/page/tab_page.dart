import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/timeline_page.dart';
import 'package:green_heart/application/di/notification_setting_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/device_info_di.dart';
import 'package:green_heart/presentation/page/notification_page.dart';

class TabPage extends HookConsumerWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);

    useEffect(() {
      void initFcmToken() async {
        final deviceId = await ref.read(deviceInfoGetUsecaseProvider).execute();
        if (deviceId == null) return;

        await ref.read(notificationSaveUsecaeProvider).execute(
              ref.watch(authStateProvider).value?.uid,
              deviceId,
            );
      }

      initFcmToken();

      return () {};
    }, []);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: selectedIndex.value,
        onTap: (int index) {
          selectedIndex.value = index;
        },
      ),
      body: IndexedStack(
        index: selectedIndex.value,
        children: [
          const HomePage(),
          if (selectedIndex.value == 1)
            const TimelinePage()
          else
            const SizedBox.shrink(),
          if (selectedIndex.value == 2)
            const NotificationPage()
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
