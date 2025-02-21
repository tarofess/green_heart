import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/domain/type/notification.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/state/notification_scroll_state_notifier.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 10;
  final int _pageSize = 15;

  FirebaseNotificationRepository(this._ref);

  @override
  Future<List<Notification>> getNotifications(String uid) async {
    final notificationScrollState =
        _ref.read(notificationScrollStateNotifierProvider);
    final notificationScrollStateNotifier =
        _ref.read(notificationScrollStateNotifierProvider.notifier);

    try {
      if (!notificationScrollState.hasMore) return [];

      Query query = _firestore
          .collection('profile')
          .doc(uid)
          .collection('notification')
          .orderBy('createdAt', descending: true)
          .limit(_pageSize);

      if (notificationScrollState.lastDocument != null) {
        query = query.startAfterDocument(notificationScrollState.lastDocument!);
      }

      final querySnapshot =
          await query.get().timeout(Duration(seconds: _timeoutSeconds));

      if (querySnapshot.docs.isEmpty || querySnapshot.docs.length < _pageSize) {
        notificationScrollStateNotifier.updateHasMore(false);
      }

      if (querySnapshot.docs.isNotEmpty) {
        notificationScrollStateNotifier
            .updateLastDocument(querySnapshot.docs.last);
      }

      return querySnapshot.docs
          .map((doc) =>
              Notification.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> markAsRead(Notification notification) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(notification.receiverUid)
          .collection('notification')
          .where('id', isEqualTo: notification.id)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isNotEmpty) {
        final docRef = snapshot.docs.first.reference;
        await docRef.update({'isRead': true});
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<void> deleteById(String notificationId, String uid) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notification')
          .where('id', isEqualTo: notificationId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isNotEmpty) {
        final docRef = snapshot.docs.first.reference;
        await docRef.delete();
      }
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知の削除に失敗しました。再度お試しください。');
    }
  }
}
