// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_post_scroll_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserPostScrollState {
  DocumentSnapshot<Object?>? get lastDocument =>
      throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of UserPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPostScrollStateCopyWith<UserPostScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPostScrollStateCopyWith<$Res> {
  factory $UserPostScrollStateCopyWith(
          UserPostScrollState value, $Res Function(UserPostScrollState) then) =
      _$UserPostScrollStateCopyWithImpl<$Res, UserPostScrollState>;
  @useResult
  $Res call({DocumentSnapshot<Object?>? lastDocument, bool hasMore});
}

/// @nodoc
class _$UserPostScrollStateCopyWithImpl<$Res, $Val extends UserPostScrollState>
    implements $UserPostScrollStateCopyWith<$Res> {
  _$UserPostScrollStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastDocument = freezed,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      lastDocument: freezed == lastDocument
          ? _value.lastDocument
          : lastDocument // ignore: cast_nullable_to_non_nullable
              as DocumentSnapshot<Object?>?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPostScrollStateImplCopyWith<$Res>
    implements $UserPostScrollStateCopyWith<$Res> {
  factory _$$UserPostScrollStateImplCopyWith(_$UserPostScrollStateImpl value,
          $Res Function(_$UserPostScrollStateImpl) then) =
      __$$UserPostScrollStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DocumentSnapshot<Object?>? lastDocument, bool hasMore});
}

/// @nodoc
class __$$UserPostScrollStateImplCopyWithImpl<$Res>
    extends _$UserPostScrollStateCopyWithImpl<$Res, _$UserPostScrollStateImpl>
    implements _$$UserPostScrollStateImplCopyWith<$Res> {
  __$$UserPostScrollStateImplCopyWithImpl(_$UserPostScrollStateImpl _value,
      $Res Function(_$UserPostScrollStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastDocument = freezed,
    Object? hasMore = null,
  }) {
    return _then(_$UserPostScrollStateImpl(
      lastDocument: freezed == lastDocument
          ? _value.lastDocument
          : lastDocument // ignore: cast_nullable_to_non_nullable
              as DocumentSnapshot<Object?>?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserPostScrollStateImpl implements _UserPostScrollState {
  const _$UserPostScrollStateImpl(
      {required this.lastDocument, this.hasMore = true});

  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'UserPostScrollState(lastDocument: $lastDocument, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPostScrollStateImpl &&
            (identical(other.lastDocument, lastDocument) ||
                other.lastDocument == lastDocument) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lastDocument, hasMore);

  /// Create a copy of UserPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPostScrollStateImplCopyWith<_$UserPostScrollStateImpl> get copyWith =>
      __$$UserPostScrollStateImplCopyWithImpl<_$UserPostScrollStateImpl>(
          this, _$identity);
}

abstract class _UserPostScrollState implements UserPostScrollState {
  const factory _UserPostScrollState(
      {required final DocumentSnapshot<Object?>? lastDocument,
      final bool hasMore}) = _$UserPostScrollStateImpl;

  @override
  DocumentSnapshot<Object?>? get lastDocument;
  @override
  bool get hasMore;

  /// Create a copy of UserPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPostScrollStateImplCopyWith<_$UserPostScrollStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}