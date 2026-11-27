import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

/// One field-level validation error inside an error response.
@freezed
class FieldErrorDto with _$FieldErrorDto {
  const factory FieldErrorDto({
    required String field,
    required String message,
    required String code,
  }) = _FieldErrorDto;

  factory FieldErrorDto.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorDtoFromJson(json);
}

/// The API error envelope body: `{ error: { code, message, details?,
/// requestId, timestamp } }`. The `code` is kept as a plain string (the API
/// has ~60 codes and new ones must not break parsing).
@freezed
class ErrorBodyDto with _$ErrorBodyDto {
  const factory ErrorBodyDto({
    required String code,
    required String message,
    @Default(<FieldErrorDto>[]) List<FieldErrorDto> details,
    required String requestId,
    required DateTime timestamp,
  }) = _ErrorBodyDto;

  factory ErrorBodyDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorBodyDtoFromJson(json);
}

@freezed
class ErrorResponseDto with _$ErrorResponseDto {
  const factory ErrorResponseDto({
    required ErrorBodyDto error,
  }) = _ErrorResponseDto;

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseDtoFromJson(json);
}
