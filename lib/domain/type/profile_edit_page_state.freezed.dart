// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_edit_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileEditPageState {
  Profile? get profile => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  bool get isShowBirthday => throw _privateConstructorUsedError;
  String get savedBirthday => throw _privateConstructorUsedError;

  /// Create a copy of ProfileEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileEditPageStateCopyWith<ProfileEditPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileEditPageStateCopyWith<$Res> {
  factory $ProfileEditPageStateCopyWith(ProfileEditPageState value,
          $Res Function(ProfileEditPageState) then) =
      _$ProfileEditPageStateCopyWithImpl<$Res, ProfileEditPageState>;
  @useResult
  $Res call(
      {Profile? profile,
      String? imagePath,
      bool isShowBirthday,
      String savedBirthday});

  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$ProfileEditPageStateCopyWithImpl<$Res,
        $Val extends ProfileEditPageState>
    implements $ProfileEditPageStateCopyWith<$Res> {
  _$ProfileEditPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? imagePath = freezed,
    Object? isShowBirthday = null,
    Object? savedBirthday = null,
  }) {
    return _then(_value.copyWith(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      isShowBirthday: null == isShowBirthday
          ? _value.isShowBirthday
          : isShowBirthday // ignore: cast_nullable_to_non_nullable
              as bool,
      savedBirthday: null == savedBirthday
          ? _value.savedBirthday
          : savedBirthday // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of ProfileEditPageState
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
abstract class _$$ProfileEditPageStateImplCopyWith<$Res>
    implements $ProfileEditPageStateCopyWith<$Res> {
  factory _$$ProfileEditPageStateImplCopyWith(_$ProfileEditPageStateImpl value,
          $Res Function(_$ProfileEditPageStateImpl) then) =
      __$$ProfileEditPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Profile? profile,
      String? imagePath,
      bool isShowBirthday,
      String savedBirthday});

  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$ProfileEditPageStateImplCopyWithImpl<$Res>
    extends _$ProfileEditPageStateCopyWithImpl<$Res, _$ProfileEditPageStateImpl>
    implements _$$ProfileEditPageStateImplCopyWith<$Res> {
  __$$ProfileEditPageStateImplCopyWithImpl(_$ProfileEditPageStateImpl _value,
      $Res Function(_$ProfileEditPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? imagePath = freezed,
    Object? isShowBirthday = null,
    Object? savedBirthday = null,
  }) {
    return _then(_$ProfileEditPageStateImpl(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      isShowBirthday: null == isShowBirthday
          ? _value.isShowBirthday
          : isShowBirthday // ignore: cast_nullable_to_non_nullable
              as bool,
      savedBirthday: null == savedBirthday
          ? _value.savedBirthday
          : savedBirthday // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ProfileEditPageStateImpl implements _ProfileEditPageState {
  const _$ProfileEditPageStateImpl(
      {required this.profile,
      required this.imagePath,
      required this.isShowBirthday,
      this.savedBirthday = ''});

  @override
  final Profile? profile;
  @override
  final String? imagePath;
  @override
  final bool isShowBirthday;
  @override
  @JsonKey()
  final String savedBirthday;

  @override
  String toString() {
    return 'ProfileEditPageState(profile: $profile, imagePath: $imagePath, isShowBirthday: $isShowBirthday, savedBirthday: $savedBirthday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileEditPageStateImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.isShowBirthday, isShowBirthday) ||
                other.isShowBirthday == isShowBirthday) &&
            (identical(other.savedBirthday, savedBirthday) ||
                other.savedBirthday == savedBirthday));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, profile, imagePath, isShowBirthday, savedBirthday);

  /// Create a copy of ProfileEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileEditPageStateImplCopyWith<_$ProfileEditPageStateImpl>
      get copyWith =>
          __$$ProfileEditPageStateImplCopyWithImpl<_$ProfileEditPageStateImpl>(
              this, _$identity);
}

abstract class _ProfileEditPageState implements ProfileEditPageState {
  const factory _ProfileEditPageState(
      {required final Profile? profile,
      required final String? imagePath,
      required final bool isShowBirthday,
      final String savedBirthday}) = _$ProfileEditPageStateImpl;

  @override
  Profile? get profile;
  @override
  String? get imagePath;
  @override
  bool get isShowBirthday;
  @override
  String get savedBirthday;

  /// Create a copy of ProfileEditPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileEditPageStateImplCopyWith<_$ProfileEditPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
