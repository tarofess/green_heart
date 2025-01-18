import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/usecase/profile_get_usecase.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/result.dart';

class PostAddUsecase {
  final PostRepository _postRepository;
  final ProfileGetUsecase _profileGetUsecase;
  final UserPostNotifier _userPostNotifier;

  PostAddUsecase(
    this._postRepository,
    this._profileGetUsecase,
    this._userPostNotifier,
  );

  Future<Result> execute(
    String? uid,
    String content,
    List<String> paths,
    DateTime selectedDay,
  ) async {
    try {
      if (uid == null) {
        return const Failure('投稿ができません。アカウントがログアウトされている可能性があります。');
      }
      final imageUrls = await _postRepository.uploadImages(uid, paths);
      final newPost = await _postRepository.addPost(
        uid,
        content,
        imageUrls,
        selectedDay,
      );

      final profile = await _profileGetUsecase.execute(uid);

      final newPostData = PostData(
        post: newPost,
        userProfile: profile,
        likes: [],
        comments: [],
      );

      _userPostNotifier.addPost(newPostData);

      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
