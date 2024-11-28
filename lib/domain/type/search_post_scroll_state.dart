import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_post_scroll_state.freezed.dart';

@freezed
class SearchPostScrollState with _$SearchPostScrollState {
  const factory SearchPostScrollState({
    @Default(0) int currentPage,
    @Default(true) bool hasMore,
  }) = _SearchPostScrollState;
}
