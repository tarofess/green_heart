import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseLikeRepository implements LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 15;

  @override
  Future<void> toggleLike(String postId, String uid) async {
    try {
      final ref = _firestore.collection('like').doc('${postId}_$uid');
      final docSnapshot =
          await ref.get().timeout(Duration(seconds: _timeoutSeconds));

      if (docSnapshot.exists) {
        await ref.delete().timeout(Duration(seconds: _timeoutSeconds));
      } else {
        final like = Like(
          postId: postId,
          uid: uid,
          createdAt: DateTime.now(),
        );

        await ref
            .set(like.toJson())
            .timeout(Duration(seconds: _timeoutSeconds));
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Like>> getLikes(String postId) async {
    try {
      final docRef = _firestore
          .collection('like')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true);
      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));
      final likes =
          docSnapshot.docs.map((doc) => Like.fromJson(doc.data())).toList();

      return likes;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteAllLikesByUid(String uid) async {
    try {
      final docRef = _firestore.collection('like').where('uid', isEqualTo: uid);
      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));

      final batch = _firestore.batch();
      for (var doc in docSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit().timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねの削除に失敗しました。再度お試しください。');
    }
  }
}
