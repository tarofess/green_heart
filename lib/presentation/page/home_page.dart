import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/user_page.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/state/my_post_notifier.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPosts = ref.watch(myPostNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: userPosts.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('投稿がありません'));
          }
          return UserPage(postData: data, profile: data.first.userProfile);
        },
        error: (e, stackTrace) {
          return ErrorPage(
            error: e,
            retry: () => ref.refresh(myPostNotifierProvider),
          );
        },
        loading: () {
          return const LoadingIndicator();
        },
      ),
    );
  }
}
