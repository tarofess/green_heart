import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_post_scroll_state.freezed.dart';

@freezed
class UserPostScrollState with _$UserPostScrollState {
  const factory UserPostScrollState({
    required DocumentSnapshot? lastDocument,
    @Default(true) bool hasMore,
  }) = _UserPostScrollState;
}
