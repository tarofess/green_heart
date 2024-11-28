import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/search_post_scroll_state.dart';

class SearchPostScrollStateNotifier extends Notifier<SearchPostScrollState> {
  @override
  SearchPostScrollState build() {
    return const SearchPostScrollState();
  }

  void updateCurrentPage(int currentPage) {
    state = state.copyWith(currentPage: currentPage);
  }

  void updateHasMore(bool hasMore) {
    state = state.copyWith(hasMore: hasMore);
  }

  void reset() {
    state = state.copyWith(currentPage: 0, hasMore: true);
  }
}

final searchPostScrollStateNotifierProvider =
    NotifierProvider<SearchPostScrollStateNotifier, SearchPostScrollState>(
  () => SearchPostScrollStateNotifier(),
);
