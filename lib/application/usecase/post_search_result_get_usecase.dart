import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';
import 'package:green_heart/application/state/search_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/type/search_post_scroll_state.dart';

class PostSearchResultGetUsecase {
  final PostRepository _postRepository;
  final SearchPostNotifier _searchPostNotifier;

  PostSearchResultGetUsecase(this._postRepository, this._searchPostNotifier);

  Future<Result> execute(
    String query,
    String? uid,
    SearchPostScrollState searchPostScrollState,
    SearchPostScrollStateNotifier searchPostScrollStateNotifier,
  ) async {
    try {
      final posts = await _postRepository.getPostsBySearchWord(
        query,
        uid,
        searchPostScrollState,
        searchPostScrollStateNotifier,
      );

      _searchPostNotifier.setPostsBySearchWord(posts);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
