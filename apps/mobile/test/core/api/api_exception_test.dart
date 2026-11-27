import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';

DioException _dioError({
  required int? statusCode,
  required Map<String, dynamic>? body,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  final RequestOptions options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    response: Response<Map<String, dynamic>>(
      requestOptions: options,
      statusCode: statusCode,
      data: body,
    ),
    type: type,
  );
}

void main() {
  group('ApiException.fromDio', () {
    test('maps the API error envelope with details', () {
      final ApiException exception = ApiException.fromDio(
        _dioError(
          statusCode: 400,
          body: <String, dynamic>{
            'error': <String, dynamic>{
              'code': 'VALIDATION_ERROR',
              'message': 'Validation failed',
              'details': <dynamic>[
                <String, dynamic>{
                  'field': 'email',
                  'message': 'Email is invalid',
                  'code': 'INVALID_EMAIL',
                },
              ],
              'requestId': 'req-123',
              'timestamp': '2026-11-27T10:00:00.000Z',
            },
          },
        ),
      );

      expect(exception.code, 'VALIDATION_ERROR');
      expect(exception.message, 'Validation failed');
      expect(exception.statusCode, 400);
      expect(exception.requestId, 'req-123');
      expect(exception.isValidationError, isTrue);
      expect(exception.fieldMessage('email'), 'Email is invalid');
      expect(exception.fieldMessage('password'), isNull);
    });

    test('detects the register rate limit', () {
      final ApiException exception = ApiException.fromDio(
        _dioError(
          statusCode: 429,
          body: <String, dynamic>{
            'error': <String, dynamic>{
              'code': 'RATE_LIMIT_EXCEEDED',
              'message': 'Too many requests',
              'requestId': 'req-429',
              'timestamp': '2026-11-27T10:00:00.000Z',
            },
          },
        ),
      );

      expect(exception.isRateLimited, isTrue);
      expect(exception.isUnauthenticated, isFalse);
    });

    test('detects unauthenticated codes', () {
      final ApiException exception = ApiException.fromDio(
        _dioError(
          statusCode: 401,
          body: <String, dynamic>{
            'error': <String, dynamic>{
              'code': 'TOKEN_EXPIRED',
              'message': 'Token expired',
              'requestId': 'req-401',
              'timestamp': '2026-11-27T10:00:00.000Z',
            },
          },
        ),
      );

      expect(exception.isUnauthenticated, isTrue);
    });

    test('maps a connection error without an envelope', () {
      final ApiException exception = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
          error: 'SocketException',
        ),
      );

      expect(exception.code, 'NETWORK_ERROR');
      expect(exception.statusCode, isNull);
    });

    test('maps a timeout', () {
      final ApiException exception = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
        ),
      );

      expect(exception.code, 'TIMEOUT');
    });

    test('falls back to UNKNOWN_ERROR for a body without an envelope', () {
      final ApiException exception = ApiException.fromDio(
        _dioError(
          statusCode: 500,
          body: <String, dynamic>{'unexpected': true},
        ),
      );

      expect(exception.code, 'UNKNOWN_ERROR');
      expect(exception.statusCode, 500);
    });
  });
}
