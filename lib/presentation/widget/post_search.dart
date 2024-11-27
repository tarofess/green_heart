import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';

class PostSearch extends SearchDelegate<String> {
  PostSearch({this.uid});

  final String? uid;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
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
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return FutureBuilder(
          future: ref
              .read(searchPostNotifierProvider.notifier)
              .getPostsBySearchWord(query, uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator(message: '検索中');
            } else if (snapshot.hasError) {
              return const Center(child: Text('エラーが発生しました'));
            } else {
              final results = snapshot.data;
              if (results == null) return const SizedBox();

              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    key: ValueKey(results[index].post.id),
                    postData: results[index],
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
