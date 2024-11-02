import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/timeline_scroll_state.dart';

class TimelineScrollStateNotifier extends Notifier<TimeLineScrollState> {
  @override
  TimeLineScrollState build() {
    return const TimeLineScrollState(lastDocument: null);
  }

  void updateLastDocument(DocumentSnapshot? lastDocument) {
    state = state.copyWith(lastDocument: lastDocument);
  }

  void updateHasMore(bool hasMore) {
    state = state.copyWith(hasMore: hasMore);
  }
}

final timelineScrollStateNotifierProvider =
    NotifierProvider<TimelineScrollStateNotifier, TimeLineScrollState>(
  () => TimelineScrollStateNotifier(),
);
