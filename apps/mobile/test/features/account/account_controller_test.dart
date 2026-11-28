import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/account_controller.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _FakeAuthController extends AuthController {
  _FakeAuthController(this.fixed);

  final AuthState fixed;

  @override
  AuthState build() => fixed;
}

AuthUserDto _user({String fullName = 'Test User'}) {
  return AuthUserDto.fromJson(<String, dynamic>{
    'id': 'u1',
    'email': 'user@example.com',
    'fullName': fullName,
    'phone': '01000000000',
    'role': 'CUSTOMER',
    'emailVerified': true,
    'lastLoginAt': null,
    'createdAt': '2026-01-01T00:00:00.000Z',
  });
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(const UpdateProfileDto());
  });

  late _MockAccountRepository accountRepository;
  late _MockAuthRepository authRepository;
  late _MockTokenStorage tokenStorage;
  late ProviderContainer container;

  setUp(() {
    accountRepository = _MockAccountRepository();
    authRepository = _MockAuthRepository();
    tokenStorage = _MockTokenStorage();
    when(() => authRepository.me()).thenAnswer((_) async => _user());
    // refresh() re-runs the real _restore(): no stored refresh token, so
    // it lands unauthenticated without touching platform channels.
    when(
      () => tokenStorage.hasRefreshToken,
    ).thenAnswer((_) async => false);
    container = ProviderContainer(
      overrides: <Override>[
        accountRepositoryProvider.overrideWithValue(accountRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        tokenStorageProvider.overrideWithValue(tokenStorage),
        authControllerProvider.overrideWith(
          () => _FakeAuthController(AuthState.authenticated(_user())),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('loads the session user on start', () async {
    container.read(accountControllerProvider.notifier);
    await _pump();

    final AccountState state = container.read(accountControllerProvider);
    expect(state.isLoading, false);
    expect(state.user?.fullName, 'Test User');
    verify(() => authRepository.me()).called(1);
  });

  test('updateProfile PATCHes and refreshes the session user', () async {
    when(() => accountRepository.updateProfile(any())).thenAnswer(
      (_) async => UserProfileDto.fromJson(<String, dynamic>{
        'id': 'u1',
        'email': 'user@example.com',
        'fullName': 'New Name',
        'phone': '01011112222',
        'role': 'CUSTOMER',
        'emailVerified': true,
        'lastLoginAt': null,
        'createdAt': '2026-01-01T00:00:00.000Z',
      }),
    );
    // After refresh() the fake auth controller still returns the fixed
    // user; the test asserts the PATCH call and the success result.
    final AccountController controller = container.read(
      accountControllerProvider.notifier,
    );
    await _pump();

    expect(
      await controller.updateProfile(
        fullName: 'New Name',
        phone: '01011112222',
      ),
      true,
    );
    verify(
      () => accountRepository.updateProfile(
        const UpdateProfileDto(
          fullName: 'New Name',
          phone: '01011112222',
        ),
      ),
    ).called(1);
    expect(container.read(accountControllerProvider).isSaving, false);
  });

  test('updateProfile failure keeps the error in state', () async {
    when(() => accountRepository.updateProfile(any())).thenThrow(
      const ApiException(code: 'VALIDATION_ERROR', message: 'bad name'),
    );
    final AccountController controller = container.read(
      accountControllerProvider.notifier,
    );
    await _pump();

    expect(await controller.updateProfile(fullName: 'x'), false);
    expect(
      container.read(accountControllerProvider).error?.code,
      'VALIDATION_ERROR',
    );
  });

  test('non-API load failure surfaces LOAD_FAILED instead of spinning',
      () async {
    // Phase 10: a platform/storage failure is not an ApiException — the
    // load must still end with an error state, never isLoading forever.
    when(() => authRepository.me()).thenThrow(
      StateError('secure storage failure'),
    );
    container.read(accountControllerProvider.notifier);
    await _pump();

    final AccountState state = container.read(accountControllerProvider);
    expect(state.isLoading, false);
    expect(state.error?.code, 'LOAD_FAILED');
    expect(state.user, isNull);
  });
}
