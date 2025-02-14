import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/domain/type/notification.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 10;

  @override
  Future<List<Notification>> getNotifications(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notification')
          .orderBy('createdAt', descending: true)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      final notifications = snapshot.docs.map((doc) {
        return Notification.fromJson(doc.data());
      }).toList();

      return notifications;
    } catch (e) {
      return [];
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
}
