import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:green_heart/domain/type/follow.dart';
import 'package:green_heart/domain/type/profile.dart';

part 'follow_data.freezed.dart';

@freezed
class FollowData with _$FollowData {
  const factory FollowData({
    required Follow follow,
    required Profile? profile,
  }) = _FollowData;
}
