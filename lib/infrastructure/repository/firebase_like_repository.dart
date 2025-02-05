import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseLikeRepository implements LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 15;

  @override
  Future<bool> toggleLike(String postId, String uid) async {
    try {
      final likeRef =
          _firestore.collection('post').doc(postId).collection('like').doc(uid);
      final docSnapshot =
          await likeRef.get().timeout(Duration(seconds: _timeoutSeconds));

      if (docSnapshot.exists) {
        // すでにいいね済みなら削除
        await likeRef.delete().timeout(Duration(seconds: _timeoutSeconds));

        return false;
      } else {
        // いいねしていなければ追加
        final like = Like(uid: uid, createdAt: DateTime.now());
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

  @override
  Future<bool> checkIfLiked(String postId, String uid) async {
    try {
      final ref =
          _firestore.collection('post').doc(postId).collection('like').doc(uid);
      final docSnapshot =
          await ref.get().timeout(Duration(seconds: _timeoutSeconds));

      return docSnapshot.exists;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねの取得に失敗しました。再度お試しください。');
    }
  }
}
