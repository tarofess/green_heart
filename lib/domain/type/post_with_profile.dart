import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/profile.dart';

part 'post_with_profile.freezed.dart';

@freezed
class PostWithProfile with _$PostWithProfile {
  const factory PostWithProfile({
    required final Post post,
    required final Profile profile,
  }) = _PostWithProfile;
}
