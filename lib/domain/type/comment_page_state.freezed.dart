// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommentPageState {
  bool get isReplying => throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;
  String? get replyTargetUid => throw _privateConstructorUsedError;
  String? get replyTargetUserName => throw _privateConstructorUsedError;

  /// Create a copy of CommentPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentPageStateCopyWith<CommentPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentPageStateCopyWith<$Res> {
  factory $CommentPageStateCopyWith(
          CommentPageState value, $Res Function(CommentPageState) then) =
      _$CommentPageStateCopyWithImpl<$Res, CommentPageState>;
  @useResult
  $Res call(
      {bool isReplying,
      String? parentCommentId,
      String? replyTargetUid,
      String? replyTargetUserName});
}

/// @nodoc
class _$CommentPageStateCopyWithImpl<$Res, $Val extends CommentPageState>
    implements $CommentPageStateCopyWith<$Res> {
  _$CommentPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReplying = null,
    Object? parentCommentId = freezed,
    Object? replyTargetUid = freezed,
    Object? replyTargetUserName = freezed,
  }) {
    return _then(_value.copyWith(
      isReplying: null == isReplying
          ? _value.isReplying
          : isReplying // ignore: cast_nullable_to_non_nullable
              as bool,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyTargetUid: freezed == replyTargetUid
          ? _value.replyTargetUid
          : replyTargetUid // ignore: cast_nullable_to_non_nullable
              as String?,
      replyTargetUserName: freezed == replyTargetUserName
          ? _value.replyTargetUserName
          : replyTargetUserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentPageStateImplCopyWith<$Res>
    implements $CommentPageStateCopyWith<$Res> {
  factory _$$CommentPageStateImplCopyWith(_$CommentPageStateImpl value,
          $Res Function(_$CommentPageStateImpl) then) =
      __$$CommentPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isReplying,
      String? parentCommentId,
      String? replyTargetUid,
      String? replyTargetUserName});
}

/// @nodoc
class __$$CommentPageStateImplCopyWithImpl<$Res>
    extends _$CommentPageStateCopyWithImpl<$Res, _$CommentPageStateImpl>
    implements _$$CommentPageStateImplCopyWith<$Res> {
  __$$CommentPageStateImplCopyWithImpl(_$CommentPageStateImpl _value,
      $Res Function(_$CommentPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReplying = null,
    Object? parentCommentId = freezed,
    Object? replyTargetUid = freezed,
    Object? replyTargetUserName = freezed,
  }) {
    return _then(_$CommentPageStateImpl(
      isReplying: null == isReplying
          ? _value.isReplying
          : isReplying // ignore: cast_nullable_to_non_nullable
              as bool,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyTargetUid: freezed == replyTargetUid
          ? _value.replyTargetUid
          : replyTargetUid // ignore: cast_nullable_to_non_nullable
              as String?,
      replyTargetUserName: freezed == replyTargetUserName
          ? _value.replyTargetUserName
          : replyTargetUserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CommentPageStateImpl implements _CommentPageState {
  const _$CommentPageStateImpl(
      {this.isReplying = false,
      this.parentCommentId,
      this.replyTargetUid,
      this.replyTargetUserName});

  @override
  @JsonKey()
  final bool isReplying;
  @override
  final String? parentCommentId;
  @override
  final String? replyTargetUid;
  @override
  final String? replyTargetUserName;

  @override
  String toString() {
    return 'CommentPageState(isReplying: $isReplying, parentCommentId: $parentCommentId, replyTargetUid: $replyTargetUid, replyTargetUserName: $replyTargetUserName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentPageStateImpl &&
            (identical(other.isReplying, isReplying) ||
                other.isReplying == isReplying) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.replyTargetUid, replyTargetUid) ||
                other.replyTargetUid == replyTargetUid) &&
            (identical(other.replyTargetUserName, replyTargetUserName) ||
                other.replyTargetUserName == replyTargetUserName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isReplying, parentCommentId,
      replyTargetUid, replyTargetUserName);

  /// Create a copy of CommentPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentPageStateImplCopyWith<_$CommentPageStateImpl> get copyWith =>
      __$$CommentPageStateImplCopyWithImpl<_$CommentPageStateImpl>(
          this, _$identity);
}

abstract class _CommentPageState implements CommentPageState {
  const factory _CommentPageState(
      {final bool isReplying,
      final String? parentCommentId,
      final String? replyTargetUid,
      final String? replyTargetUserName}) = _$CommentPageStateImpl;

  @override
  bool get isReplying;
  @override
  String? get parentCommentId;
  @override
  String? get replyTargetUid;
  @override
  String? get replyTargetUserName;

  /// Create a copy of CommentPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentPageStateImplCopyWith<_$CommentPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
