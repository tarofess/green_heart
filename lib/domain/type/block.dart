import 'package:freezed_annotation/freezed_annotation.dart';

part 'block.freezed.dart';
part 'block.g.dart';

@freezed
class Block with _$Block {
  const factory Block({
    required String uid,
    required String blockedUid,
    required DateTime blockedAt,
  }) = _Block;

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
}
