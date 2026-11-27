import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/profile_screen.dart';
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

AuthUserDto _user() {
  return AuthUserDto.fromJson(<String, dynamic>{
    'id': 'u1',
    'email': 'user@example.com',
    'fullName': 'Test User',
    'phone': '01000000000',
    'role': 'CUSTOMER',
    'emailVerified': true,
    'lastLoginAt': null,
    'createdAt': '2026-01-01T00:00:00.000Z',
  });
}

void main() {
  setUpAll(() {
    registerFallbackValue(const UpdateProfileDto());
  });

  late _MockAccountRepository accountRepository;
  late _MockAuthRepository authRepository;
  late _MockTokenStorage tokenStorage;
  late GoRouter router;

  setUp(() {
    accountRepository = _MockAccountRepository();
    authRepository = _MockAuthRepository();
    tokenStorage = _MockTokenStorage();
    when(() => authRepository.me()).thenAnswer((_) async => _user());
    when(
      () => tokenStorage.hasRefreshToken,
    ).thenAnswer((_) async => false);
    router = GoRouter(
      initialLocation: '/account/profile',
      routes: <RouteBase>[
        GoRoute(
          path: '/account/profile',
          builder: (BuildContext context, GoRouterState state) =>
              const ProfileScreen(),
        ),
      ],
    );
  });

  Future<void> pumpProfile(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          accountRepositoryProvider.overrideWithValue(accountRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
          tokenStorageProvider.overrideWithValue(tokenStorage),
          authControllerProvider.overrideWith(
            () => _FakeAuthController(AuthState.authenticated(_user())),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the profile and the verification state',
      (WidgetTester tester) async {
    await pumpProfile(tester);

    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('Email verified'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('01000000000'), findsOneWidget);
  });

  testWidgets('editing the name saves through the API',
      (WidgetTester tester) async {
    when(() => accountRepository.updateProfile(any())).thenAnswer(
      (_) async => UserProfileDto.fromJson(<String, dynamic>{
        'id': 'u1',
        'email': 'user@example.com',
        'fullName': 'New Name',
        'phone': '01000000000',
        'role': 'CUSTOMER',
        'emailVerified': true,
        'lastLoginAt': null,
        'createdAt': '2026-01-01T00:00:00.000Z',
      }),
    );
    await pumpProfile(tester);

    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'New Name');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    verify(
      () => accountRepository.updateProfile(
        const UpdateProfileDto(fullName: 'New Name', phone: '01000000000'),
      ),
    ).called(1);
    expect(find.text('Profile updated.'), findsOneWidget);
  });
}
