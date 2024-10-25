import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseLikeRepository implements LikeRepository {
  @override
  Future<List<Like>> getLikes(String postId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection('like')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true);
      final docSnapshot = await docRef.get();
      final likes =
          docSnapshot.docs.map((doc) => Like.fromJson(doc.data())).toList();

      return likes;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> toggleLike(String postId, String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final ref = firestore.collection('like').doc('${postId}_$uid');
      final docSnapshot = await ref.get();

      if (docSnapshot.exists) {
        await ref.delete();
      } else {
        final like = Like(
          postId: postId,
          uid: uid,
          createdAt: DateTime.now(),
        );

        await ref.set(like.toJson());
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('いいねに失敗しました。再度お試しください。');
    }
  }
}
