import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/cart.dart';
import 'package:nest_electro/src/features/cart/data/cart_repository.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_controller.dart';
import 'package:nest_electro/src/features/cart/data/guest_cart_storage.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockCartRepository extends Mock implements CartRepository {}

Map<String, dynamic> _lineJson(String productId, int quantity) {
  return <String, dynamic>{
    'productId': productId,
    'slug': 'slug-$productId',
    'sku': 'SKU-$productId',
    'name': 'Product $productId',
    'imagePublicId': 'nest/products/$productId/img',
    'quantity': quantity,
    'effectiveQuantity': quantity,
    'availableQuantity': 10,
    'unitPrice': <String, dynamic>{
      'amount': 10000,
      'currency': 'EGP',
      'formatted': '100.00 EGP',
    },
    'previousUnitPrice': null,
    'lineTotal': <String, dynamic>{
      'amount': 10000 * quantity,
      'currency': 'EGP',
      'formatted': '${100 * quantity}.00 EGP',
    },
    'status': 'OK',
    'addedAt': '2026-01-01T00:00:00.000Z',
  };
}

CartDto _cart(List<Map<String, dynamic>> items) {
  return CartDto.fromJson(<String, dynamic>{
    'items': items,
    'itemCount': items.length,
    'totalQuantity': items.fold<int>(
      0,
      (int sum, Map<String, dynamic> l) => sum + (l['quantity'] as int),
    ),
    'itemsSubtotal': <String, dynamic>{
      'amount': 10000,
      'currency': 'EGP',
      'formatted': '100.00 EGP',
    },
    'currency': 'EGP',
    'hasBlockingIssues': false,
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'expiresAt': '2026-01-02T00:00:00.000Z',
  });
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    registerFallbackValue(
      const GuestCartLineDto(productId: '', quantity: 0),
    );
  });

  late _MockCartRepository repository;
  late GoRouter router;

  setUp(() async {
    repository = _MockCartRepository();
    await (await SharedPreferences.getInstance()).clear();
    router = GoRouter(
      initialLocation: '/cart',
      routes: <RouteBase>[
        GoRoute(
          path: '/cart',
          builder: (BuildContext context, GoRouterState state) =>
              const CartScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('login')),
        ),
        GoRoute(
          path: '/checkout',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('checkout')),
        ),
      ],
    );
  });

  Future<void> pumpCart(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          cartRepositoryProvider.overrideWithValue(repository),
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

  testWidgets('empty guest cart shows the empty state', (WidgetTester tester) async {
    await pumpCart(tester);
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Log in to check out'), findsNothing);
  });

  testWidgets('guest lines are priced and rendered', (WidgetTester tester) async {
    await GuestCartStorage().save(
      const <GuestCartLineDto>[
        GuestCartLineDto(productId: 'p1', quantity: 2),
      ],
    );
    when(() => repository.preview(any())).thenAnswer(
      (_) async => _cart(<Map<String, dynamic>>[_lineJson('p1', 2)]),
    );

    await pumpCart(tester);

    expect(find.text('Product p1'), findsOneWidget);
    expect(find.text('200.00 EGP'), findsOneWidget);
    // Guests check out through the login screen.
    expect(find.text('Log in to check out'), findsOneWidget);
    verify(() => repository.preview(any())).called(1);
  });

  testWidgets('stepper increases the guest quantity', (WidgetTester tester) async {
    await GuestCartStorage().save(
      const <GuestCartLineDto>[
        GuestCartLineDto(productId: 'p1', quantity: 1),
      ],
    );
    when(() => repository.preview(any())).thenAnswer(
      (Invocation inv) async {
        final List<GuestCartLineDto> lines =
            inv.positionalArguments[0] as List<GuestCartLineDto>;
        return _cart(
          lines
              .map(
                (GuestCartLineDto l) =>
                    _lineJson(l.productId, l.quantity),
              )
              .toList(),
        );
      },
    );

    await pumpCart(tester);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Product p1'), findsOneWidget);
    final List<GuestCartLineDto> stored = await GuestCartStorage().load();
    expect(stored.single.quantity, 2);
  });
}
