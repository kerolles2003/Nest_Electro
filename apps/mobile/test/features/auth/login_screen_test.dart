import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/login_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

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

void main() {
  late _MockAuthRepository repository;
  late _MockTokenStorage tokenStorage;
  late GoRouter router;

  setUpAll(() {
    registerFallbackValue(LoginDto(email: '', password: ''));
  });

  setUp(() {
    repository = _MockAuthRepository();
    tokenStorage = _MockTokenStorage();
    when(() => tokenStorage.hasRefreshToken).thenAnswer((_) async => false);
    router = GoRouter(
      initialLocation: '/login',
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('home')),
        ),
      ],
    );
  });

  Future<void> pumpLogin(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(repository),
          tokenStorageProvider.overrideWithValue(tokenStorage),
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

  testWidgets('shows validation errors for empty fields',
      (WidgetTester tester) async {
    await pumpLogin(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    verifyNever(() => repository.login(any()));
  });

  testWidgets('logs in with valid input and navigates home',
      (WidgetTester tester) async {
    when(() => repository.login(any())).thenAnswer(
      (_) async => _loginPayload(),
    );

    await pumpLogin(tester);

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
    await tester.pumpAndSettle();

    verify(() => repository.login(any())).called(1);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('wrong credentials show the error banner',
      (WidgetTester tester) async {
    when(() => repository.login(any())).thenThrow(
      const ApiException(
        code: 'INVALID_CREDENTIALS',
        message: 'Invalid email or password',
      ),
    );

    await pumpLogin(tester);

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'wrongpass1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
    await tester.pumpAndSettle();

    verify(() => repository.login(any())).called(1);
    expect(find.text('Invalid email or password'), findsOneWidget);
    expect(find.text('home'), findsNothing);
  });
}
