// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommentData _$CommentDataFromJson(Map<String, dynamic> json) {
  return _CommentData.fromJson(json);
}

/// @nodoc
mixin _$CommentData {
  Comment get comment => throw _privateConstructorUsedError;
  Profile? get userProfile => throw _privateConstructorUsedError;

  /// Serializes this CommentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentDataCopyWith<CommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentDataCopyWith<$Res> {
  factory $CommentDataCopyWith(
          CommentData value, $Res Function(CommentData) then) =
      _$CommentDataCopyWithImpl<$Res, CommentData>;
  @useResult
  $Res call({Comment comment, Profile? userProfile});

  $CommentCopyWith<$Res> get comment;
  $ProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class _$CommentDataCopyWithImpl<$Res, $Val extends CommentData>
    implements $CommentDataCopyWith<$Res> {
  _$CommentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? userProfile = freezed,
  }) {
    return _then(_value.copyWith(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as Comment,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ) as $Val);
  }

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentCopyWith<$Res> get comment {
    return $CommentCopyWith<$Res>(_value.comment, (value) {
      return _then(_value.copyWith(comment: value) as $Val);
    });
  }

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.userProfile!, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentDataImplCopyWith<$Res>
    implements $CommentDataCopyWith<$Res> {
  factory _$$CommentDataImplCopyWith(
          _$CommentDataImpl value, $Res Function(_$CommentDataImpl) then) =
      __$$CommentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Comment comment, Profile? userProfile});

  @override
  $CommentCopyWith<$Res> get comment;
  @override
  $ProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class __$$CommentDataImplCopyWithImpl<$Res>
    extends _$CommentDataCopyWithImpl<$Res, _$CommentDataImpl>
    implements _$$CommentDataImplCopyWith<$Res> {
  __$$CommentDataImplCopyWithImpl(
      _$CommentDataImpl _value, $Res Function(_$CommentDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? userProfile = freezed,
  }) {
    return _then(_$CommentDataImpl(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as Comment,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentDataImpl implements _CommentData {
  const _$CommentDataImpl({required this.comment, required this.userProfile});

  factory _$CommentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentDataImplFromJson(json);

  @override
  final Comment comment;
  @override
  final Profile? userProfile;

  @override
  String toString() {
    return 'CommentData(comment: $comment, userProfile: $userProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentDataImpl &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, comment, userProfile);

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentDataImplCopyWith<_$CommentDataImpl> get copyWith =>
      __$$CommentDataImplCopyWithImpl<_$CommentDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentDataImplToJson(
      this,
    );
  }
}

abstract class _CommentData implements CommentData {
  const factory _CommentData(
      {required final Comment comment,
      required final Profile? userProfile}) = _$CommentDataImpl;

  factory _CommentData.fromJson(Map<String, dynamic> json) =
      _$CommentDataImpl.fromJson;

  @override
  Comment get comment;
  @override
  Profile? get userProfile;

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentDataImplCopyWith<_$CommentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}