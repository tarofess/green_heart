import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/user_post_scroll_state.dart';

class UserPostScrollStateNotifier
    extends FamilyNotifier<UserPostScrollState, String?> {
  @override
  UserPostScrollState build(String? arg) {
    return const UserPostScrollState(lastDocument: null);
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

final userPostScrollStateNotifierProvider = NotifierProviderFamily<
    UserPostScrollStateNotifier, UserPostScrollState, String?>(
  () => UserPostScrollStateNotifier(),
);
