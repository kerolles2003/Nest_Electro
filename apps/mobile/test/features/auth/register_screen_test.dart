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
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/register_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late _MockAuthRepository repository;
  late _MockTokenStorage tokenStorage;
  late GoRouter router;

  setUpAll(() {
    registerFallbackValue(
      const RegisterDto(email: '', password: '', fullName: ''),
    );
  });

  setUp(() {
    repository = _MockAuthRepository();
    tokenStorage = _MockTokenStorage();
    when(() => tokenStorage.hasRefreshToken).thenAnswer((_) async => false);
    router = GoRouter(
      initialLocation: '/register',
      routes: <RouteBase>[
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) =>
              const RegisterScreen(),
        ),
        GoRoute(
          path: '/verify-email',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('verify-email')),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('login')),
        ),
      ],
    );
  });

  Future<void> pumpRegister(WidgetTester tester) async {
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
          supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows validation errors for empty fields',
      (WidgetTester tester) async {
    await pumpRegister(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
    await tester.pump();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    verifyNever(() => repository.register(any()));
  });

  testWidgets('registers and navigates to email verification',
      (WidgetTester tester) async {
    when(() => repository.register(any())).thenAnswer(
      (_) async => const RegisterPayloadDto(
        message: 'Verify your email',
        emailVerificationRequired: true,
      ),
    );

    await pumpRegister(tester);

    final List<TextFormField> fields =
        find.byType(TextFormField).evaluate().map((Element e) {
      return e.widget as TextFormField;
    }).toList();
    expect(fields, hasLength(5));
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'new@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '01012345678');
    await tester.enterText(find.byType(TextFormField).at(3), 'password1234');
    await tester.enterText(find.byType(TextFormField).at(4), 'password1234');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Create account'));
    await tester.pumpAndSettle();

    final RegisterDto sent =
        verify(() => repository.register(captureAny())).captured.single
            as RegisterDto;
    expect(sent.email, 'new@example.com');
    expect(sent.fullName, 'Test User');
    expect(sent.phone, '01012345678');
    expect(find.text('verify-email'), findsOneWidget);
  });
}
