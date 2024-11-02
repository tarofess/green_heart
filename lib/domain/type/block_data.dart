import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/domain/type/profile.dart';

part 'block_data.freezed.dart';
part 'block_data.g.dart';

@freezed
class BlockData with _$BlockData {
  const factory BlockData({
    required Block block,
    required Profile? profile,
  }) = _BlockData;

  factory BlockData.fromJson(Map<String, dynamic> json) =>
      _$BlockDataFromJson(json);
}
