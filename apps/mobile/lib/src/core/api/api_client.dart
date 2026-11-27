import 'package:dio/dio.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/pagination.dart';

/// Public auth endpoints that never carry an Authorization header.
const Set<String> _publicAuthPaths = <String>{
  '/auth/login',
  '/auth/register',
  '/auth/refresh',
  '/auth/forgot-password',
  '/auth/reset-password',
  '/auth/verify-email',
  '/auth/resend-verification',
};

/// Dio client for `apps/api`. Every call either returns parsed data or
/// throws [ApiException] — repositories never see [DioException].
///
/// - Base URL from `--dart-define=API_BASE_URL` (D-02).
/// - `Accept-Language` follows the app locale (D-12).
/// - Bearer token attached from secure storage; on 401 the refresh token is
///   rotated once (concurrent 401s share one refresh) and the request is
///   retried a single time. A failed refresh clears the tokens.
class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    required String Function() localeResolver,
    Dio? dio,
    Dio? refreshDio,
  })  : _tokenStorage = tokenStorage,
        _localeResolver = localeResolver,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 30),
              ),
            ),
        _refreshDio = refreshDio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 30),
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  final TokenStorage _tokenStorage;
  final String Function() _localeResolver;
  final Dio _dio;
  final Dio _refreshDio;

  /// Shared in-flight refresh so concurrent 401s rotate the token once.
  Future<SessionTokensDto>? _refreshFuture;

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = _localeResolver();
    if (!_publicAuthPaths.contains(options.path)) {
      final String? token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final RequestOptions request = err.requestOptions;
    final bool isRefreshCall = request.path == '/auth/refresh';
    if (err.response?.statusCode == 401 &&
        request.extra['retried'] != true &&
        !isRefreshCall) {
      try {
        await _refreshTokens();
        final RequestOptions retryRequest = request
          ..extra['retried'] = true;
        final Response<dynamic> response =
            await _dio.fetch<dynamic>(retryRequest);
        return handler.resolve(response);
      } on Object {
        await _tokenStorage.clear();
        return handler.reject(_withApiError(err));
      }
    }
    return handler.reject(_withApiError(err));
  }

  DioException _withApiError(DioException err) {
    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: ApiException.fromDio(err),
    );
  }

  Future<SessionTokensDto> _refreshTokens() {
    final Future<SessionTokensDto>? inFlight = _refreshFuture;
    if (inFlight != null) {
      return inFlight;
    }
    final Future<SessionTokensDto> future = _performRefresh();
    _refreshFuture = future;
    return future.whenComplete(() => _refreshFuture = null);
  }

  Future<SessionTokensDto> _performRefresh() async {
    final String? refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const ApiException(
        code: 'UNAUTHENTICATED',
        message: 'Session expired. Please log in again.',
      );
    }
    try {
      final Response<dynamic> response = await _refreshDio.post<dynamic>(
        '/auth/refresh',
        data: RefreshTokenDto(refreshToken: refreshToken).toJson(),
      );
      final SessionTokensDto tokens = SessionTokensDto.fromJson(
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );
      await _tokenStorage.saveTokens(tokens);
      return tokens;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// GET a single-object envelope `{ data: T }`.
  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return fromJson((response.data as Map<String, dynamic>)['data']);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// GET a paginated envelope `{ data: [...], meta: {...}, facets?: {...} }`.
  Future<PaginatedList<T>> getPage<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return PaginatedList<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// POST a single-object envelope `{ data: T }`.
  Future<T> postData<T>(
    String path, {
    Object? body,
    Map<String, String>? headers,
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: body,
        options: Options(headers: headers),
      );
      return fromJson((response.data as Map<String, dynamic>)['data']);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// PATCH a single-object envelope `{ data: T }`.
  Future<T> patchData<T>(
    String path, {
    Object? body,
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch<dynamic>(
        path,
        data: body,
      );
      return fromJson((response.data as Map<String, dynamic>)['data']);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// DELETE a single-object envelope `{ data: T }`.
  Future<T> deleteData<T>(
    String path, {
    required T Function(Object? json) fromJson,
  }) async {
    try {
      final Response<dynamic> response = await _dio.delete<dynamic>(path);
      return fromJson((response.data as Map<String, dynamic>)['data']);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
