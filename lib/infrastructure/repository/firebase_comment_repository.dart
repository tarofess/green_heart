import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseCommentRepository implements CommentRepository {
  @override
  Future<List<Comment>> getComments(String postId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection('comment')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true);
      final docSnapshot = await docRef.get();
      return docSnapshot.docs
          .map((doc) => Comment.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> addComment(Comment comment) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('comments').doc();
      await docRef.set(comment.toJson());
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの追加に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('comments').doc(commentId);
      await docRef.delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの削除に失敗しました。再度お試しください。');
    }
  }
}
