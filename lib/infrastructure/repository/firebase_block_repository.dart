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
  Future<void> addBlock(String uid, Block block) async {
    try {
      final ref = _firestore
          .collection('profile')
          .doc(uid)
          .collection('block')
          .doc(block.targetUid);

      await ref.set(block.toJson()).timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストへの追加に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Block>> getBlockByUid(String uid) async {
    try {
      final ref = _firestore.collection('profile').doc(uid).collection('block');

      final querySnapshot =
          await ref.get().timeout(Duration(seconds: _timeoutSeconds));

      return querySnapshot.docs
          .map((doc) => Block.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Block>> getBlockedByOther(String uid) async {
    try {
      final ref = _firestore
          .collectionGroup('block')
          .where('targetUid', isEqualTo: uid);

      final querySnapshot =
          await ref.get().timeout(Duration(seconds: _timeoutSeconds));

      return querySnapshot.docs
          .map((doc) => Block.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteBlockByUid(String uid, String targetUid) async {
    try {
      final ref = _firestore
          .collection('profile')
          .doc(uid)
          .collection('block')
          .doc(targetUid);

      await ref.delete().timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> checkIfBlocked(String uid, String targetUid) async {
    try {
      final ref = _firestore
          .collection('profile')
          .doc(uid)
          .collection('block')
          .doc(targetUid);

      final docSnapshot =
          await ref.get().timeout(Duration(seconds: _timeoutSeconds));

      return docSnapshot.exists;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ブロックリストの確認に失敗しました。再度お試しください。');
    }
  }
}
