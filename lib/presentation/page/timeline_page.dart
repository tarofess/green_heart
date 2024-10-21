import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/timeline_notifier_provider.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(timelineNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('みんなの投稿'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: timeline.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return PostCard(post: data[index]);
            },
          );
        },
        error: (e, stackTrace) {
          return ErrorPage(
            error: e,
            retry: () => ref.refresh(timelineNotifierProvider),
          );
        },
        loading: () {
          return const LoadingIndicator();
        },
      ),
    );
  }
}
