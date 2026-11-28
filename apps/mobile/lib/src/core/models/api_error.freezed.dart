// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FieldErrorDto _$FieldErrorDtoFromJson(Map<String, dynamic> json) {
  return _FieldErrorDto.fromJson(json);
}

/// @nodoc
mixin _$FieldErrorDto {
  String get field => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;

  /// Serializes this FieldErrorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldErrorDtoCopyWith<FieldErrorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldErrorDtoCopyWith<$Res> {
  factory $FieldErrorDtoCopyWith(
    FieldErrorDto value,
    $Res Function(FieldErrorDto) then,
  ) = _$FieldErrorDtoCopyWithImpl<$Res, FieldErrorDto>;
  @useResult
  $Res call({String field, String message, String code});
}

/// @nodoc
class _$FieldErrorDtoCopyWithImpl<$Res, $Val extends FieldErrorDto>
    implements $FieldErrorDtoCopyWith<$Res> {
  _$FieldErrorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? message = null,
    Object? code = null,
  }) {
    return _then(
      _value.copyWith(
            field: null == field
                ? _value.field
                : field // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FieldErrorDtoImplCopyWith<$Res>
    implements $FieldErrorDtoCopyWith<$Res> {
  factory _$$FieldErrorDtoImplCopyWith(
    _$FieldErrorDtoImpl value,
    $Res Function(_$FieldErrorDtoImpl) then,
  ) = __$$FieldErrorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field, String message, String code});
}

/// @nodoc
class __$$FieldErrorDtoImplCopyWithImpl<$Res>
    extends _$FieldErrorDtoCopyWithImpl<$Res, _$FieldErrorDtoImpl>
    implements _$$FieldErrorDtoImplCopyWith<$Res> {
  __$$FieldErrorDtoImplCopyWithImpl(
    _$FieldErrorDtoImpl _value,
    $Res Function(_$FieldErrorDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FieldErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? message = null,
    Object? code = null,
  }) {
    return _then(
      _$FieldErrorDtoImpl(
        field: null == field
            ? _value.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldErrorDtoImpl implements _FieldErrorDto {
  const _$FieldErrorDtoImpl({
    required this.field,
    required this.message,
    required this.code,
  });

  factory _$FieldErrorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldErrorDtoImplFromJson(json);

  @override
  final String field;
  @override
  final String message;
  @override
  final String code;

  @override
  String toString() {
    return 'FieldErrorDto(field: $field, message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldErrorDtoImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, field, message, code);

  /// Create a copy of FieldErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldErrorDtoImplCopyWith<_$FieldErrorDtoImpl> get copyWith =>
      __$$FieldErrorDtoImplCopyWithImpl<_$FieldErrorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldErrorDtoImplToJson(this);
  }
}

abstract class _FieldErrorDto implements FieldErrorDto {
  const factory _FieldErrorDto({
    required final String field,
    required final String message,
    required final String code,
  }) = _$FieldErrorDtoImpl;

  factory _FieldErrorDto.fromJson(Map<String, dynamic> json) =
      _$FieldErrorDtoImpl.fromJson;

  @override
  String get field;
  @override
  String get message;
  @override
  String get code;

  /// Create a copy of FieldErrorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldErrorDtoImplCopyWith<_$FieldErrorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ErrorBodyDto _$ErrorBodyDtoFromJson(Map<String, dynamic> json) {
  return _ErrorBodyDto.fromJson(json);
}

/// @nodoc
mixin _$ErrorBodyDto {
  String get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<FieldErrorDto> get details => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ErrorBodyDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ErrorBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ErrorBodyDtoCopyWith<ErrorBodyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorBodyDtoCopyWith<$Res> {
  factory $ErrorBodyDtoCopyWith(
    ErrorBodyDto value,
    $Res Function(ErrorBodyDto) then,
  ) = _$ErrorBodyDtoCopyWithImpl<$Res, ErrorBodyDto>;
  @useResult
  $Res call({
    String code,
    String message,
    List<FieldErrorDto> details,
    String requestId,
    DateTime timestamp,
  });
}

/// @nodoc
class _$ErrorBodyDtoCopyWithImpl<$Res, $Val extends ErrorBodyDto>
    implements $ErrorBodyDtoCopyWith<$Res> {
  _$ErrorBodyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ErrorBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = null,
    Object? requestId = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            details: null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as List<FieldErrorDto>,
            requestId: null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ErrorBodyDtoImplCopyWith<$Res>
    implements $ErrorBodyDtoCopyWith<$Res> {
  factory _$$ErrorBodyDtoImplCopyWith(
    _$ErrorBodyDtoImpl value,
    $Res Function(_$ErrorBodyDtoImpl) then,
  ) = __$$ErrorBodyDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String code,
    String message,
    List<FieldErrorDto> details,
    String requestId,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$ErrorBodyDtoImplCopyWithImpl<$Res>
    extends _$ErrorBodyDtoCopyWithImpl<$Res, _$ErrorBodyDtoImpl>
    implements _$$ErrorBodyDtoImplCopyWith<$Res> {
  __$$ErrorBodyDtoImplCopyWithImpl(
    _$ErrorBodyDtoImpl _value,
    $Res Function(_$ErrorBodyDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ErrorBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = null,
    Object? requestId = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$ErrorBodyDtoImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        details: null == details
            ? _value._details
            : details // ignore: cast_nullable_to_non_nullable
                  as List<FieldErrorDto>,
        requestId: null == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorBodyDtoImpl implements _ErrorBodyDto {
  const _$ErrorBodyDtoImpl({
    required this.code,
    required this.message,
    final List<FieldErrorDto> details = const <FieldErrorDto>[],
    required this.requestId,
    required this.timestamp,
  }) : _details = details;

  factory _$ErrorBodyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorBodyDtoImplFromJson(json);

  @override
  final String code;
  @override
  final String message;
  final List<FieldErrorDto> _details;
  @override
  @JsonKey()
  List<FieldErrorDto> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  final String requestId;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ErrorBodyDto(code: $code, message: $message, details: $details, requestId: $requestId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorBodyDtoImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    message,
    const DeepCollectionEquality().hash(_details),
    requestId,
    timestamp,
  );

  /// Create a copy of ErrorBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorBodyDtoImplCopyWith<_$ErrorBodyDtoImpl> get copyWith =>
      __$$ErrorBodyDtoImplCopyWithImpl<_$ErrorBodyDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorBodyDtoImplToJson(this);
  }
}

abstract class _ErrorBodyDto implements ErrorBodyDto {
  const factory _ErrorBodyDto({
    required final String code,
    required final String message,
    final List<FieldErrorDto> details,
    required final String requestId,
    required final DateTime timestamp,
  }) = _$ErrorBodyDtoImpl;

  factory _ErrorBodyDto.fromJson(Map<String, dynamic> json) =
      _$ErrorBodyDtoImpl.fromJson;

  @override
  String get code;
  @override
  String get message;
  @override
  List<FieldErrorDto> get details;
  @override
  String get requestId;
  @override
  DateTime get timestamp;

  /// Create a copy of ErrorBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorBodyDtoImplCopyWith<_$ErrorBodyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ErrorResponseDto _$ErrorResponseDtoFromJson(Map<String, dynamic> json) {
  return _ErrorResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ErrorResponseDto {
  ErrorBodyDto get error => throw _privateConstructorUsedError;

  /// Serializes this ErrorResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ErrorResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ErrorResponseDtoCopyWith<ErrorResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorResponseDtoCopyWith<$Res> {
  factory $ErrorResponseDtoCopyWith(
    ErrorResponseDto value,
    $Res Function(ErrorResponseDto) then,
  ) = _$ErrorResponseDtoCopyWithImpl<$Res, ErrorResponseDto>;
  @useResult
  $Res call({ErrorBodyDto error});

  $ErrorBodyDtoCopyWith<$Res> get error;
}

/// @nodoc
class _$ErrorResponseDtoCopyWithImpl<$Res, $Val extends ErrorResponseDto>
    implements $ErrorResponseDtoCopyWith<$Res> {
  _$ErrorResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ErrorResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _value.copyWith(
            error: null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as ErrorBodyDto,
          )
          as $Val,
    );
  }

  /// Create a copy of ErrorResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ErrorBodyDtoCopyWith<$Res> get error {
    return $ErrorBodyDtoCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ErrorResponseDtoImplCopyWith<$Res>
    implements $ErrorResponseDtoCopyWith<$Res> {
  factory _$$ErrorResponseDtoImplCopyWith(
    _$ErrorResponseDtoImpl value,
    $Res Function(_$ErrorResponseDtoImpl) then,
  ) = __$$ErrorResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ErrorBodyDto error});

  @override
  $ErrorBodyDtoCopyWith<$Res> get error;
}

/// @nodoc
class __$$ErrorResponseDtoImplCopyWithImpl<$Res>
    extends _$ErrorResponseDtoCopyWithImpl<$Res, _$ErrorResponseDtoImpl>
    implements _$$ErrorResponseDtoImplCopyWith<$Res> {
  __$$ErrorResponseDtoImplCopyWithImpl(
    _$ErrorResponseDtoImpl _value,
    $Res Function(_$ErrorResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ErrorResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$ErrorResponseDtoImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as ErrorBodyDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorResponseDtoImpl implements _ErrorResponseDto {
  const _$ErrorResponseDtoImpl({required this.error});

  factory _$ErrorResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorResponseDtoImplFromJson(json);

  @override
  final ErrorBodyDto error;

  @override
  String toString() {
    return 'ErrorResponseDto(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorResponseDtoImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of ErrorResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorResponseDtoImplCopyWith<_$ErrorResponseDtoImpl> get copyWith =>
      __$$ErrorResponseDtoImplCopyWithImpl<_$ErrorResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorResponseDtoImplToJson(this);
  }
}

abstract class _ErrorResponseDto implements ErrorResponseDto {
  const factory _ErrorResponseDto({required final ErrorBodyDto error}) =
      _$ErrorResponseDtoImpl;

  factory _ErrorResponseDto.fromJson(Map<String, dynamic> json) =
      _$ErrorResponseDtoImpl.fromJson;

  @override
  ErrorBodyDto get error;

  /// Create a copy of ErrorResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorResponseDtoImplCopyWith<_$ErrorResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
