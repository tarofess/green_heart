// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_with_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostWithProfile {
  Post get post => throw _privateConstructorUsedError;
  Profile get profile => throw _privateConstructorUsedError;

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostWithProfileCopyWith<PostWithProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostWithProfileCopyWith<$Res> {
  factory $PostWithProfileCopyWith(
          PostWithProfile value, $Res Function(PostWithProfile) then) =
      _$PostWithProfileCopyWithImpl<$Res, PostWithProfile>;
  @useResult
  $Res call({Post post, Profile profile});

  $PostCopyWith<$Res> get post;
  $ProfileCopyWith<$Res> get profile;
}

/// @nodoc
class _$PostWithProfileCopyWithImpl<$Res, $Val extends PostWithProfile>
    implements $PostWithProfileCopyWith<$Res> {
  _$PostWithProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? post = null,
    Object? profile = null,
  }) {
    return _then(_value.copyWith(
      post: null == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
    ) as $Val);
  }

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res> get post {
    return $PostCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value) as $Val);
    });
  }

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get profile {
    return $ProfileCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostWithProfileImplCopyWith<$Res>
    implements $PostWithProfileCopyWith<$Res> {
  factory _$$PostWithProfileImplCopyWith(_$PostWithProfileImpl value,
          $Res Function(_$PostWithProfileImpl) then) =
      __$$PostWithProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Post post, Profile profile});

  @override
  $PostCopyWith<$Res> get post;
  @override
  $ProfileCopyWith<$Res> get profile;
}

/// @nodoc
class __$$PostWithProfileImplCopyWithImpl<$Res>
    extends _$PostWithProfileCopyWithImpl<$Res, _$PostWithProfileImpl>
    implements _$$PostWithProfileImplCopyWith<$Res> {
  __$$PostWithProfileImplCopyWithImpl(
      _$PostWithProfileImpl _value, $Res Function(_$PostWithProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? post = null,
    Object? profile = null,
  }) {
    return _then(_$PostWithProfileImpl(
      post: null == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
    ));
  }
}

/// @nodoc

class _$PostWithProfileImpl implements _PostWithProfile {
  const _$PostWithProfileImpl({required this.post, required this.profile});

  @override
  final Post post;
  @override
  final Profile profile;

  @override
  String toString() {
    return 'PostWithProfile(post: $post, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostWithProfileImpl &&
            (identical(other.post, post) || other.post == post) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, post, profile);

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostWithProfileImplCopyWith<_$PostWithProfileImpl> get copyWith =>
      __$$PostWithProfileImplCopyWithImpl<_$PostWithProfileImpl>(
          this, _$identity);
}

abstract class _PostWithProfile implements PostWithProfile {
  const factory _PostWithProfile(
      {required final Post post,
      required final Profile profile}) = _$PostWithProfileImpl;

  @override
  Post get post;
  @override
  Profile get profile;

  /// Create a copy of PostWithProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostWithProfileImplCopyWith<_$PostWithProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
