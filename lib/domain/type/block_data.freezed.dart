// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlockData {
  Block get block => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockDataCopyWith<BlockData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockDataCopyWith<$Res> {
  factory $BlockDataCopyWith(BlockData value, $Res Function(BlockData) then) =
      _$BlockDataCopyWithImpl<$Res, BlockData>;
  @useResult
  $Res call({Block block, Profile? profile});

  $BlockCopyWith<$Res> get block;
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$BlockDataCopyWithImpl<$Res, $Val extends BlockData>
    implements $BlockDataCopyWith<$Res> {
  _$BlockDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = null,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ) as $Val);
  }

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlockCopyWith<$Res> get block {
    return $BlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BlockDataImplCopyWith<$Res>
    implements $BlockDataCopyWith<$Res> {
  factory _$$BlockDataImplCopyWith(
          _$BlockDataImpl value, $Res Function(_$BlockDataImpl) then) =
      __$$BlockDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Block block, Profile? profile});

  @override
  $BlockCopyWith<$Res> get block;
  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$BlockDataImplCopyWithImpl<$Res>
    extends _$BlockDataCopyWithImpl<$Res, _$BlockDataImpl>
    implements _$$BlockDataImplCopyWith<$Res> {
  __$$BlockDataImplCopyWithImpl(
      _$BlockDataImpl _value, $Res Function(_$BlockDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = null,
    Object? profile = freezed,
  }) {
    return _then(_$BlockDataImpl(
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as Block,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ));
  }
}

/// @nodoc

class _$BlockDataImpl implements _BlockData {
  const _$BlockDataImpl({required this.block, required this.profile});

  @override
  final Block block;
  @override
  final Profile? profile;

  @override
  String toString() {
    return 'BlockData(block: $block, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockDataImpl &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, block, profile);

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockDataImplCopyWith<_$BlockDataImpl> get copyWith =>
      __$$BlockDataImplCopyWithImpl<_$BlockDataImpl>(this, _$identity);
}

abstract class _BlockData implements BlockData {
  const factory _BlockData(
      {required final Block block,
      required final Profile? profile}) = _$BlockDataImpl;

  @override
  Block get block;
  @override
  Profile? get profile;

  /// Create a copy of BlockData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockDataImplCopyWith<_$BlockDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
