import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';

/// Fake client: records path/body/headers and returns canned data.
/// Unlike the mocktail mocks in the screen tests, the repository tests
/// assert the exact path and body each method sends.
class _FakeApiClient extends Fake implements ApiClient {
  String? lastPath;
  Object? lastBody;
  Map<String, String>? lastHeaders;
  dynamic dataToReturn;
  bool throwOnPost = false;

  @override
  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    return dataToReturn as T;
  }

  @override
  Future<PaginatedList<T>> getPage<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    return dataToReturn as PaginatedList<T>;
  }

  @override
  Future<T> postData<T>(
    String path, {
    Object? body,
    Map<String, String>? headers,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastBody = body;
    lastHeaders = headers;
    if (throwOnPost) {
      throw const ApiException(code: 'NETWORK_ERROR', message: 'down');
    }
    return dataToReturn as T;
  }

  @override
  Future<T> patchData<T>(
    String path, {
    Object? body,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastBody = body;
    return dataToReturn as T;
  }

  @override
  Future<T> deleteData<T>(
    String path, {
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    return dataToReturn as T;
  }
}

class _FakeTokenStorage extends Fake implements TokenStorage {
  SessionTokensDto? saved;
  String? refreshToken = 'refresh-1';
  int clearCalls = 0;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens(SessionTokensDto tokens) async {
    saved = tokens;
  }

  @override
  Future<void> clear() async {
    clearCalls++;
    saved = null;
    refreshToken = null;
  }
}

LoginPayloadDto _loginPayload() {
  return LoginPayloadDto.fromJson(<String, dynamic>{
    'tokenType': 'Bearer',
    'accessToken': 'access-1',
    'expiresIn': 900,
    'accessTokenExpiresAt': '2026-11-27T10:15:00.000Z',
    'refreshToken': 'refresh-1',
    'refreshTokenExpiresAt': '2026-12-04T10:00:00.000Z',
    'user': <String, dynamic>{
      'id': 'u1',
      'email': 'user@example.com',
      'fullName': 'Test User',
      'phone': null,
      'role': 'CUSTOMER',
      'emailVerified': true,
      'lastLoginAt': null,
      'createdAt': '2026-01-01T00:00:00.000Z',
    },
  });
}

AuthUserDto _user() {
  return AuthUserDto.fromJson(<String, dynamic>{
    'id': 'u1',
    'email': 'user@example.com',
    'fullName': 'Test User',
    'phone': null,
    'role': 'CUSTOMER',
    'emailVerified': true,
    'lastLoginAt': null,
    'createdAt': '2026-01-01T00:00:00.000Z',
  });
}

void main() {
  late _FakeApiClient client;
  late _FakeTokenStorage storage;
  late AuthRepository repository;

  setUp(() {
    client = _FakeApiClient();
    storage = _FakeTokenStorage();
    repository = AuthRepository(client: client, tokenStorage: storage);
  });

  test('login posts /auth/login and saves the session tokens', () async {
    client.dataToReturn = _loginPayload();

    final LoginPayloadDto payload = await repository.login(
      const LoginDto(email: 'user@example.com', password: 'password1234'),
    );

    expect(client.lastPath, '/auth/login');
    expect(
      client.lastBody,
      <String, dynamic>{
        'email': 'user@example.com',
        'password': 'password1234',
      },
    );
    expect(payload.user.email, 'user@example.com');
    expect(storage.saved?.accessToken, 'access-1');
    expect(storage.saved?.refreshToken, 'refresh-1');
  });

  test('register posts /auth/register and does not save tokens', () async {
    client.dataToReturn = const RegisterPayloadDto(
      message: 'Verify your email',
      emailVerificationRequired: true,
    );

    await repository.register(
      const RegisterDto(
        email: 'new@example.com',
        password: 'password1234',
        fullName: 'New User',
        phone: '01012345678',
      ),
    );

    expect(client.lastPath, '/auth/register');
    expect(
      client.lastBody,
      <String, dynamic>{
        'email': 'new@example.com',
        'password': 'password1234',
        'fullName': 'New User',
        'phone': '01012345678',
      },
    );
    expect(storage.saved, isNull);
  });

  test('logout posts the refresh token and clears storage even on failure',
      () async {
    client.dataToReturn = const MessagePayloadDto(message: 'ok');
    client.throwOnPost = true;

    // logout() clears storage in a `finally` but still propagates the
    // server error — the caller sees the failure, the session is gone.
    await expectLater(repository.logout(), throwsA(isA<ApiException>()));

    expect(client.lastPath, '/auth/logout');
    expect(
      client.lastBody,
      <String, dynamic>{'refreshToken': 'refresh-1'},
    );
    expect(storage.clearCalls, 1);
  });

  test('logoutAll posts /auth/logout-all and clears storage', () async {
    client.dataToReturn = const MessagePayloadDto(message: 'ok');

    await repository.logoutAll();

    expect(client.lastPath, '/auth/logout-all');
    expect(storage.clearCalls, 1);
  });

  test('me gets /auth/me', () async {
    client.dataToReturn = _user();

    final AuthUserDto user = await repository.me();

    expect(client.lastPath, '/auth/me');
    expect(user.id, 'u1');
  });

  test('forgot/reset/verify/resend hit their endpoints', () async {
    client.dataToReturn = const MessagePayloadDto(message: 'ok');

    await repository.forgotPassword('user@example.com');
    expect(client.lastPath, '/auth/forgot-password');
    expect(client.lastBody, <String, dynamic>{'email': 'user@example.com'});

    await repository.resetPassword(
      const ResetPasswordDto(token: 't1', newPassword: 'newpassword123'),
    );
    expect(client.lastPath, '/auth/reset-password');
    expect(
      client.lastBody,
      <String, dynamic>{'token': 't1', 'newPassword': 'newpassword123'},
    );

    await repository.verifyEmail('verify-1');
    expect(client.lastPath, '/auth/verify-email');
    expect(client.lastBody, <String, dynamic>{'token': 'verify-1'});

    await repository.resendVerification('user@example.com');
    expect(client.lastPath, '/auth/resend-verification');
    expect(client.lastBody, <String, dynamic>{'email': 'user@example.com'});
  });
}
