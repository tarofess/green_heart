import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/user_post_scroll_state.dart';

class PostGetUsecase {
  final PostRepository _postRepository;

  PostGetUsecase(this._postRepository);

  Future<List<Post>> execute(
    String uid,
    UserPostScrollState userPostScrollState,
    UserPostScrollStateNotifier userPostScrollStateNotifier,
  ) async {
    return await _postRepository.getDiaryPostsByUid(
      uid,
      userPostScrollState,
      userPostScrollStateNotifier,
    );
  }
}
