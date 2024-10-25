// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppInfo {
  String get developerName => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  String get termsOfUse => throw _privateConstructorUsedError;
  String get privacyPolicy => throw _privateConstructorUsedError;
  String get updateHistory => throw _privateConstructorUsedError;

  /// Create a copy of AppInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppInfoCopyWith<AppInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppInfoCopyWith<$Res> {
  factory $AppInfoCopyWith(AppInfo value, $Res Function(AppInfo) then) =
      _$AppInfoCopyWithImpl<$Res, AppInfo>;
  @useResult
  $Res call(
      {String developerName,
      String appVersion,
      String termsOfUse,
      String privacyPolicy,
      String updateHistory});
}

/// @nodoc
class _$AppInfoCopyWithImpl<$Res, $Val extends AppInfo>
    implements $AppInfoCopyWith<$Res> {
  _$AppInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? developerName = null,
    Object? appVersion = null,
    Object? termsOfUse = null,
    Object? privacyPolicy = null,
    Object? updateHistory = null,
  }) {
    return _then(_value.copyWith(
      developerName: null == developerName
          ? _value.developerName
          : developerName // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      termsOfUse: null == termsOfUse
          ? _value.termsOfUse
          : termsOfUse // ignore: cast_nullable_to_non_nullable
              as String,
      privacyPolicy: null == privacyPolicy
          ? _value.privacyPolicy
          : privacyPolicy // ignore: cast_nullable_to_non_nullable
              as String,
      updateHistory: null == updateHistory
          ? _value.updateHistory
          : updateHistory // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppInfoImplCopyWith<$Res> implements $AppInfoCopyWith<$Res> {
  factory _$$AppInfoImplCopyWith(
          _$AppInfoImpl value, $Res Function(_$AppInfoImpl) then) =
      __$$AppInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String developerName,
      String appVersion,
      String termsOfUse,
      String privacyPolicy,
      String updateHistory});
}

/// @nodoc
class __$$AppInfoImplCopyWithImpl<$Res>
    extends _$AppInfoCopyWithImpl<$Res, _$AppInfoImpl>
    implements _$$AppInfoImplCopyWith<$Res> {
  __$$AppInfoImplCopyWithImpl(
      _$AppInfoImpl _value, $Res Function(_$AppInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? developerName = null,
    Object? appVersion = null,
    Object? termsOfUse = null,
    Object? privacyPolicy = null,
    Object? updateHistory = null,
  }) {
    return _then(_$AppInfoImpl(
      developerName: null == developerName
          ? _value.developerName
          : developerName // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      termsOfUse: null == termsOfUse
          ? _value.termsOfUse
          : termsOfUse // ignore: cast_nullable_to_non_nullable
              as String,
      privacyPolicy: null == privacyPolicy
          ? _value.privacyPolicy
          : privacyPolicy // ignore: cast_nullable_to_non_nullable
              as String,
      updateHistory: null == updateHistory
          ? _value.updateHistory
          : updateHistory // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppInfoImpl implements _AppInfo {
  const _$AppInfoImpl(
      {required this.developerName,
      required this.appVersion,
      required this.termsOfUse,
      required this.privacyPolicy,
      required this.updateHistory});

  @override
  final String developerName;
  @override
  final String appVersion;
  @override
  final String termsOfUse;
  @override
  final String privacyPolicy;
  @override
  final String updateHistory;

  @override
  String toString() {
    return 'AppInfo(developerName: $developerName, appVersion: $appVersion, termsOfUse: $termsOfUse, privacyPolicy: $privacyPolicy, updateHistory: $updateHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppInfoImpl &&
            (identical(other.developerName, developerName) ||
                other.developerName == developerName) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.termsOfUse, termsOfUse) ||
                other.termsOfUse == termsOfUse) &&
            (identical(other.privacyPolicy, privacyPolicy) ||
                other.privacyPolicy == privacyPolicy) &&
            (identical(other.updateHistory, updateHistory) ||
                other.updateHistory == updateHistory));
  }

  @override
  int get hashCode => Object.hash(runtimeType, developerName, appVersion,
      termsOfUse, privacyPolicy, updateHistory);

  /// Create a copy of AppInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppInfoImplCopyWith<_$AppInfoImpl> get copyWith =>
      __$$AppInfoImplCopyWithImpl<_$AppInfoImpl>(this, _$identity);
}

abstract class _AppInfo implements AppInfo {
  const factory _AppInfo(
      {required final String developerName,
      required final String appVersion,
      required final String termsOfUse,
      required final String privacyPolicy,
      required final String updateHistory}) = _$AppInfoImpl;

  @override
  String get developerName;
  @override
  String get appVersion;
  @override
  String get termsOfUse;
  @override
  String get privacyPolicy;
  @override
  String get updateHistory;

  /// Create a copy of AppInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppInfoImplCopyWith<_$AppInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
