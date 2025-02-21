import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/notification_scroll_state.dart';

class NotificationScrollStateNotifier
    extends Notifier<NotificationScrollState> {
  @override
  NotificationScrollState build() {
    return const NotificationScrollState(lastDocument: null);
  }

  void updateLastDocument(DocumentSnapshot? lastDocument) {
    state = state.copyWith(lastDocument: lastDocument);
  }

  void updateHasMore(bool hasMore) {
    state = state.copyWith(hasMore: hasMore);
  }

  void reset() {
    state = state.copyWith(lastDocument: null, hasMore: true);
  }
}

final notificationScrollStateNotifierProvider =
    NotifierProvider<NotificationScrollStateNotifier, NotificationScrollState>(
  () => NotificationScrollStateNotifier(),
);
