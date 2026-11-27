import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/addresses_screen.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

AddressDto _address(String id, {bool isDefault = false}) {
  return AddressDto.fromJson(<String, dynamic>{
    'id': id,
    'label': 'Home',
    'fullName': 'Test User',
    'phone': '01000000000',
    'street': '1 Main St',
    'city': 'Cairo',
    'governorate': 'Cairo',
    'postalCode': '',
    'isDefault': isDefault,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
  });
}

void main() {
  late _MockAccountRepository repository;
  late GoRouter router;

  setUp(() {
    repository = _MockAccountRepository();
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[
        _address('a1', isDefault: true),
        _address('a2'),
      ],
    );
    router = GoRouter(
      initialLocation: '/account/addresses',
      routes: <RouteBase>[
        GoRoute(
          path: '/account/addresses',
          builder: (BuildContext context, GoRouterState state) =>
              const AddressesScreen(),
        ),
      ],
    );
  });

  Future<void> pumpAddresses(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          accountRepositoryProvider.overrideWithValue(repository),
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

  testWidgets('lists addresses with the default badge',
      (WidgetTester tester) async {
    await pumpAddresses(tester);

    expect(find.text('Home'), findsNWidgets(2));
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Set as default'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation then deletes',
      (WidgetTester tester) async {
    when(() => repository.deleteAddress(any())).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    await pumpAddresses(tester);

    // Open the overflow menu of the second address and delete it.
    await tester.tap(find.byType(PopupMenuButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete address').last);
    await tester.pumpAndSettle();
    expect(find.text('Delete this address?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete address'));
    await tester.pumpAndSettle();

    verify(() => repository.deleteAddress('a2')).called(1);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('set as default calls the API', (WidgetTester tester) async {
    when(() => repository.setDefaultAddress(any())).thenAnswer(
      (_) async => <AddressDto>[
        _address('a1'),
        _address('a2', isDefault: true),
      ],
    );
    await pumpAddresses(tester);

    await tester.tap(find.text('Set as default'));
    await tester.pumpAndSettle();
    verify(() => repository.setDefaultAddress('a2')).called(1);
  });
}
