import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/profile.dart';

part 'post_data.freezed.dart';
part 'post_data.g.dart';

@freezed
class PostData with _$PostData {
  const factory PostData({
    required Post post,
    required Profile? userProfile,
    required List<CommentData> comments,
    required int likeCount,
  }) = _PostData;

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);
}
