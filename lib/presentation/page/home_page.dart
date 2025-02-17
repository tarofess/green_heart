import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/user_page.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/widget/post_search.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authStateProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        leading: IconButton(
          icon: Icon(Icons.menu, size: 24.r),
          onPressed: () => context.push('/settings'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 24.r),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearch(uid: uid),
              );
            },
          ),
        ],
      ),
      body: UserPage(uid: uid),
    );
  }
}
