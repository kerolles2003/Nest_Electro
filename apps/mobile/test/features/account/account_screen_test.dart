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
import 'package:nest_electro/src/features/account/presentation/account_screen.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';

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
  late _MockAuthRepository authRepository;
  late _MockTokenStorage tokenStorage;
  late GoRouter router;

  setUp(() {
    authRepository = _MockAuthRepository();
    tokenStorage = _MockTokenStorage();
    when(() => authRepository.logout()).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
    router = GoRouter(
      initialLocation: '/account',
      routes: <RouteBase>[
        GoRoute(
          path: '/account',
          builder: (BuildContext context, GoRouterState state) =>
              const AccountScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('home')),
        ),
        GoRoute(
          path: '/account/profile',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('profile')),
        ),
        GoRoute(
          path: '/account/orders',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('orders')),
        ),
        GoRoute(
          path: '/account/addresses',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('addresses')),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('wishlist')),
        ),
      ],
    );
  });

  Future<void> pumpAccount(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
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
          supportedLocales: const <Locale>[
            Locale('ar'),
            Locale('en'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the user and the menu entries',
      (WidgetTester tester) async {
    await pumpAccount(tester);

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My orders'), findsOneWidget);
    expect(find.text('My addresses'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('tapping a menu entry navigates', (WidgetTester tester) async {
    await pumpAccount(tester);

    await tester.tap(find.text('My orders'));
    await tester.pumpAndSettle();
    expect(find.text('orders'), findsOneWidget);
  });

  testWidgets('log out clears the session and goes home',
      (WidgetTester tester) async {
    await pumpAccount(tester);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    // Token clearing lives inside the real AuthRepository.logout()
    // (best-effort server call, then clear) — with a mocked repository
    // the observable call is the repository logout itself.
    verify(() => authRepository.logout()).called(1);
    expect(find.text('home'), findsOneWidget);
  });
}
