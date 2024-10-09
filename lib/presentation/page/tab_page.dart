import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/viewmodel/tab_page_viewmodel.dart';
import 'package:green_heart/application/state/profile_notifier_provider.dart';

class TabPage extends HookConsumerWidget {
  const TabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(tabPageViewModelProvider);
    final profile = ref.watch(profileNotifierProvider);
    final selectedIndex = useState(0);

    return profile.when(
      data: (data) {
        if (data == null) {
          context.go('/profile_edit');
          return const Scaffold(body: SizedBox());
        } else {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'ホーム',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.post_add),
                  label: 'みんなの投稿',
                ),
              ],
              currentIndex: selectedIndex.value,
              onTap: (int index) {
                selectedIndex.value = index;
              },
            ),
            body: viewModel.pages[selectedIndex.value],
          );
        }
      },
      error: (error, stackTrace) {
        return ErrorPage(
          error: error,
          retry: () => ref.refresh(profileNotifierProvider),
        );
      },
      loading: () {
        return const Scaffold(body: LoadingIndicator());
      },
    );
  }
}
