// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FieldErrorDtoImpl _$$FieldErrorDtoImplFromJson(Map<String, dynamic> json) =>
    _$FieldErrorDtoImpl(
      field: json['field'] as String,
      message: json['message'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$$FieldErrorDtoImplToJson(_$FieldErrorDtoImpl instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
      'code': instance.code,
    };

_$ErrorBodyDtoImpl _$$ErrorBodyDtoImplFromJson(Map<String, dynamic> json) =>
    _$ErrorBodyDtoImpl(
      code: json['code'] as String,
      message: json['message'] as String,
      details:
          (json['details'] as List<dynamic>?)
              ?.map((e) => FieldErrorDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FieldErrorDto>[],
      requestId: json['requestId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ErrorBodyDtoImplToJson(_$ErrorBodyDtoImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'requestId': instance.requestId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$ErrorResponseDtoImpl _$$ErrorResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ErrorResponseDtoImpl(
  error: ErrorBodyDto.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ErrorResponseDtoImplToJson(
  _$ErrorResponseDtoImpl instance,
) => <String, dynamic>{'error': instance.error};
