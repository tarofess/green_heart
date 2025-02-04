import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String uid,
    required String content,
    @Default([]) List<String> imageUrls,
    required String userName,
    required String? userImage,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    required DateTime releaseDate,
    required DateTime createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isLiked,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
