import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/features/checkout/presentation/order_confirmation_screen.dart';

OrderDto _order({String paymentMethod = 'COD'}) {
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
      'status': 'PENDING',
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

ManualPaymentInstructionsDto _instructions() {
  return ManualPaymentInstructionsDto.fromJson(<String, dynamic>{
    'availableMethods': <String>['COD', 'WALLET', 'INSTAPAY'],
    'walletNumber': '01099998888',
    'instapayAddress': '01099998888@instapay',
    'whatsappNumber': '201099998888',
  });
}

Future<void> _pumpScreen(WidgetTester tester, OrderConfirmationArgs args) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: OrderConfirmationScreen(args: args),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('COD order shows the number, total and cash-on-delivery note',
      (WidgetTester tester) async {
    await _pumpScreen(
      tester,
      OrderConfirmationArgs(order: _order()),
    );

    expect(find.text('Order placed'), findsOneWidget);
    expect(
      find.text('Thank you! Your order has been placed.'),
      findsOneWidget,
    );
    expect(find.text('Order NE-1001'), findsOneWidget);
    expect(find.text('450.00 EGP'), findsOneWidget);
    expect(find.text('Test User • 1 Main St, Cairo, Cairo'), findsOneWidget);
    expect(
      find.text('Please have the total ready in cash on delivery.'),
      findsOneWidget,
    );
    expect(find.text('Continue shopping'), findsOneWidget);
  });

  testWidgets('wallet order shows the transfer instructions to copy',
      (WidgetTester tester) async {
    await _pumpScreen(
      tester,
      OrderConfirmationArgs(
        order: _order(paymentMethod: 'WALLET'),
        instructions: _instructions(),
      ),
    );

    expect(find.text('Wallet: '), findsOneWidget);
    expect(find.text('01099998888'), findsOneWidget);
    expect(find.text('WhatsApp: '), findsOneWidget);
    expect(find.text('201099998888'), findsOneWidget);
    expect(
      find.text('Please have the total ready in cash on delivery.'),
      findsNothing,
    );
  });
}
