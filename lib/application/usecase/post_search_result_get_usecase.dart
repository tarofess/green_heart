import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/search_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/search_post_scroll_state.dart';

class PostSearchResultGetUsecase {
  final PostRepository _postRepository;

  PostSearchResultGetUsecase(this._postRepository);

  Future<List<Post>> execute(
    String query,
    String? uid,
    SearchPostScrollState searchPostScrollState,
    SearchPostScrollStateNotifier searchPostScrollStateNotifier,
  ) async {
    return await _postRepository.getPostsBySearchWord(
      query,
      uid,
      searchPostScrollState,
      searchPostScrollStateNotifier,
    );
  }
}
