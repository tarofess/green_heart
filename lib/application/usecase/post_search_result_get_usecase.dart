import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class PostSearchResultGetUsecase {
  final PostRepository _postRepository;
  final SearchPostNotifier _searchPostNotifier;

  PostSearchResultGetUsecase(this._postRepository, this._searchPostNotifier);

  Future<Result> execute(String query, String? uid) async {
    try {
      final posts = await _postRepository.getPostsBySearchWord(query, uid);

      _searchPostNotifier.setPostsBySearchWord(posts);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
