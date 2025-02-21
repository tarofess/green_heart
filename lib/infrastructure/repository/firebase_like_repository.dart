import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseLikeRepository implements LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 15;

  @override
  Future<List<Like>> getLikes(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('like')
          .where('uid', isEqualTo: uid)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      final likes =
          querySnapshot.docs.map((doc) => Like.fromJson(doc.data())).toList();

      return likes;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> toggleLike(
    String postId,
    String uid,
    String userName,
    String? userImage,
  ) async {
    try {
      final likeRef = _firestore
          .collection('post')
          .doc(postId)
          .collection('like')
          .doc(postId);

      final docSnapshot =
          await likeRef.get().timeout(Duration(seconds: _timeoutSeconds));

      if (docSnapshot.exists) {
        // すでにいいね済みなら削除
        await likeRef.delete().timeout(Duration(seconds: _timeoutSeconds));

        return false;
      } else {
        // いいねしていなければ追加
        final like = Like(
          postId: postId,
          uid: uid,
          userName: userName,
          userImage: userImage,
          createdAt: DateTime.now(),
        );
        await likeRef
            .set(like.toJson())
            .timeout(Duration(seconds: _timeoutSeconds));

        return true;
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねに失敗しました。再度お試しください。');
    }
  }
}
