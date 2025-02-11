// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationSetting _$NotificationSettingFromJson(Map<String, dynamic> json) {
  return _NotificationSetting.fromJson(json);
}

/// @nodoc
mixin _$NotificationSetting {
  String get uid => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  bool get likeSetting => throw _privateConstructorUsedError;
  bool get commentSetting => throw _privateConstructorUsedError;
  bool get followerSetting => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingCopyWith<NotificationSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingCopyWith<$Res> {
  factory $NotificationSettingCopyWith(
          NotificationSetting value, $Res Function(NotificationSetting) then) =
      _$NotificationSettingCopyWithImpl<$Res, NotificationSetting>;
  @useResult
  $Res call(
      {String uid,
      String token,
      String deviceId,
      bool likeSetting,
      bool commentSetting,
      bool followerSetting,
      DateTime updatedAt});
}

/// @nodoc
class _$NotificationSettingCopyWithImpl<$Res, $Val extends NotificationSetting>
    implements $NotificationSettingCopyWith<$Res> {
  _$NotificationSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? token = null,
    Object? deviceId = null,
    Object? likeSetting = null,
    Object? commentSetting = null,
    Object? followerSetting = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      likeSetting: null == likeSetting
          ? _value.likeSetting
          : likeSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      commentSetting: null == commentSetting
          ? _value.commentSetting
          : commentSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      followerSetting: null == followerSetting
          ? _value.followerSetting
          : followerSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingImplCopyWith<$Res>
    implements $NotificationSettingCopyWith<$Res> {
  factory _$$NotificationSettingImplCopyWith(_$NotificationSettingImpl value,
          $Res Function(_$NotificationSettingImpl) then) =
      __$$NotificationSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String token,
      String deviceId,
      bool likeSetting,
      bool commentSetting,
      bool followerSetting,
      DateTime updatedAt});
}

/// @nodoc
class __$$NotificationSettingImplCopyWithImpl<$Res>
    extends _$NotificationSettingCopyWithImpl<$Res, _$NotificationSettingImpl>
    implements _$$NotificationSettingImplCopyWith<$Res> {
  __$$NotificationSettingImplCopyWithImpl(_$NotificationSettingImpl _value,
      $Res Function(_$NotificationSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? token = null,
    Object? deviceId = null,
    Object? likeSetting = null,
    Object? commentSetting = null,
    Object? followerSetting = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NotificationSettingImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      likeSetting: null == likeSetting
          ? _value.likeSetting
          : likeSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      commentSetting: null == commentSetting
          ? _value.commentSetting
          : commentSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      followerSetting: null == followerSetting
          ? _value.followerSetting
          : followerSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingImpl implements _NotificationSetting {
  const _$NotificationSettingImpl(
      {required this.uid,
      required this.token,
      required this.deviceId,
      this.likeSetting = true,
      this.commentSetting = true,
      this.followerSetting = true,
      required this.updatedAt});

  factory _$NotificationSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingImplFromJson(json);

  @override
  final String uid;
  @override
  final String token;
  @override
  final String deviceId;
  @override
  @JsonKey()
  final bool likeSetting;
  @override
  @JsonKey()
  final bool commentSetting;
  @override
  @JsonKey()
  final bool followerSetting;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NotificationSetting(uid: $uid, token: $token, deviceId: $deviceId, likeSetting: $likeSetting, commentSetting: $commentSetting, followerSetting: $followerSetting, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.likeSetting, likeSetting) ||
                other.likeSetting == likeSetting) &&
            (identical(other.commentSetting, commentSetting) ||
                other.commentSetting == commentSetting) &&
            (identical(other.followerSetting, followerSetting) ||
                other.followerSetting == followerSetting) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, token, deviceId,
      likeSetting, commentSetting, followerSetting, updatedAt);

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingImplCopyWith<_$NotificationSettingImpl> get copyWith =>
      __$$NotificationSettingImplCopyWithImpl<_$NotificationSettingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingImplToJson(
      this,
    );
  }
}

abstract class _NotificationSetting implements NotificationSetting {
  const factory _NotificationSetting(
      {required final String uid,
      required final String token,
      required final String deviceId,
      final bool likeSetting,
      final bool commentSetting,
      final bool followerSetting,
      required final DateTime updatedAt}) = _$NotificationSettingImpl;

  factory _NotificationSetting.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingImpl.fromJson;

  @override
  String get uid;
  @override
  String get token;
  @override
  String get deviceId;
  @override
  bool get likeSetting;
  @override
  bool get commentSetting;
  @override
  bool get followerSetting;
  @override
  DateTime get updatedAt;

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingImplCopyWith<_$NotificationSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
