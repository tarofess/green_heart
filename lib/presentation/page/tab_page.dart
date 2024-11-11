import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/timeline_page.dart';

class TabPage extends HookConsumerWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);

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
        ],
        currentIndex: selectedIndex.value,
        onTap: (int index) {
          selectedIndex.value = index;
        },
      ),
      body: IndexedStack(
        index: selectedIndex.value,
        children: const [
          HomePage(),
          TimelinePage(),
        ],
      ),
    );
  }
}
