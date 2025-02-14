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
  Future<void> follow(
    String uid,
    String targetUid,
    Follow follow,
    Follow follower,
  ) async {
    // 2か所に保存するための参照を作成
    final followingRef = _firestore
        .collection('profile')
        .doc(uid)
        .collection('follow')
        .doc(targetUid);
    final followerRef = _firestore
        .collection('profile')
        .doc(targetUid)
        .collection('follower')
        .doc(uid);

    try {
      await Future.wait([
        followingRef
            .set(follow.toJson())
            .timeout(Duration(seconds: _timeoutSeconds)),
        followerRef
            .set(follower.toJson())
            .timeout(Duration(seconds: _timeoutSeconds)),
      ]);
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォローに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> unfollow(String uid, String targetUid) async {
    final followingRef = _firestore
        .collection('profile')
        .doc(uid)
        .collection('follow')
        .doc(targetUid);
    final followerRef = _firestore
        .collection('profile')
        .doc(targetUid)
        .collection('follower')
        .doc(uid);

    try {
      await Future.wait([
        followingRef.delete().timeout(Duration(seconds: _timeoutSeconds)),
        followerRef.delete().timeout(Duration(seconds: _timeoutSeconds)),
      ]);
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー解除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> isFollowing(String uid, String targetUid) async {
    try {
      final doc = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('follow')
          .doc(targetUid)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      return doc.exists;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Follow>> getFollowers(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('follower')
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      return snapshot.docs.map((doc) => Follow.fromJson(doc.data())).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロワー情報の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Follow>> getFollows(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('follow')
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      return snapshot.docs.map((doc) => Follow.fromJson(doc.data())).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の取得に失敗しました。再度お試しください。');
    }
  }
}
