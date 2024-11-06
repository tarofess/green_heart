import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseFollowRepository implements FollowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Follow> follow(String uid, String followingUid) async {
    try {
      final follow = Follow(
        uid: uid,
        followingUid: followingUid,
        createdAt: DateTime.now(),
      );

      final ref = _firestore.collection('follow').doc('${uid}_$followingUid');
      await ref.set(follow.toJson());
      return follow;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォローに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> unfollow(String uid, String followingUid) async {
    try {
      final ref = _firestore.collection('follow').doc('${uid}_$followingUid');
      await ref.delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー解除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> isFollowing(String uid, String followingUid) async {
    try {
      final ref = _firestore.collection('follow').doc('${uid}_$followingUid');
      final snapshot = await ref.get();
      return snapshot.exists;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<int> getFollowersCount(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('follow')
          .where('followingUid', isEqualTo: uid)
          .get();
      return snapshot.docs.length;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロワー数の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<int> getFollowingCount(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('follow')
          .where('uid', isEqualTo: uid)
          .get();
      return snapshot.docs.length;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー数の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Follow>> getFollowers(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('follow')
          .where('followingUid', isEqualTo: uid)
          .get();
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
          .get();
      return snapshot.docs.map((doc) => Follow.fromJson(doc.data())).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('フォロー情報の取得に失敗しました。再度お試しください。');
    }
  }
}
