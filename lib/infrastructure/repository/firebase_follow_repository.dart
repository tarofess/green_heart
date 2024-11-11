import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseFollowRepository implements FollowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 10;

  @override
  Future<Follow> follow(String uid, String followingUid) async {
    final follow = Follow(
      uid: uid,
      followingUid: followingUid,
      createdAt: DateTime.now(),
    );
    final ref = _firestore.collection('follow').doc('${uid}_$followingUid');

    try {
      await ref
          .set(follow.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));
      return follow;
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return follow;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォローに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> unfollow(String uid, String followingUid) async {
    try {
      final ref = _firestore.collection('follow').doc('${uid}_$followingUid');
      await ref.delete().timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー解除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> isFollowing(String uid, String followingUid) async {
    try {
      final ref = _firestore.collection('follow').doc('${uid}_$followingUid');
      final snapshot =
          await ref.get().timeout(Duration(seconds: _timeoutSeconds));
      return snapshot.exists;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Follow>> getFollowers(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('follow')
          .where('followingUid', isEqualTo: uid)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));
      return snapshot.docs.map((doc) => Follow.fromJson(doc.data())).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロワー情報の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Follow>> getFollowing(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('follow')
          .where('uid', isEqualTo: uid)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));
      return snapshot.docs.map((doc) => Follow.fromJson(doc.data())).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteAllFollows(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('follow')
          .where('uid', isEqualTo: uid)
          .get();
      for (final doc in snapshot.docs) {
        await doc.reference
            .delete()
            .timeout(Duration(seconds: _timeoutSeconds));
      }

      final snapshot2 = await _firestore
          .collection('follow')
          .where('followingUid', isEqualTo: uid)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));
      for (final doc in snapshot2.docs) {
        await doc.reference.delete();
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の削除に失敗しました。再度お試しください。');
    }
  }
}
