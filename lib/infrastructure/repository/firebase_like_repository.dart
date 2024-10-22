import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_heart/application/exception/app_exception.dart';

import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseLikeRepository implements LikeRepository {
  @override
  Future<void> toggleLike(String postId, String userId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final postRef = firestore.collection('post').doc(postId);
      final likeRef = firestore.collection('like').doc('${postId}_$userId');

      return firestore.runTransaction((transaction) async {
        final likeDoc = await transaction.get(likeRef);

        if (likeDoc.exists) {
          transaction.delete(likeRef);
          transaction.update(postRef, {
            'likedUserIds': FieldValue.arrayRemove([userId])
          });
        } else {
          transaction.set(likeRef, {
            'postId': postId,
            'userId': userId,
            'createdAt': FieldValue.serverTimestamp(),
          });
          transaction.update(postRef, {
            'likedUserIds': FieldValue.arrayUnion([userId])
          });
        }
      });
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねに失敗しました。再度お試しください。');
    }
  }
}
