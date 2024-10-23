import 'package:flutter/material.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/profile.dart';

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
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearch(timelinePosts: timeline),
              );
            },
          )
        ],
      ),
      body: timeline.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              await ref.refresh(timelineNotifierProvider.future);
            },
            child: ListView.builder(
              itemCount: data.$1.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: data.$1[index],
                  profile: data.$2[index],
                  comments: data.$3[index],
                );
              },
            ),
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

class PostSearch extends SearchDelegate<String> {
  final AsyncValue<(List<Post>, List<Profile?>, List<List<Comment>>)>
      timelinePosts;

  PostSearch({required this.timelinePosts});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return timelinePosts.when(
      data: (data) {
        final results = data.$1
            .where((post) =>
                post.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return PostCard(
              post: results[index],
              profile: data.$2[index],
              comments: data.$3[index],
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (_, __) => const Center(child: Text('エラーが発生しました')),
    );
  }
}
