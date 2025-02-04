import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/usecase/block_get_usecase.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/usecase/like_check_usecase.dart';

class PostDataService {
  final BlockGetUsecase _blockGetUsecase;
  final LikeCheckUsecase _likeCheckUsecase;
  final String? _uid;

  PostDataService(this._blockGetUsecase, this._likeCheckUsecase, this._uid);

  Future<List<Post>> filterByBlock(List<Post> posts) async {
    if (_uid == null) {
      throw Exception('ユーザーが存在しないため投稿を取得できません。再度お試しください。');
    }

    final blockList = await _blockGetUsecase.execute(_uid);
    final targetUids = blockList.map((block) => block.uid).toSet();

    return posts.where((post) {
      if (targetUids.contains(post.uid)) return false;
      return true;
    }).toList();
  }

  Future<List<Post>> updateIsLikedStatus(List<Post> posts) async {
    final List<Post> updatedPosts = [];

    if (_uid == null) {
      throw Exception('ユーザーが存在しないため投稿を取得できません。再度お試しください。');
    }

    for (var post in posts) {
      final isLiked = await _likeCheckUsecase.execute(post.id, _uid);
      post = post.copyWith(isLiked: isLiked);
      updatedPosts.add(post);
    }

    return updatedPosts;
  }
}

final postDataServiceProvider = Provider((ref) => PostDataService(
      ref.read(blockGetUsecaseProvider),
      ref.read(likeCheckUsecaseProvider),
      ref.read(authStateProvider).value?.uid,
    ));
