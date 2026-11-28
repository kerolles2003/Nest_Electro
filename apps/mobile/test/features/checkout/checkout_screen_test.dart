import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/checkout/data/checkout_repository.dart';
import 'package:nest_electro/src/features/checkout/presentation/checkout_controller.dart';
import 'package:nest_electro/src/features/checkout/presentation/checkout_screen.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

class _FakeAuthController extends AuthController {
  _FakeAuthController(this.fixed);

  final AuthState fixed;

  @override
  AuthState build() => fixed;
}

AddressDto _address() {
  return AddressDto.fromJson(<String, dynamic>{
    'id': 'a1',
    'label': 'Home',
    'fullName': 'Test User',
    'phone': '01000000000',
    'street': '1 Main St',
    'city': 'Cairo',
    'governorate': 'Cairo',
    'postalCode': '',
    'isDefault': true,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
  });
}

CheckoutQuoteViewDto _quote() {
  return CheckoutQuoteViewDto.fromJson(<String, dynamic>{
    'items': <dynamic>[],
    'itemCount': 0,
    'totalQuantity': 0,
    'currency': 'EGP',
    'pricing': <String, dynamic>{
      'itemsSubtotal': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'discountTotal': null,
      'shippingFee': <String, dynamic>{
        'amount': 5000,
        'currency': 'EGP',
        'formatted': '50.00 EGP',
      },
      'shippingPriced': true,
      'grandTotal': <String, dynamic>{
        'amount': 15000,
        'currency': 'EGP',
        'formatted': '150.00 EGP',
      },
      'vatInclusive': true,
      'vatRateBps': 1400,
    },
    'hasBlockingIssues': false,
    'canPlaceOrder': true,
    'generatedAt': '2026-01-01T00:00:00.000Z',
  });
}

OrderDto _order() {
  return OrderDto.fromJson(<String, dynamic>{
    'id': 'o1',
    'orderNumber': 'NE-1001',
    'status': 'PLACED',
    'customer': <String, dynamic>{
      'fullName': 'Test User',
      'email': 'user@example.com',
      'phone': null,
    },
    'items': <dynamic>[],
    'currency': 'EGP',
    'pricing': <String, dynamic>{
      'itemsSubtotal': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'discountTotal': null,
      'shippingFee': null,
      'shippingPriced': false,
      'grandTotal': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'vatInclusive': true,
      'vatRateBps': 1400,
    },
    'payment': null,
    'shippingAddress': <String, dynamic>{
      'fullName': 'Test User',
      'phone': '01000000000',
      'street': '1 Main St',
      'city': 'Cairo',
      'governorate': 'Cairo',
      'postalCode': '',
    },
    'customerNote': '',
    'cancellation': null,
    'shipment': null,
    'placedAt': '2026-01-01T00:00:00.000Z',
  });
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const PlaceOrderDto(addressId: ''),
    );
  });

  late _MockCheckoutRepository repository;
  late GoRouter router;

  setUp(() {
    repository = _MockCheckoutRepository();
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address()],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => ManualPaymentInstructionsDto.fromJson(<String, dynamic>{
        'availableMethods': <String>['COD', 'WALLET', 'INSTAPAY'],
        'walletNumber': '01099998888',
        'instapayAddress': '01099998888@instapay',
        'whatsappNumber': '201099998888',
      }),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );
    when(() => repository.placeOrder(any(), any())).thenAnswer(
      (_) async => _order(),
    );
    router = GoRouter(
      initialLocation: '/checkout',
      routes: <RouteBase>[
        GoRoute(
          path: '/checkout',
          builder: (BuildContext context, GoRouterState state) =>
              const CheckoutScreen(),
        ),
        GoRoute(
          path: '/checkout/confirmation',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('confirmation')),
        ),
      ],
    );
  });

  Future<void> pumpCheckout(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          checkoutRepositoryProvider.overrideWithValue(repository),
          authControllerProvider.overrideWith(
            () => _FakeAuthController(
              AuthState.authenticated(
                AuthUserDto.fromJson(<String, dynamic>{
                  'id': 'u1',
                  'email': 'user@example.com',
                  'fullName': 'Test User',
                  'phone': null,
                  'role': 'CUSTOMER',
                  'emailVerified': true,
                  'lastLoginAt': null,
                  'createdAt': '2026-01-01T00:00:00.000Z',
                }),
              ),
            ),
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

  testWidgets('renders address, quote and payment methods',
      (WidgetTester tester) async {
    await pumpCheckout(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('150.00 EGP'), findsNWidgets(2));
    expect(find.text('Cash on delivery'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
    expect(find.text('InstaPay'), findsOneWidget);
    expect(find.text('Place order'), findsOneWidget);
  });

  testWidgets('placing the order navigates to confirmation',
      (WidgetTester tester) async {
    await pumpCheckout(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Place order'));
    await tester.pumpAndSettle();

    expect(find.text('confirmation'), findsOneWidget);
    verify(() => repository.placeOrder(any(), any())).called(1);
  });

  testWidgets('wallet shows transfer instructions and sender field',
      (WidgetTester tester) async {
    await pumpCheckout(tester);

    // The payment section sits below the fold on the test viewport.
    await tester.ensureVisible(find.text('Wallet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wallet'));
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (Widget w) =>
            w is SelectableText && w.data == '01099998888',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Transfer the total'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });

  testWidgets('load failure shows the error state with a retry',
      (WidgetTester tester) async {
    // Phase 10: a non-API address failure surfaces LOAD_FAILED in the
    // controller instead of spinning forever — the screen shows its
    // error state and the retry recovers.
    when(() => repository.listAddresses()).thenThrow(
      StateError('platform failure'),
    );

    await pumpCheckout(tester);

    expect(find.text("Couldn't load products"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Place order'), findsNothing);

    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address()],
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Place order'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
