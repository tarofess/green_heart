import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_scroll_state.freezed.dart';

@freezed
class NotificationScrollState with _$NotificationScrollState {
  const factory NotificationScrollState({
    required DocumentSnapshot? lastDocument,
    @Default(true) bool hasMore,
  }) = _NotificationScrollState;
}
