// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserPageState {
  Profile? get profile => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;

  /// Create a copy of UserPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPageStateCopyWith<UserPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPageStateCopyWith<$Res> {
  factory $UserPageStateCopyWith(
          UserPageState value, $Res Function(UserPageState) then) =
      _$UserPageStateCopyWithImpl<$Res, UserPageState>;
  @useResult
  $Res call({Profile? profile, bool isFollowing, bool isBlocked});

  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$UserPageStateCopyWithImpl<$Res, $Val extends UserPageState>
    implements $UserPageStateCopyWith<$Res> {
  _$UserPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? isFollowing = null,
    Object? isBlocked = null,
  }) {
    return _then(_value.copyWith(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of UserPageState
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
abstract class _$$UserPageStateImplCopyWith<$Res>
    implements $UserPageStateCopyWith<$Res> {
  factory _$$UserPageStateImplCopyWith(
          _$UserPageStateImpl value, $Res Function(_$UserPageStateImpl) then) =
      __$$UserPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Profile? profile, bool isFollowing, bool isBlocked});

  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$UserPageStateImplCopyWithImpl<$Res>
    extends _$UserPageStateCopyWithImpl<$Res, _$UserPageStateImpl>
    implements _$$UserPageStateImplCopyWith<$Res> {
  __$$UserPageStateImplCopyWithImpl(
      _$UserPageStateImpl _value, $Res Function(_$UserPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? isFollowing = null,
    Object? isBlocked = null,
  }) {
    return _then(_$UserPageStateImpl(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserPageStateImpl implements _UserPageState {
  const _$UserPageStateImpl(
      {required this.profile,
      this.isFollowing = false,
      this.isBlocked = false});

  @override
  final Profile? profile;
  @override
  @JsonKey()
  final bool isFollowing;
  @override
  @JsonKey()
  final bool isBlocked;

  @override
  String toString() {
    return 'UserPageState(profile: $profile, isFollowing: $isFollowing, isBlocked: $isBlocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPageStateImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile, isFollowing, isBlocked);

  /// Create a copy of UserPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPageStateImplCopyWith<_$UserPageStateImpl> get copyWith =>
      __$$UserPageStateImplCopyWithImpl<_$UserPageStateImpl>(this, _$identity);
}

abstract class _UserPageState implements UserPageState {
  const factory _UserPageState(
      {required final Profile? profile,
      final bool isFollowing,
      final bool isBlocked}) = _$UserPageStateImpl;

  @override
  Profile? get profile;
  @override
  bool get isFollowing;
  @override
  bool get isBlocked;

  /// Create a copy of UserPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPageStateImplCopyWith<_$UserPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
