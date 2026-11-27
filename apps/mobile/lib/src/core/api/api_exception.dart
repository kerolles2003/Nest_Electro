import 'package:dio/dio.dart';
import 'package:nest_electro/src/core/models/api_error.dart';

/// The single error type the whole app deals with. Built from the API's
/// `{ error: { code, message, details?, requestId, timestamp } }` envelope,
/// or from transport failures (no envelope) with a client-side code.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details = const <FieldErrorDto>[],
    this.requestId,
  });

  factory ApiException.fromErrorBody(
    ErrorBodyDto body, {
    int? statusCode,
  }) {
    return ApiException(
      code: body.code,
      message: body.message,
      statusCode: statusCode,
      details: body.details,
      requestId: body.requestId,
    );
  }

  factory ApiException.fromDio(DioException err) {
    if (err.error is ApiException) {
      return err.error as ApiException;
    }
    final Object? data = err.response?.data;
    if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
      return ApiException.fromErrorBody(
        ErrorBodyDto.fromJson(data['error'] as Map<String, dynamic>),
        statusCode: err.response?.statusCode,
      );
    }
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const ApiException(
          code: 'TIMEOUT',
          message: 'Request timed out. Check your connection and try again.',
        ),
      DioExceptionType.connectionError => const ApiException(
          code: 'NETWORK_ERROR',
          message:
              'Could not reach the server. Check your connection and try again.',
        ),
      DioExceptionType.cancel => const ApiException(
          code: 'CANCELLED',
          message: 'Request cancelled.',
        ),
      _ => ApiException(
          code: 'UNKNOWN_ERROR',
          message:
              'Unexpected error (${err.response?.statusCode ?? 'no response'}).',
          statusCode: err.response?.statusCode,
        ),
    };
  }

  /// API error code (e.g. `VALIDATION_ERROR`, `RATE_LIMIT_EXCEEDED`).
  final String code;

  /// Human-readable message from the API (or a client-side fallback).
  final String message;

  final int? statusCode;

  final List<FieldErrorDto> details;

  final String? requestId;

  /// 429 / `RATE_LIMIT_EXCEEDED` — e.g. the 3/hour register limit.
  bool get isRateLimited =>
      code == 'RATE_LIMIT_EXCEEDED' || statusCode == 429;

  bool get isUnauthenticated =>
      code == 'UNAUTHENTICATED' ||
      code == 'TOKEN_EXPIRED' ||
      code == 'TOKEN_INVALID' ||
      code == 'REFRESH_TOKEN_INVALID' ||
      code == 'REFRESH_TOKEN_REUSED' ||
      statusCode == 401;

  bool get isValidationError => code == 'VALIDATION_ERROR';

  /// Field-level message for a validation error, if the API supplied one.
  String? fieldMessage(String field) {
    for (final FieldErrorDto detail in details) {
      if (detail.field == field) {
        return detail.message;
      }
    }
    return null;
  }

  @override
  String toString() => 'ApiException($code): $message';
}
