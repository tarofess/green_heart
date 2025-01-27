import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/usecase/block_get_usecase.dart';
import 'package:green_heart/application/usecase/comment_get_usecase.dart';
import 'package:green_heart/application/usecase/like_get_usecase.dart';
import 'package:green_heart/application/usecase/profile_get_usecase.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/profile.dart';

class PostDataService {
  final ProfileGetUsecase _profileGetUsecase;
  final LikeGetUsecase _likeGetUsecase;
  final CommentGetUsecase _commentGetUsecase;
  final BlockGetUsecase _blockGetUsecase;
  final String? _uid;

  PostDataService(
    this._profileGetUsecase,
    this._likeGetUsecase,
    this._commentGetUsecase,
    this._blockGetUsecase,
    this._uid,
  );

  Future<List<PostData>> createAndFilterPostDataList(List<Post> posts) async {
    final postData = await createPostDataList(posts);
    return filterByBlock(postData);
  }

  Future<List<PostData>> createPostDataList(List<Post> posts) async {
    final postDataFutures = posts.map((post) async {
      final results = await Future.wait([
        _profileGetUsecase.execute(post.uid),
        _likeGetUsecase.execute(post.id),
        _commentGetUsecase.execute(post.id),
      ]);

      final commentData = await _createCommentDataList(
        results[2] as List<Comment>,
      );

      return PostData(
        post: post,
        userProfile: results[0] as Profile,
        likes: results[1] as List<Like>,
        comments: commentData,
      );
    });

    return Future.wait(postDataFutures);
  }

  Future<List<CommentData>> _createCommentDataList(
    List<Comment> comments,
  ) async {
    final commentDataFutures = comments.map((comment) async {
      final profile = await _profileGetUsecase.execute(comment.uid);
      return CommentData(comment: comment, profile: profile);
    });

    return Future.wait(commentDataFutures);
  }

  Future<List<PostData>> filterByBlock(List<PostData> postData) async {
    if (_uid == null) {
      throw Exception('ユーザーが存在しないため投稿を取得できません。再度お試しください。');
    }

    final blockList = await _blockGetUsecase.execute(_uid);
    final blockedUids = blockList.map((block) => block.blockedUid).toSet();

    return postData.where((postData) {
      if (blockedUids.contains(postData.post.uid)) return false;

      final filteredComments = postData.comments
          .where(
              (commentData) => !blockedUids.contains(commentData.comment.uid))
          .toList();

      postData = postData.copyWith(comments: filteredComments);
      return true;
    }).toList();
  }
}

final postDataServiceProvider = Provider((ref) => PostDataService(
      ref.read(profileGetUsecaseProvider),
      ref.read(likeGetUsecaseProvider),
      ref.read(commentGetUsecaseProvider),
      ref.read(blockGetUsecaseProvider),
      ref.read(authStateProvider).value?.uid,
    ));
