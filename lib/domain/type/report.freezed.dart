// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Report _$ReportFromJson(Map<String, dynamic> json) {
  return _Report.fromJson(json);
}

/// @nodoc
mixin _$Report {
  String get reportedPostId => throw _privateConstructorUsedError;
  String get reporterUid => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;

  /// Serializes this Report to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportCopyWith<Report> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) then) =
      _$ReportCopyWithImpl<$Res, Report>;
  @useResult
  $Res call(
      {String reportedPostId,
      String reporterUid,
      String reason,
      DateTime createdAt,
      int status});
}

/// @nodoc
class _$ReportCopyWithImpl<$Res, $Val extends Report>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportedPostId = null,
    Object? reporterUid = null,
    Object? reason = null,
    Object? createdAt = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      reportedPostId: null == reportedPostId
          ? _value.reportedPostId
          : reportedPostId // ignore: cast_nullable_to_non_nullable
              as String,
      reporterUid: null == reporterUid
          ? _value.reporterUid
          : reporterUid // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportImplCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$$ReportImplCopyWith(
          _$ReportImpl value, $Res Function(_$ReportImpl) then) =
      __$$ReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reportedPostId,
      String reporterUid,
      String reason,
      DateTime createdAt,
      int status});
}

/// @nodoc
class __$$ReportImplCopyWithImpl<$Res>
    extends _$ReportCopyWithImpl<$Res, _$ReportImpl>
    implements _$$ReportImplCopyWith<$Res> {
  __$$ReportImplCopyWithImpl(
      _$ReportImpl _value, $Res Function(_$ReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportedPostId = null,
    Object? reporterUid = null,
    Object? reason = null,
    Object? createdAt = null,
    Object? status = null,
  }) {
    return _then(_$ReportImpl(
      reportedPostId: null == reportedPostId
          ? _value.reportedPostId
          : reportedPostId // ignore: cast_nullable_to_non_nullable
              as String,
      reporterUid: null == reporterUid
          ? _value.reporterUid
          : reporterUid // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportImpl implements _Report {
  const _$ReportImpl(
      {required this.reportedPostId,
      required this.reporterUid,
      required this.reason,
      required this.createdAt,
      this.status = 0});

  factory _$ReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportImplFromJson(json);

  @override
  final String reportedPostId;
  @override
  final String reporterUid;
  @override
  final String reason;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int status;

  @override
  String toString() {
    return 'Report(reportedPostId: $reportedPostId, reporterUid: $reporterUid, reason: $reason, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImpl &&
            (identical(other.reportedPostId, reportedPostId) ||
                other.reportedPostId == reportedPostId) &&
            (identical(other.reporterUid, reporterUid) ||
                other.reporterUid == reporterUid) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, reportedPostId, reporterUid, reason, createdAt, status);

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      __$$ReportImplCopyWithImpl<_$ReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImplToJson(
      this,
    );
  }
}

abstract class _Report implements Report {
  const factory _Report(
      {required final String reportedPostId,
      required final String reporterUid,
      required final String reason,
      required final DateTime createdAt,
      final int status}) = _$ReportImpl;

  factory _Report.fromJson(Map<String, dynamic> json) = _$ReportImpl.fromJson;

  @override
  String get reportedPostId;
  @override
  String get reporterUid;
  @override
  String get reason;
  @override
  DateTime get createdAt;
  @override
  int get status;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
