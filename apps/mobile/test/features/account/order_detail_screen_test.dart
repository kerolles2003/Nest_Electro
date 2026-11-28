import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/order_detail_screen.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

OrderDto _order({
  String status = 'PLACED',
  String? paymentStatus,
  String paymentMethod = 'COD',
}) {
  return OrderDto.fromJson(<String, dynamic>{
    'id': 'o1',
    'orderNumber': 'NE-1001',
    'status': status,
    'customer': <String, dynamic>{
      'fullName': 'Test User',
      'email': 'user@example.com',
      'phone': null,
    },
    'items': <dynamic>[
      <String, dynamic>{
        'productId': 'p1',
        'sku': 'ESP32-BOARD',
        'slug': 'esp32-board',
        'name': 'ESP32 Dev Board',
        'brandName': 'Espressif',
        'imagePublicId': 'nest/products/p1/hero',
        'unitPrice': <String, dynamic>{
          'amount': 20000,
          'currency': 'EGP',
          'formatted': '200.00 EGP',
        },
        'quantity': 2,
        'lineTotal': <String, dynamic>{
          'amount': 40000,
          'currency': 'EGP',
          'formatted': '400.00 EGP',
        },
      },
    ],
    'currency': 'EGP',
    'pricing': <String, dynamic>{
      'itemsSubtotal': <String, dynamic>{
        'amount': 40000,
        'currency': 'EGP',
        'formatted': '400.00 EGP',
      },
      'discountTotal': null,
      'shippingFee': <String, dynamic>{
        'amount': 5000,
        'currency': 'EGP',
        'formatted': '50.00 EGP',
      },
      'shippingPriced': true,
      'grandTotal': <String, dynamic>{
        'amount': 45000,
        'currency': 'EGP',
        'formatted': '450.00 EGP',
      },
      'vatInclusive': true,
      'vatRateBps': 1400,
    },
    'payment': <String, dynamic>{
      'method': paymentMethod,
      'status': paymentStatus ?? 'PENDING',
      'collectedAt': null,
      'verification': null,
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
}

Future<void> _pumpScreen(
  WidgetTester tester,
  _MockAccountRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        accountRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const OrderDetailScreen(orderId: 'o1'),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('shows items, totals and the cancel button for a PLACED order',
      (WidgetTester tester) async {
    final _MockAccountRepository repository = _MockAccountRepository();
    when(() => repository.getOrder('o1')).thenAnswer((_) async => _order());

    await _pumpScreen(tester, repository);

    expect(find.text('Order details'), findsOneWidget);
    expect(find.text('Order NE-1001'), findsOneWidget);
    expect(find.text('ESP32 Dev Board'), findsOneWidget);
    expect(find.text('450.00 EGP'), findsOneWidget);
    expect(find.text('Cancel order'), findsOneWidget);
    expect(find.text('Resubmit payment proof'), findsNothing);
  });

  testWidgets('shows the resubmit form for a rejected verification',
      (WidgetTester tester) async {
    final _MockAccountRepository repository = _MockAccountRepository();
    when(() => repository.getOrder('o1')).thenAnswer(
      (_) async => _order(
        paymentStatus: 'VERIFICATION_REJECTED',
        paymentMethod: 'WALLET',
      ),
    );

    await _pumpScreen(tester, repository);

    // The resubmit form sits below the fold in the lazy list.
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pump();
    expect(find.text('Resubmit payment proof'), findsOneWidget);
    // A rejected wallet order is still PLACED, so cancel stays available.
    expect(find.text('Cancel order'), findsOneWidget);
  });

  testWidgets('no cancel button for a DELIVERED order',
      (WidgetTester tester) async {
    final _MockAccountRepository repository = _MockAccountRepository();
    when(() => repository.getOrder('o1')).thenAnswer(
      (_) async => _order(status: 'DELIVERED'),
    );

    await _pumpScreen(tester, repository);

    expect(find.text('Cancel order'), findsNothing);
  });

  testWidgets('shows the error state with a retry that reloads',
      (WidgetTester tester) async {
    final _MockAccountRepository repository = _MockAccountRepository();
    when(() => repository.getOrder('o1')).thenThrow(
      const ApiException(code: 'NETWORK_ERROR', message: 'boom'),
    );

    await _pumpScreen(tester, repository);

    expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
    when(() => repository.getOrder('o1')).thenAnswer((_) async => _order());
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Order NE-1001'), findsOneWidget);
  });
}
