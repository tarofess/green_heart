import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';

class PostSearch extends SearchDelegate<String> {
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
        final timelineState = ref.watch(timelineNotifierProvider);
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
          loading: () => const LoadingIndicator(),
          error: (_, __) => const Center(child: Text('エラーが発生しました')),
        );
      },
    );
  }
}
