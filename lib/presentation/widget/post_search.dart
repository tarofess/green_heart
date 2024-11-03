import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';

class PostSearch extends SearchDelegate<String> {
  PostSearch({required this.postSearchType, this.uid});

  final PostSearchType postSearchType;
  final String? uid;

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
    return Consumer(
      builder: (context, ref, child) {
        final timelineState = postSearchType == PostSearchType.user
            ? ref.watch(userPostNotifierProvider(uid))
            : ref.watch(timelineNotifierProvider);
        return timelineState.when(
          data: (postDataList) {
            final results = postDataList
                .where((postData) => postData.post.content
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return PostCard(
                  key: ValueKey(results[index].post.id),
                  postData: results[index],
                );
              },
            );
          },
          loading: () => const LoadingIndicator(message: '読み込み中'),
          error: (_, __) => const Center(child: Text('エラーが発生しました')),
        );
      },
    );
  }
}

enum PostSearchType {
  user,
  timeline,
}
