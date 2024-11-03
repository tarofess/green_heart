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

/// @nodoc
mixin _$CommentData {
  Comment get comment => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;
  List<CommentData> get replyComments => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;

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
  $Res call(
      {Comment comment,
      Profile? profile,
      List<CommentData> replyComments,
      bool isMe});

  $CommentCopyWith<$Res> get comment;
  $ProfileCopyWith<$Res>? get profile;
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
    Object? profile = freezed,
    Object? replyComments = null,
    Object? isMe = null,
  }) {
    return _then(_value.copyWith(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as Comment,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      replyComments: null == replyComments
          ? _value.replyComments
          : replyComments // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$CommentDataImplCopyWith<$Res>
    implements $CommentDataCopyWith<$Res> {
  factory _$$CommentDataImplCopyWith(
          _$CommentDataImpl value, $Res Function(_$CommentDataImpl) then) =
      __$$CommentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Comment comment,
      Profile? profile,
      List<CommentData> replyComments,
      bool isMe});

  @override
  $CommentCopyWith<$Res> get comment;
  @override
  $ProfileCopyWith<$Res>? get profile;
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
    Object? profile = freezed,
    Object? replyComments = null,
    Object? isMe = null,
  }) {
    return _then(_$CommentDataImpl(
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as Comment,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      replyComments: null == replyComments
          ? _value._replyComments
          : replyComments // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CommentDataImpl implements _CommentData {
  const _$CommentDataImpl(
      {required this.comment,
      required this.profile,
      final List<CommentData> replyComments = const [],
      this.isMe = false})
      : _replyComments = replyComments;

  @override
  final Comment comment;
  @override
  final Profile? profile;
  final List<CommentData> _replyComments;
  @override
  @JsonKey()
  List<CommentData> get replyComments {
    if (_replyComments is EqualUnmodifiableListView) return _replyComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replyComments);
  }

  @override
  @JsonKey()
  final bool isMe;

  @override
  String toString() {
    return 'CommentData(comment: $comment, profile: $profile, replyComments: $replyComments, isMe: $isMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentDataImpl &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality()
                .equals(other._replyComments, _replyComments) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, comment, profile,
      const DeepCollectionEquality().hash(_replyComments), isMe);

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentDataImplCopyWith<_$CommentDataImpl> get copyWith =>
      __$$CommentDataImplCopyWithImpl<_$CommentDataImpl>(this, _$identity);
}

abstract class _CommentData implements CommentData {
  const factory _CommentData(
      {required final Comment comment,
      required final Profile? profile,
      final List<CommentData> replyComments,
      final bool isMe}) = _$CommentDataImpl;

  @override
  Comment get comment;
  @override
  Profile? get profile;
  @override
  List<CommentData> get replyComments;
  @override
  bool get isMe;

  /// Create a copy of CommentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentDataImplCopyWith<_$CommentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
