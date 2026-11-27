import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/order_detail_screen.dart';
import 'package:nest_electro/src/features/account/presentation/orders_screen.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

Map<String, dynamic> _pricingJson() {
  return <String, dynamic>{
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
  };
}

OrderSummaryDto _summary(String id, String status) {
  return OrderSummaryDto.fromJson(<String, dynamic>{
    'id': id,
    'orderNumber': 'NE-$id',
    'status': status,
    'payment': null,
    'pricing': _pricingJson(),
    'itemCount': 1,
    'totalQuantity': 1,
    'previewImagePublicId': 'nest/products/p1/img',
    'placedAt': '2026-01-01T00:00:00.000Z',
  });
}

PaginatedList<OrderSummaryDto> _page(List<OrderSummaryDto> items) {
  return PaginatedList<OrderSummaryDto>(
    items: items,
    meta: PaginationMetaDto.fromJson(<String, dynamic>{
      'page': 1,
      'limit': 20,
      'total': items.length,
      'totalPages': 1,
      'hasNext': false,
      'hasPrev': false,
    }),
  );
}

Future<void> pumpWithRouter(
  WidgetTester tester,
  MockAccountRepository repository,
  GoRouter router,
) async {
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

void main() {
  setUpAll(() {
    registerFallbackValue(OrderStatus.placed);
  });

  late MockAccountRepository repository;

  setUp(() {
    repository = MockAccountRepository();
  });

  testWidgets('orders list renders and the filter reloads',
      (WidgetTester tester) async {
    when(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => _page(<OrderSummaryDto>[
        _summary('o1', 'PLACED'),
        _summary('o2', 'DELIVERED'),
      ]),
    );
    final GoRouter router = GoRouter(
      initialLocation: '/account/orders',
      routes: <RouteBase>[
        GoRoute(
          path: '/account/orders',
          builder: (BuildContext context, GoRouterState state) =>
              const OrdersScreen(),
        ),
        GoRoute(
          path: '/account/orders/:id',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('detail')),
        ),
      ],
    );

    await pumpWithRouter(tester, repository, router);

    expect(find.text('Order NE-o1'), findsOneWidget);
    expect(find.text('Order NE-o2'), findsOneWidget);
    expect(find.text('100.00 EGP'), findsWidgets);

    await tester.tap(find.widgetWithText(FilterChip, 'Delivered'));
    await tester.pumpAndSettle();
    verify(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: OrderStatus.delivered,
      ),
    ).called(1);
  });

  testWidgets('empty orders show the empty state',
      (WidgetTester tester) async {
    when(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) async => _page(const <OrderSummaryDto>[]));
    final GoRouter router = GoRouter(
      initialLocation: '/account/orders',
      routes: <RouteBase>[
        GoRoute(
          path: '/account/orders',
          builder: (BuildContext context, GoRouterState state) =>
              const OrdersScreen(),
        ),
      ],
    );

    await pumpWithRouter(tester, repository, router);
    expect(find.text('You have no orders yet.'), findsOneWidget);
  });

  testWidgets('order detail shows cancel and resubmit actions',
      (WidgetTester tester) async {
    final OrderDto order = OrderDto.fromJson(<String, dynamic>{
      'id': 'o1',
      'orderNumber': 'NE-1001',
      'status': 'PLACED',
      'customer': <String, dynamic>{
        'fullName': 'Test User',
        'email': 'user@example.com',
        'phone': null,
      },
      'items': <dynamic>[
        <String, dynamic>{
          'productId': 'p1',
          'sku': 'SKU-p1',
          'slug': 'slug-p1',
          'name': 'Product p1',
          'brandName': '',
          'imagePublicId': 'nest/products/p1/img',
          'unitPrice': <String, dynamic>{
            'amount': 10000,
            'currency': 'EGP',
            'formatted': '100.00 EGP',
          },
          'quantity': 1,
          'lineTotal': <String, dynamic>{
            'amount': 10000,
            'currency': 'EGP',
            'formatted': '100.00 EGP',
          },
        },
      ],
      'currency': 'EGP',
      'pricing': _pricingJson(),
      'payment': <String, dynamic>{
        'method': 'WALLET',
        'status': 'VERIFICATION_REJECTED',
        'collectedAt': null,
        'verification': <String, dynamic>{
          'transferSender': '01000000000',
          'submittedAt': '2026-01-01T00:00:00.000Z',
          'decidedAt': null,
          'decisionNote': null,
        },
      },
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
    when(() => repository.getOrder(any())).thenAnswer((_) async => order);
    when(() => repository.cancelOrder(any(), any())).thenAnswer(
      (_) async => order,
    );
    when(() => repository.resubmitPayment(any(), any())).thenAnswer(
      (_) async => order,
    );
    final GoRouter router = GoRouter(
      initialLocation: '/account/orders/o1',
      routes: <RouteBase>[
        GoRoute(
          path: '/account/orders/:id',
          builder: (BuildContext context, GoRouterState state) =>
              OrderDetailScreen(orderId: state.pathParameters['id']!),
        ),
      ],
    );

    await pumpWithRouter(tester, repository, router);

    expect(find.text('Order NE-1001'), findsOneWidget);
    expect(find.text('Product p1'), findsOneWidget);
    expect(find.text('Payment verification rejected'), findsOneWidget);

    // Cancel flow: dialog → confirm → repository call. The detail list
    // builds lazily, so drag it down until the button exists (one drag
    // is enough on the test viewport).
    for (int i = 0; i < 6; i++) {
      if (find.text('Cancel order').evaluate().isNotEmpty) {
        break;
      }
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Cancel order'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel this order?'), findsOneWidget);
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      'changed my mind',
    );
    await tester.tap(find.text('Yes, cancel the order'));
    await tester.pumpAndSettle();
    verify(() => repository.cancelOrder('o1', 'changed my mind')).called(1);

    // Resubmit flow: enter the sender account → resubmit.
    for (int i = 0; i < 6; i++) {
      if (find.text('Resubmit payment proof').evaluate().isNotEmpty) {
        break;
      }
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    await tester.enterText(
      find.byType(TextField).last,
      '01011112222',
    );
    await tester.tap(find.text('Resubmit payment proof'));
    await tester.pumpAndSettle();
    verify(() => repository.resubmitPayment('o1', '01011112222')).called(1);
  });
}
