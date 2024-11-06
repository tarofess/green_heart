// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FollowData {
  Follow get follow => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;

  /// Create a copy of FollowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowDataCopyWith<FollowData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowDataCopyWith<$Res> {
  factory $FollowDataCopyWith(
          FollowData value, $Res Function(FollowData) then) =
      _$FollowDataCopyWithImpl<$Res, FollowData>;
  @useResult
  $Res call({Follow follow, Profile? profile});

  $FollowCopyWith<$Res> get follow;
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$FollowDataCopyWithImpl<$Res, $Val extends FollowData>
    implements $FollowDataCopyWith<$Res> {
  _$FollowDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? follow = null,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      follow: null == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as Follow,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ) as $Val);
  }

  /// Create a copy of FollowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FollowCopyWith<$Res> get follow {
    return $FollowCopyWith<$Res>(_value.follow, (value) {
      return _then(_value.copyWith(follow: value) as $Val);
    });
  }

  /// Create a copy of FollowData
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
abstract class _$$FollowDataImplCopyWith<$Res>
    implements $FollowDataCopyWith<$Res> {
  factory _$$FollowDataImplCopyWith(
          _$FollowDataImpl value, $Res Function(_$FollowDataImpl) then) =
      __$$FollowDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Follow follow, Profile? profile});

  @override
  $FollowCopyWith<$Res> get follow;
  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$FollowDataImplCopyWithImpl<$Res>
    extends _$FollowDataCopyWithImpl<$Res, _$FollowDataImpl>
    implements _$$FollowDataImplCopyWith<$Res> {
  __$$FollowDataImplCopyWithImpl(
      _$FollowDataImpl _value, $Res Function(_$FollowDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of FollowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? follow = null,
    Object? profile = freezed,
  }) {
    return _then(_$FollowDataImpl(
      follow: null == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as Follow,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ));
  }
}

/// @nodoc

class _$FollowDataImpl implements _FollowData {
  const _$FollowDataImpl({required this.follow, required this.profile});

  @override
  final Follow follow;
  @override
  final Profile? profile;

  @override
  String toString() {
    return 'FollowData(follow: $follow, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowDataImpl &&
            (identical(other.follow, follow) || other.follow == follow) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, follow, profile);

  /// Create a copy of FollowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowDataImplCopyWith<_$FollowDataImpl> get copyWith =>
      __$$FollowDataImplCopyWithImpl<_$FollowDataImpl>(this, _$identity);
}

abstract class _FollowData implements FollowData {
  const factory _FollowData(
      {required final Follow follow,
      required final Profile? profile}) = _$FollowDataImpl;

  @override
  Follow get follow;
  @override
  Profile? get profile;

  /// Create a copy of FollowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowDataImplCopyWith<_$FollowDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
