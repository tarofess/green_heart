import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow.freezed.dart';
part 'follow.g.dart';

@freezed
class Follow with _$Follow {
  const factory Follow({
    required String uid,
    required DateTime createdAt,
  }) = _Follow;

  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);
}
