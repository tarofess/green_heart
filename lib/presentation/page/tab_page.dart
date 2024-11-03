import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/tab_page_provider.dart';

class TabPage extends HookConsumerWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabPageState = ref.watch(tabPageProvider);
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
      body: tabPageState[selectedIndex.value],
      floatingActionButton: SizedBox(
        width: 58.r,
        height: 58.r,
        child: FloatingActionButton(
          onPressed: () {
            context.go('/post');
          },
          child: ImageIcon(
            const AssetImage('assets/images/post_floating_action_icon.png'),
            size: 28.r,
          ),
        ),
      ),
    );
  }
}
