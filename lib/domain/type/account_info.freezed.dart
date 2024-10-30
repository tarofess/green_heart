// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountInfo {
  String get providerName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get registrationDate => throw _privateConstructorUsedError;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountInfoCopyWith<AccountInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountInfoCopyWith<$Res> {
  factory $AccountInfoCopyWith(
          AccountInfo value, $Res Function(AccountInfo) then) =
      _$AccountInfoCopyWithImpl<$Res, AccountInfo>;
  @useResult
  $Res call({String providerName, String email, String registrationDate});
}

/// @nodoc
class _$AccountInfoCopyWithImpl<$Res, $Val extends AccountInfo>
    implements $AccountInfoCopyWith<$Res> {
  _$AccountInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerName = null,
    Object? email = null,
    Object? registrationDate = null,
  }) {
    return _then(_value.copyWith(
      providerName: null == providerName
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountInfoImplCopyWith<$Res>
    implements $AccountInfoCopyWith<$Res> {
  factory _$$AccountInfoImplCopyWith(
          _$AccountInfoImpl value, $Res Function(_$AccountInfoImpl) then) =
      __$$AccountInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String providerName, String email, String registrationDate});
}

/// @nodoc
class __$$AccountInfoImplCopyWithImpl<$Res>
    extends _$AccountInfoCopyWithImpl<$Res, _$AccountInfoImpl>
    implements _$$AccountInfoImplCopyWith<$Res> {
  __$$AccountInfoImplCopyWithImpl(
      _$AccountInfoImpl _value, $Res Function(_$AccountInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerName = null,
    Object? email = null,
    Object? registrationDate = null,
  }) {
    return _then(_$AccountInfoImpl(
      providerName: null == providerName
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AccountInfoImpl implements _AccountInfo {
  const _$AccountInfoImpl(
      {required this.providerName,
      required this.email,
      required this.registrationDate});

  @override
  final String providerName;
  @override
  final String email;
  @override
  final String registrationDate;

  @override
  String toString() {
    return 'AccountInfo(providerName: $providerName, email: $email, registrationDate: $registrationDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountInfoImpl &&
            (identical(other.providerName, providerName) ||
                other.providerName == providerName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, providerName, email, registrationDate);

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountInfoImplCopyWith<_$AccountInfoImpl> get copyWith =>
      __$$AccountInfoImplCopyWithImpl<_$AccountInfoImpl>(this, _$identity);
}

abstract class _AccountInfo implements AccountInfo {
  const factory _AccountInfo(
      {required final String providerName,
      required final String email,
      required final String registrationDate}) = _$AccountInfoImpl;

  @override
  String get providerName;
  @override
  String get email;
  @override
  String get registrationDate;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountInfoImplCopyWith<_$AccountInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
