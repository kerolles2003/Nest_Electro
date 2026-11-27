import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/checkout/data/checkout_repository.dart';
import 'package:nest_electro/src/features/checkout/presentation/checkout_controller.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

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

ManualPaymentInstructionsDto _methods() {
  return ManualPaymentInstructionsDto.fromJson(<String, dynamic>{
    'availableMethods': <String>['COD', 'WALLET', 'INSTAPAY'],
    'walletNumber': '01099998888',
    'instapayAddress': '01099998888@instapay',
    'whatsappNumber': '201099998888',
  });
}

CheckoutQuoteViewDto _quote({bool canPlaceOrder = true}) {
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
    'canPlaceOrder': canPlaceOrder,
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

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const PlaceOrderDto(addressId: ''),
    );
    registerFallbackValue(
      const CreateAddressDto(
        label: '',
        fullName: '',
        phone: '',
        street: '',
        city: '',
        governorate: '',
      ),
    );
  });

  late _MockCheckoutRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockCheckoutRepository();
    container = ProviderContainer(
      overrides: <Override>[
        checkoutRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<CheckoutController> loadController() async {
    final CheckoutController controller = container.read(
      checkoutControllerProvider.notifier,
    );
    await _pump();
    return controller;
  }

  test('loads addresses, picks the default, and fetches its quote', () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[
        _address('a1'),
        _address('a2', isDefault: true),
      ],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );

    await loadController();
    final CheckoutState state = container.read(checkoutControllerProvider);

    expect(state.isLoading, false);
    expect(state.selectedAddressId, 'a2');
    expect(state.selectedPaymentMethod, PaymentMethod.cod);
    expect(state.availableMethods, <PaymentMethod>[
      PaymentMethod.cod,
      PaymentMethod.wallet,
      PaymentMethod.instapay,
    ]);
    expect(state.quote?.pricing.grandTotal.formatted, '150.00 EGP');
    expect(state.canPlaceOrder, true);
    verify(() => repository.getQuote('a2')).called(1);
  });

  test('selecting another address re-quotes', () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1'), _address('a2')],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );

    final CheckoutController controller = await loadController();
    await controller.selectAddress('a2');
    await _pump();

    expect(
      container.read(checkoutControllerProvider).selectedAddressId,
      'a2',
    );
    verify(() => repository.getQuote('a2')).called(1);
  });

  test('payment-methods failure degrades to COD-only', () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.getPaymentMethods()).thenThrow(
      const ApiException(code: 'NETWORK_ERROR', message: 'boom'),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );

    await loadController();
    final CheckoutState state = container.read(checkoutControllerProvider);

    expect(state.paymentMethodsFailed, true);
    expect(state.availableMethods, const <PaymentMethod>[PaymentMethod.cod]);
    expect(state.selectedPaymentMethod, PaymentMethod.cod);
    expect(state.canPlaceOrder, true);
  });

  test('placeOrder sends the DTO and reuses one idempotency key', () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );
    when(() => repository.placeOrder(any(), any())).thenAnswer(
      (_) async => _order(),
    );

    final CheckoutController controller = await loadController();
    controller.selectPaymentMethod(PaymentMethod.wallet);
    controller.setTransferSender('01011112222');
    final OrderDto? placed = await controller.placeOrder();
    await _pump();

    expect(placed?.orderNumber, 'NE-1001');
    final List<dynamic> calls = verify(
      () => repository.placeOrder(captureAny(), captureAny()),
    ).captured;
    final PlaceOrderDto dto = calls[0] as PlaceOrderDto;
    expect(dto.addressId, 'a1');
    expect(dto.paymentMethod, PaymentMethod.wallet);
    expect(dto.transferSender, '01011112222');
    final String key = calls[1] as String;
    expect(key.length, 36);

    // A second placement reuses the same key.
    await controller.placeOrder();
    final List<dynamic> second = verify(
      () => repository.placeOrder(captureAny(), captureAny()),
    ).captured;
    expect(second[1] as String, key);
  });

  test('placeOrder is blocked when the quote cannot be placed', () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(canPlaceOrder: false),
    );

    final CheckoutController controller = await loadController();
    expect(await controller.placeOrder(), isNull);
    verifyNever(() => repository.placeOrder(any(), any()));
  });

  test('addAddress selects the new address and re-quotes', () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );
    when(() => repository.createAddress(any())).thenAnswer(
      (_) async => _address('a2'),
    );

    final CheckoutController controller = await loadController();
    final AddressDto? created = await controller.addAddress(
      const CreateAddressDto(
        label: 'Work',
        fullName: 'Test User',
        phone: '01000000000',
        street: '2 Work St',
        city: 'Cairo',
        governorate: 'Cairo',
      ),
    );
    await _pump();

    expect(created?.id, 'a2');
    expect(
      container.read(checkoutControllerProvider).selectedAddressId,
      'a2',
    );
    verify(() => repository.getQuote('a2')).called(1);
  });

  test('non-API load failure surfaces LOAD_FAILED instead of spinning',
      () async {
    // Phase 10: a platform failure is not an ApiException — checkout
    // must still end with an error state, never isLoading forever.
    when(() => repository.listAddresses()).thenThrow(
      StateError('platform failure'),
    );

    await loadController();
    final CheckoutState state = container.read(checkoutControllerProvider);
    expect(state.isLoading, false);
    expect(state.error?.code, 'LOAD_FAILED');
    expect(state.addresses, isEmpty);
  });

  test('non-API quote failure clears isLoadingQuote with LOAD_FAILED',
      () async {
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenThrow(
      StateError('platform failure'),
    );

    await loadController();
    final CheckoutState state = container.read(checkoutControllerProvider);
    expect(state.isLoading, false);
    expect(state.isLoadingQuote, false);
    expect(state.quote, isNull);
    expect(state.error?.code, 'LOAD_FAILED');
  });

  test('double-tap placeOrder places exactly one order', () async {
    // Phase 10: the second concurrent call sees isPlacingOrder and
    // returns null without hitting the API — one idempotency key, one
    // order, even if the user double-taps the button.
    when(() => repository.listAddresses()).thenAnswer(
      (_) async => <AddressDto>[_address('a1', isDefault: true)],
    );
    when(() => repository.getPaymentMethods()).thenAnswer(
      (_) async => _methods(),
    );
    when(() => repository.getQuote(any())).thenAnswer(
      (_) async => _quote(),
    );
    when(() => repository.placeOrder(any(), any())).thenAnswer(
      (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _order();
      },
    );

    final CheckoutController controller = await loadController();
    expect(container.read(checkoutControllerProvider).canPlaceOrder, true);

    final List<OrderDto?> results = await Future.wait(<Future<OrderDto?>>[
      controller.placeOrder(),
      controller.placeOrder(),
    ]);
    expect(results.whereType<OrderDto>(), hasLength(1));
    expect(results, contains(isNull));
    verify(() => repository.placeOrder(any(), any())).called(1);
    expect(
      container.read(checkoutControllerProvider).placedOrder?.orderNumber,
      'NE-1001',
    );
  });
}
