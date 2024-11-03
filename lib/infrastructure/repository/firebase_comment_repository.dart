import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseCommentRepository implements CommentRepository {
  @override
  Future<Comment> addComment(
    String uid,
    String postId,
    String content,
    String? parentCommentId,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('comment').doc();

      final comment = Comment(
        id: docRef.id,
        uid: uid,
        postId: postId,
        content: content,
        createdAt: DateTime.now(),
        parentCommentId: parentCommentId,
      );

      await docRef.set(comment.toJson());
      return comment;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの追加に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection('comment')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: false);
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
  Future<List<Comment>> getReplyComments(String parentCommentId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection('comment')
          .where('parentCommentId', isEqualTo: parentCommentId)
          .orderBy('createdAt', descending: false);
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
  Future<void> deleteComment(String commentId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('comment').doc(commentId);
      await docRef.delete();

      for (final replyComment in await getReplyComments(commentId)) {
        await deleteComment(replyComment.id);
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteAllCommentByUid(String uid) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef =
          firestore.collection('comment').where('uid', isEqualTo: uid);
      final docSnapshot = await docRef.get();
      for (final doc in docSnapshot.docs) {
        await deleteComment(doc.id);
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの削除に失敗しました。再度お試しください。');
    }
  }
}
