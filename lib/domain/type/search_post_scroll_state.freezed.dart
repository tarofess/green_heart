// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_post_scroll_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchPostScrollState {
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of SearchPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchPostScrollStateCopyWith<SearchPostScrollState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchPostScrollStateCopyWith<$Res> {
  factory $SearchPostScrollStateCopyWith(SearchPostScrollState value,
          $Res Function(SearchPostScrollState) then) =
      _$SearchPostScrollStateCopyWithImpl<$Res, SearchPostScrollState>;
  @useResult
  $Res call({int currentPage, bool hasMore});
}

/// @nodoc
class _$SearchPostScrollStateCopyWithImpl<$Res,
        $Val extends SearchPostScrollState>
    implements $SearchPostScrollStateCopyWith<$Res> {
  _$SearchPostScrollStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchPostScrollStateImplCopyWith<$Res>
    implements $SearchPostScrollStateCopyWith<$Res> {
  factory _$$SearchPostScrollStateImplCopyWith(
          _$SearchPostScrollStateImpl value,
          $Res Function(_$SearchPostScrollStateImpl) then) =
      __$$SearchPostScrollStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentPage, bool hasMore});
}

/// @nodoc
class __$$SearchPostScrollStateImplCopyWithImpl<$Res>
    extends _$SearchPostScrollStateCopyWithImpl<$Res,
        _$SearchPostScrollStateImpl>
    implements _$$SearchPostScrollStateImplCopyWith<$Res> {
  __$$SearchPostScrollStateImplCopyWithImpl(_$SearchPostScrollStateImpl _value,
      $Res Function(_$SearchPostScrollStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? hasMore = null,
  }) {
    return _then(_$SearchPostScrollStateImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SearchPostScrollStateImpl implements _SearchPostScrollState {
  const _$SearchPostScrollStateImpl(
      {this.currentPage = 0, this.hasMore = true});

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'SearchPostScrollState(currentPage: $currentPage, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchPostScrollStateImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPage, hasMore);

  /// Create a copy of SearchPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchPostScrollStateImplCopyWith<_$SearchPostScrollStateImpl>
      get copyWith => __$$SearchPostScrollStateImplCopyWithImpl<
          _$SearchPostScrollStateImpl>(this, _$identity);
}

abstract class _SearchPostScrollState implements SearchPostScrollState {
  const factory _SearchPostScrollState(
      {final int currentPage,
      final bool hasMore}) = _$SearchPostScrollStateImpl;

  @override
  int get currentPage;
  @override
  bool get hasMore;

  /// Create a copy of SearchPostScrollState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchPostScrollStateImplCopyWith<_$SearchPostScrollStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
