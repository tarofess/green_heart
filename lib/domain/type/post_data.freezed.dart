// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostData {
  Post get post => throw _privateConstructorUsedError;
  Profile? get userProfile => throw _privateConstructorUsedError;
  List<Like> get likes => throw _privateConstructorUsedError;
  List<CommentData> get comments => throw _privateConstructorUsedError;

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostDataCopyWith<PostData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostDataCopyWith<$Res> {
  factory $PostDataCopyWith(PostData value, $Res Function(PostData) then) =
      _$PostDataCopyWithImpl<$Res, PostData>;
  @useResult
  $Res call(
      {Post post,
      Profile? userProfile,
      List<Like> likes,
      List<CommentData> comments});

  $PostCopyWith<$Res> get post;
  $ProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class _$PostDataCopyWithImpl<$Res, $Val extends PostData>
    implements $PostDataCopyWith<$Res> {
  _$PostDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? post = null,
    Object? userProfile = freezed,
    Object? likes = null,
    Object? comments = null,
  }) {
    return _then(_value.copyWith(
      post: null == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<Like>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
    ) as $Val);
  }

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res> get post {
    return $PostCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value) as $Val);
    });
  }

  /// Create a copy of PostData
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
abstract class _$$PostDataImplCopyWith<$Res>
    implements $PostDataCopyWith<$Res> {
  factory _$$PostDataImplCopyWith(
          _$PostDataImpl value, $Res Function(_$PostDataImpl) then) =
      __$$PostDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Post post,
      Profile? userProfile,
      List<Like> likes,
      List<CommentData> comments});

  @override
  $PostCopyWith<$Res> get post;
  @override
  $ProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class __$$PostDataImplCopyWithImpl<$Res>
    extends _$PostDataCopyWithImpl<$Res, _$PostDataImpl>
    implements _$$PostDataImplCopyWith<$Res> {
  __$$PostDataImplCopyWithImpl(
      _$PostDataImpl _value, $Res Function(_$PostDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? post = null,
    Object? userProfile = freezed,
    Object? likes = null,
    Object? comments = null,
  }) {
    return _then(_$PostDataImpl(
      post: null == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      likes: null == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<Like>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
    ));
  }
}

/// @nodoc

class _$PostDataImpl implements _PostData {
  const _$PostDataImpl(
      {required this.post,
      required this.userProfile,
      required final List<Like> likes,
      required final List<CommentData> comments})
      : _likes = likes,
        _comments = comments;

  @override
  final Post post;
  @override
  final Profile? userProfile;
  final List<Like> _likes;
  @override
  List<Like> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  final List<CommentData> _comments;
  @override
  List<CommentData> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  String toString() {
    return 'PostData(post: $post, userProfile: $userProfile, likes: $likes, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostDataImpl &&
            (identical(other.post, post) || other.post == post) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      post,
      userProfile,
      const DeepCollectionEquality().hash(_likes),
      const DeepCollectionEquality().hash(_comments));

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostDataImplCopyWith<_$PostDataImpl> get copyWith =>
      __$$PostDataImplCopyWithImpl<_$PostDataImpl>(this, _$identity);
}

abstract class _PostData implements PostData {
  const factory _PostData(
      {required final Post post,
      required final Profile? userProfile,
      required final List<Like> likes,
      required final List<CommentData> comments}) = _$PostDataImpl;

  @override
  Post get post;
  @override
  Profile? get userProfile;
  @override
  List<Like> get likes;
  @override
  List<CommentData> get comments;

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostDataImplCopyWith<_$PostDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
