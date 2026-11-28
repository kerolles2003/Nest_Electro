import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';

class _FakeTokenStorage extends Fake implements TokenStorage {
  String? accessToken = 'old-access';
  String? refreshToken = 'refresh-1';
  int clearCalls = 0;
  int saveCalls = 0;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<bool> get hasRefreshToken async =>
      refreshToken != null && refreshToken!.isNotEmpty;

  @override
  Future<void> saveTokens(SessionTokensDto tokens) async {
    saveCalls++;
    accessToken = tokens.accessToken;
    refreshToken = tokens.refreshToken;
  }

  @override
  Future<void> clear() async {
    clearCalls++;
    accessToken = null;
    refreshToken = null;
  }
}

/// Adapter that answers from a handler, recording every request.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object? data, int statusCode) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

Map<String, dynamic> _tokensJson(String access, String refresh) {
  return <String, dynamic>{
    'tokenType': 'Bearer',
    'accessToken': access,
    'expiresIn': 900,
    'accessTokenExpiresAt': '2026-11-27T10:15:00.000Z',
    'refreshToken': refresh,
    'refreshTokenExpiresAt': '2026-12-04T10:00:00.000Z',
  };
}

Map<String, dynamic> _errorEnvelope(String code) {
  return <String, dynamic>{
    'error': <String, dynamic>{
      'code': code,
      'message': 'boom',
      'requestId': 'r1',
      'timestamp': '2026-11-27T10:00:00.000Z',
    },
  };
}

void main() {
  group('request interceptor', () {
    test('adds Accept, Accept-Language and Bearer; skips Bearer on public auth paths',
        () async {
      final _FakeTokenStorage storage = _FakeTokenStorage();
      final _FakeAdapter adapter = _FakeAdapter(
        (RequestOptions options) => _json(<String, dynamic>{
          'data': <String, dynamic>{'ok': true},
        }, 200),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'ar',
        dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1')),
      );

      await client.getData<Map<String, dynamic>>(
        '/products',
        fromJson: (Object? json) => json as Map<String, dynamic>,
      );
      final RequestOptions authed = adapter.seen.single;
      expect(authed.headers['Accept'], 'application/json');
      expect(authed.headers['Accept-Language'], 'ar');
      expect(authed.headers['Authorization'], 'Bearer old-access');

      await client.getData<Map<String, dynamic>>(
        '/auth/login',
        fromJson: (Object? json) => json as Map<String, dynamic>,
      );
      final RequestOptions public = adapter.seen.last;
      expect(public.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('401 refresh', () {
    test('refreshes once and retries with the new token', () async {
      final _FakeTokenStorage storage = _FakeTokenStorage();
      int productCalls = 0;
      final _FakeAdapter adapter = _FakeAdapter((RequestOptions options) {
        if (options.extra['retried'] == true) {
          expect(options.headers['Authorization'], 'Bearer new-access');
          return _json(<String, dynamic>{
            'data': <String, dynamic>{'ok': true},
          }, 200);
        }
        productCalls++;
        return _json(_errorEnvelope('INVALID_CREDENTIALS'), 401);
      });
      final _FakeAdapter refreshAdapter = _FakeAdapter(
        (RequestOptions options) => _json(<String, dynamic>{
          'data': _tokensJson('new-access', 'new-refresh'),
        }, 200),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'en',
        dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = refreshAdapter,
      );

      final Map<String, dynamic> result =
          await client.getData<Map<String, dynamic>>(
        '/products',
        fromJson: (Object? json) => json as Map<String, dynamic>,
      );
      expect(result, <String, dynamic>{'ok': true});
      expect(productCalls, 1);
      expect(refreshAdapter.seen, hasLength(1));
      expect(refreshAdapter.seen.single.path, '/auth/refresh');
      expect(storage.saveCalls, 1);
      expect(storage.accessToken, 'new-access');
      expect(storage.clearCalls, 0);
    });

    test('failed refresh clears tokens and throws the envelope error',
        () async {
      final _FakeTokenStorage storage = _FakeTokenStorage();
      final _FakeAdapter adapter = _FakeAdapter(
        (RequestOptions options) => _json(_errorEnvelope('UNAUTHORIZED'), 401),
      );
      final _FakeAdapter refreshAdapter = _FakeAdapter(
        (RequestOptions options) => _json(_errorEnvelope('INVALID_TOKEN'), 401),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'en',
        dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = refreshAdapter,
      );

      // The rejection carries the ORIGINAL 401's envelope (the client's
      // `_onError` rejects with `err`, not the refresh failure); the
      // refresh failure's job is only to clear the dead session.
      await expectLater(
        client.getData<Map<String, dynamic>>(
          '/products',
          fromJson: (Object? json) => json as Map<String, dynamic>,
        ),
        throwsA(
          isA<ApiException>().having((ApiException e) => e.code, 'code', 'UNAUTHORIZED'),
        ),
      );
      expect(storage.clearCalls, 1);
      expect(storage.accessToken, isNull);
    });

    test('a 401 on the retried request does not refresh again', () async {
      final _FakeTokenStorage storage = _FakeTokenStorage();
      final _FakeAdapter adapter = _FakeAdapter(
        (RequestOptions options) => _json(_errorEnvelope('UNAUTHORIZED'), 401),
      );
      final _FakeAdapter refreshAdapter = _FakeAdapter(
        (RequestOptions options) => _json(<String, dynamic>{
          'data': _tokensJson('new-access', 'new-refresh'),
        }, 200),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'en',
        dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = refreshAdapter,
      );

      await expectLater(
        client.getData<Map<String, dynamic>>(
          '/products',
          fromJson: (Object? json) => json as Map<String, dynamic>,
        ),
        throwsA(isA<ApiException>()),
      );
      // One refresh for the first 401; the retried 401 is rejected directly.
      expect(refreshAdapter.seen, hasLength(1));
      expect(adapter.seen, hasLength(2));
    });

    test('concurrent 401s share one in-flight refresh', () async {
      final _FakeTokenStorage storage = _FakeTokenStorage();
      final _FakeAdapter adapter = _FakeAdapter((RequestOptions options) {
        if (options.extra['retried'] == true) {
          return _json(<String, dynamic>{
            'data': <String, dynamic>{'ok': true},
          }, 200);
        }
        return _json(_errorEnvelope('UNAUTHORIZED'), 401);
      });
      final _FakeAdapter refreshAdapter = _FakeAdapter(
        (RequestOptions options) => _json(<String, dynamic>{
          'data': _tokensJson('new-access', 'new-refresh'),
        }, 200),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'en',
        dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = refreshAdapter,
      );

      final List<Map<String, dynamic>> results = await Future.wait(
        <Future<Map<String, dynamic>>>[
          client.getData<Map<String, dynamic>>(
            '/products',
            fromJson: (Object? json) => json as Map<String, dynamic>,
          ),
          client.getData<Map<String, dynamic>>(
            '/cart',
            fromJson: (Object? json) => json as Map<String, dynamic>,
          ),
        ],
      );
      expect(results, hasLength(2));
      expect(refreshAdapter.seen, hasLength(1));
      expect(storage.saveCalls, 1);
    });

    test('a non-401 error maps the envelope without refreshing', () async {      final _FakeTokenStorage storage = _FakeTokenStorage();
      final _FakeAdapter adapter = _FakeAdapter(
        (RequestOptions options) => _json(_errorEnvelope('VALIDATION_ERROR'), 422),
      );
      final _FakeAdapter refreshAdapter = _FakeAdapter(
        (RequestOptions options) => _json(<String, dynamic>{}, 200),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'en',
        dio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1'))
          ..httpClientAdapter = refreshAdapter,
      );

      await expectLater(
        client.getData<Map<String, dynamic>>(
          '/products',
          fromJson: (Object? json) => json as Map<String, dynamic>,
        ),
        throwsA(
          isA<ApiException>().having(
            (ApiException e) => e.code,
            'code',
            'VALIDATION_ERROR',
          ),
        ),
      );
      expect(refreshAdapter.seen, isEmpty);
      expect(storage.clearCalls, 0);
    });
  });

  group('timeouts', () {
    test('a response slower than receiveTimeout surfaces TIMEOUT', () async {
      final _FakeTokenStorage storage = _FakeTokenStorage();
      // The adapter returns headers at once but the body stream stays
      // silent for 300 ms — Dio's receiveTimeout watches the stream, so
      // a 50 ms timeout must surface TIMEOUT, not hang and not return
      // stale data.
      final _FakeAdapter adapter = _FakeAdapter(
        (RequestOptions options) => _delayedJson(<String, dynamic>{
          'data': <String, dynamic>{'ok': true},
        }, 200, 300),
      );
      final ApiClient client = ApiClient(
        tokenStorage: storage,
        localeResolver: () => 'en',
        dio: Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:3002/api/v1',
            receiveTimeout: const Duration(milliseconds: 50),
          ),
        )..httpClientAdapter = adapter,
        refreshDio: Dio(BaseOptions(baseUrl: 'http://127.0.0.1:3002/api/v1')),
      );

      await expectLater(
        client.getData<Map<String, dynamic>>(
          '/products',
          fromJson: (Object? json) => json as Map<String, dynamic>,
        ),
        throwsA(
          isA<ApiException>().having(
            (ApiException e) => e.code,
            'code',
            'TIMEOUT',
          ),
        ),
      );
    });
  });
}

/// A JSON body whose stream stays silent for [delayMs] before emitting —
/// used to prove Dio's receiveTimeout fires on a stalled body stream.
ResponseBody _delayedJson(Object? data, int statusCode, int delayMs) {
  final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonEncode(data)));
  final Stream<Uint8List> stream = Stream<Uint8List>.fromFuture(
    Future<Uint8List>.delayed(
      Duration(milliseconds: delayMs),
      () => bytes,
    ),
  );
  return ResponseBody(
    stream,
    statusCode,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}
