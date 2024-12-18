import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String uid,
    required String name,
    required DateTime? birthday,
    required String bio,
    String? imageUrl,
    @Default(1) int status,
    DateTime? createdAt,
    required DateTime updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
