import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';
import 'package:green_heart/application/state/search_post_scroll_state_notifier.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/di/post_di.dart';

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
          final ref = ProviderScope.containerOf(context);
          ref.read(searchPostScrollStateNotifierProvider.notifier).reset();
          ref.read(searchPostNotifierProvider.notifier).reset();
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
        final ref = ProviderScope.containerOf(context);
        ref.read(searchPostScrollStateNotifierProvider.notifier).reset();
        ref.read(searchPostNotifierProvider.notifier).reset();
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
    return PostSearchResults(query: query, uid: uid);
  }
}

class PostSearchResults extends HookConsumerWidget {
  const PostSearchResults({super.key, required this.query, this.uid});

  final String query;
  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final isLoadingMore = useState(false);
    final isSearching = useState(false);

    useEffect(() {
      void onScroll() async {
        scrollController.addListener(() {
          if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
            _loadMorePosts(context, ref, isLoadingMore);
          }
        });
      }

      _loadInitialPosts(context, ref, isSearching);
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    final searchPostState = ref.watch(searchPostNotifierProvider);
    final hasMore = ref.watch(searchPostScrollStateNotifierProvider).hasMore;

    if (isSearching.value) {
      return const LoadingIndicator(message: '検索中');
    }

    if (searchPostState.isEmpty && !isLoadingMore.value) {
      return const SizedBox();
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: searchPostState.length + 1,
      itemBuilder: (context, index) {
        if (index < searchPostState.length) {
          return Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 0.h),
            child: PostCard(
              key: ValueKey(searchPostState[index].post.id),
              postData: searchPostState[index],
            ),
          );
        } else if (hasMore && searchPostState.length >= 15) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _loadInitialPosts(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isSearching,
  ) async {
    isSearching.value = true;
    try {
      final searchPostScrollState = ref.read(
        searchPostScrollStateNotifierProvider,
      );

      await ref.read(postSearchResultGetUsecaseProvider).execute(
            query,
            uid,
            searchPostScrollState,
            ref.read(searchPostScrollStateNotifierProvider.notifier),
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('データの読み込みに失敗しました。再試行してください。'),
          ),
        );
      }
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> _loadMorePosts(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoadingMore,
  ) async {
    if (!isLoadingMore.value) {
      isLoadingMore.value = true;
      try {
        final searchPostScrollState = ref.read(
          searchPostScrollStateNotifierProvider,
        );

        await ref.read(postSearchResultGetUsecaseProvider).execute(
              query,
              uid,
              searchPostScrollState,
              ref.read(searchPostScrollStateNotifierProvider.notifier),
            );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('データの読み込みに失敗しました。再試行してください。'),
            ),
          );
        }
      } finally {
        isLoadingMore.value = false;
      }
    }
  }
}
