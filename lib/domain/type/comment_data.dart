import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/profile.dart';

part 'comment_data.freezed.dart';
part 'comment_data.g.dart';

@freezed
class CommentData with _$CommentData {
  const factory CommentData({
    required Comment comment,
    required Profile? profile,
    @Default([]) List<CommentData> replyComments,
  }) = _CommentData;

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
}
