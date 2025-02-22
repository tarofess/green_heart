import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/usecase/profile_get_usecase.dart';
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

      final profile = await _profileGetUsecase.execute(uid);
      final uploadedRecords = await _postRepository.uploadImages(uid, paths);
      final postId = uploadedRecords.$1;
      final imageUrls = uploadedRecords.$2;

      final newPost = await _postRepository.addPost(
        postId,
        uid,
        content,
        imageUrls,
        profile?.name ?? '',
        profile?.imageUrl,
        selectedDay,
      );

      _userPostNotifier.addPost(newPost);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
