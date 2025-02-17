import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/app_exception.dart';

class FirebaseCommentRepository implements CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 15;

  @override
  Future<Comment> addComment(
    String uid,
    String postId,
    String content,
    String? parentCommentId,
    String? replyTargetUid,
    String userName,
    String? userImage,
  ) async {
    final commentRef =
        _firestore.collection('post').doc(postId).collection('comment').doc();

    final comment = Comment(
      id: commentRef.id,
      uid: uid,
      content: content,
      parentCommentId: parentCommentId,
      replyTargetUid: replyTargetUid,
      userName: userName,
      userImage: userImage,
      createdAt: DateTime.now(),
    );

    try {
      await commentRef
          .set(comment.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));

      return comment;
    } catch (e, stackTrace) {
      if (e is TimeoutException) return comment;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの追加に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    try {
      final docRef = _firestore
          .collection('post')
          .doc(postId)
          .collection('comment')
          .orderBy('createdAt', descending: false);

      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));

      return docSnapshot.docs
          .map((doc) => Comment.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<int> deleteComment(String postId, String commentId) async {
    try {
      final ref = _firestore
          .collection('post')
          .doc(postId)
          .collection('comment')
          .doc(commentId);

      final batch = _firestore.batch();
      batch.delete(ref);

      // 返信コメントの削除
      final replyComments = await _getReplyComments(postId, commentId);
      for (final replyComment in replyComments) {
        final replyRef = _firestore
            .collection('post')
            .doc(postId)
            .collection('comment')
            .doc(replyComment.id);
        batch.delete(replyRef);
      }

      await batch.commit();

      // 投稿の状態管理コメント数を適切な数に更新するために使われる変数
      final deletedComentCount = replyComments.length + 1;

      return deletedComentCount;
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return 0;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの削除に失敗しました。再度お試しください。');
    }
  }

  Future<List<Comment>> _getReplyComments(
    String postId,
    String parentCommentId,
  ) async {
    try {
      final docRef = _firestore
          .collection('post')
          .doc(postId)
          .collection('comment')
          .where('parentCommentId', isEqualTo: parentCommentId)
          .orderBy('createdAt', descending: false);

      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));

      return docSnapshot.docs
          .map((doc) => Comment.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('コメントの取得に失敗しました。再度お試しください。');
    }
  }
}
