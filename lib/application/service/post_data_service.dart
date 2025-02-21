import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/usecase/like_check_usecase.dart';
import 'package:green_heart/application/usecase/block_get_by_other_usecase.dart';
import 'package:green_heart/domain/type/block.dart';

class PostDataService {
  final BlockGetByOtherUseCase _blockGetByOtherUsecase;
  final LikeCheckUsecase _likeCheckUsecase;
  final String? _myUid;

  PostDataService(
    this._blockGetByOtherUsecase,
    this._likeCheckUsecase,
    this._myUid,
  );

  Future<List<Post>> filterByBlock(
    List<Post> posts,
    AsyncValue<List<Block>> blockState,
  ) async {
    if (_myUid == null) {
      throw Exception('ユーザーが存在しないため投稿を取得できません。再度お試しください。');
    }

    // 自分がブロックしているユーザーのuidを取得
    final myBlockList = blockState.when(
      data: (blocks) => blocks,
      loading: () => <Block>[],
      error: (error, _) => <Block>[],
    );
    final blockedUserIds = myBlockList.map((block) => block.targetUid).toSet();

    // 自分をブロックしているユーザーのuidを取得
    final blockMeList = await _blockGetByOtherUsecase.execute(_myUid);
    final blockMeUserIds = blockMeList.map((block) => block.uid).toSet();

    // 上記二つのuidを合算
    final allFilteredUserIds = blockedUserIds.union(blockMeUserIds);

    // タイムライン投稿の中から、上記ユーザーの投稿を除外
    return posts
        .where((post) => !allFilteredUserIds.contains(post.uid))
        .toList();
  }

  Future<List<Post>> updateIsLikedStatus(List<Post> posts) async {
    final List<Post> updatedPosts = [];

    if (_myUid == null) {
      throw Exception('ユーザーが存在しないため投稿を取得できません。再度お試しください。');
    }

    for (var post in posts) {
      final isLiked = await _likeCheckUsecase.execute(post.id, _myUid);
      post = post.copyWith(isLiked: isLiked);
      updatedPosts.add(post);
    }

    return updatedPosts;
  }
}
