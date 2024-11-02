import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'timeline_scroll_state.freezed.dart';

@freezed
class TimeLineScrollState with _$TimeLineScrollState {
  const factory TimeLineScrollState({
    required DocumentSnapshot? lastDocument,
    @Default(true) bool hasMore,
  }) = _TimeLineScrollState;
}
