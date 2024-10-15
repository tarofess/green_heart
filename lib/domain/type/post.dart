import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String uid,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(false) bool isLiked,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
