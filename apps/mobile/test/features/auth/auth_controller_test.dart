import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

AuthUserDto _user() {
  return AuthUserDto.fromJson(
    <String, dynamic>{
      'id': 'u1',
      'email': 'user@example.com',
      'fullName': 'Test User',
      'phone': null,
      'role': 'CUSTOMER',
      'emailVerified': true,
      'lastLoginAt': null,
      'createdAt': '2026-01-01T00:00:00.000Z',
    },
  );
}

LoginPayloadDto _loginPayload() {
  return LoginPayloadDto.fromJson(
    <String, dynamic>{
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
    },
  );
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _MockAuthRepository repository;
  late _MockTokenStorage tokenStorage;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(LoginDto(email: '', password: ''));
    registerFallbackValue(
      RegisterDto(email: '', password: '', fullName: ''),
    );
  });

  setUp(() {
    repository = _MockAuthRepository();
    tokenStorage = _MockTokenStorage();
    when(() => tokenStorage.hasRefreshToken)
        .thenAnswer((_) async => false);
    container = ProviderContainer(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(repository),
        tokenStorageProvider.overrideWithValue(tokenStorage),
      ],
    );
    addTearDown(container.dispose);
  });

  AuthState readState() => container.read(authControllerProvider);

  test('starts unauthenticated when no refresh token is stored', () async {
    expect(readState(), const AuthState.initial());
    await _pump();
    expect(readState(), const AuthState.unauthenticated());
  });

  test('restores the session when a refresh token is stored', () async {
    when(() => tokenStorage.hasRefreshToken).thenAnswer((_) async => true);
    when(() => repository.me()).thenAnswer((_) async => _user());

    readState();
    await _pump();

    expect(readState(), AuthState.authenticated(_user()));
    verify(() => repository.me()).called(1);
  });

  test('restoration failure leaves the user unauthenticated', () async {
    when(() => tokenStorage.hasRefreshToken).thenAnswer((_) async => true);
    when(() => repository.me()).thenThrow(
      const ApiException(
        code: 'UNAUTHENTICATED',
        message: 'Session expired.',
      ),
    );

    readState();
    await _pump();

    expect(readState().isAuthenticated, isFalse);
  });

  test('login success authenticates with the returned user', () async {
    readState();
    await _pump();

    when(() => repository.login(any())).thenAnswer(
      (_) async => _loginPayload(),
    );

    final bool ok = await container
        .read(authControllerProvider.notifier)
        .login(email: 'user@example.com', password: 'password1234');

    expect(ok, isTrue);
    expect(readState(), AuthState.authenticated(_user()));
  });

  test('login failure keeps the error in state', () async {
    readState();
    await _pump();

    when(() => repository.login(any())).thenThrow(
      const ApiException(
        code: 'INVALID_CREDENTIALS',
        message: 'Invalid email or password.',
      ),
    );

    final bool ok = await container
        .read(authControllerProvider.notifier)
        .login(email: 'user@example.com', password: 'wrong-password');

    expect(ok, isFalse);
    final AuthState state = readState();
    expect(state.isAuthenticated, isFalse);
    state.whenOrNull(
      unauthenticated: (ApiException? error) {
        expect(error?.code, 'INVALID_CREDENTIALS');
      },
    );
  });

  test('register rate limit surfaces as a rate-limited error', () async {
    readState();
    await _pump();

    when(() => repository.register(any())).thenThrow(
      const ApiException(
        code: 'RATE_LIMIT_EXCEEDED',
        message: 'Too many requests.',
        statusCode: 429,
      ),
    );

    final RegisterPayloadDto? payload = await container
        .read(authControllerProvider.notifier)
        .register(
          email: 'new@example.com',
          password: 'password1234',
          fullName: 'New User',
        );

    expect(payload, isNull);
    final AuthState state = readState();
    state.whenOrNull(
      unauthenticated: (ApiException? error) {
        expect(error?.isRateLimited, isTrue);
      },
    );
  });

  test('logout clears the session', () async {
    readState();
    await _pump();
    when(() => repository.login(any())).thenAnswer(
      (_) async => _loginPayload(),
    );
    await container.read(authControllerProvider.notifier).login(
          email: 'user@example.com',
          password: 'password1234',
        );
    expect(readState(), AuthState.authenticated(_user()));

    when(() => repository.logout()).thenAnswer((_) async {});
    await container.read(authControllerProvider.notifier).logout();

    expect(readState(), const AuthState.unauthenticated());
    verify(() => repository.logout()).called(1);
  });
}
