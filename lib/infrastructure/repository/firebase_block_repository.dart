import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseBlockRepository implements BlockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 10;

  @override
  Future<void> addBlock(Block block) async {
    try {
      final ref = _firestore.collection('block').doc();
      await ref.set(block.toJson()).timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストへの追加に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Block>> getBlockByUid(String uid) async {
    try {
      final docRef =
          _firestore.collection('block').where('uid', isEqualTo: uid);
      final docSnapshot = await docRef.get().timeout(
            Duration(seconds: _timeoutSeconds),
          );
      return docSnapshot.docs.map((doc) => Block.fromJson(doc.data())).toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteBlockByUid(String uid, String blockedUid) async {
    try {
      final docRef = _firestore
          .collection('block')
          .where('uid', isEqualTo: uid)
          .where('blockedUid', isEqualTo: blockedUid);
      final docSnapshot = await docRef.get().timeout(
            Duration(seconds: _timeoutSeconds),
          );
      for (final doc in docSnapshot.docs) {
        await doc.reference
            .delete()
            .timeout(Duration(seconds: _timeoutSeconds));
      }
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteAllBlockByUid(String uid) async {
    try {
      final docRef =
          _firestore.collection('block').where('uid', isEqualTo: uid);
      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));
      for (final doc in docSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> checkIfBlocked(String currentUserId, String targetUserId) async {
    final query = _firestore
        .collection('block')
        .where('uid', isEqualTo: currentUserId)
        .where('blockedUid', isEqualTo: targetUserId);
    final snapshot =
        await query.get().timeout(Duration(seconds: _timeoutSeconds));
    return snapshot.docs.isNotEmpty;
  }
}
