import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/checkout/data/checkout_repository.dart';

/// Fake client: records path/body/headers and returns canned data.
class _FakeApiClient extends Fake implements ApiClient {
  String? lastPath;
  Object? lastBody;
  Map<String, String>? lastHeaders;
  dynamic dataToReturn;

  @override
  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    return dataToReturn as T;
  }

  @override
  Future<PaginatedList<T>> getPage<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    return dataToReturn as PaginatedList<T>;
  }

  @override
  Future<T> postData<T>(
    String path, {
    Object? body,
    Map<String, String>? headers,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastBody = body;
    lastHeaders = headers;
    return dataToReturn as T;
  }

  @override
  Future<T> patchData<T>(
    String path, {
    Object? body,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastBody = body;
    return dataToReturn as T;
  }

  @override
  Future<T> deleteData<T>(
    String path, {
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    return dataToReturn as T;
  }
}

AddressDto _address(String id) {
  return AddressDto.fromJson(<String, dynamic>{
    'id': id,
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

ManualPaymentInstructionsDto _methods() {
  return ManualPaymentInstructionsDto.fromJson(<String, dynamic>{
    'availableMethods': <String>['COD', 'WALLET', 'INSTAPAY'],
    'walletNumber': '01099998888',
    'instapayAddress': '01099998888@instapay',
    'whatsappNumber': '201099998888',
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
  late _FakeApiClient client;
  late CheckoutRepository repository;

  setUp(() {
    client = _FakeApiClient();
    repository = CheckoutRepository(client: client);
  });

  test('getQuote posts /checkout/quote with the address id', () async {
    client.dataToReturn = _quote();

    final CheckoutQuoteViewDto quote = await repository.getQuote('addr-1');

    expect(client.lastPath, '/checkout/quote');
    expect(client.lastBody, <String, dynamic>{'addressId': 'addr-1'});
    expect(quote.canPlaceOrder, isTrue);
    expect(quote.pricing.grandTotal.amount, 15000);
  });

  test('getPaymentMethods gets /checkout/payment-methods', () async {
    client.dataToReturn = _methods();

    final ManualPaymentInstructionsDto methods =
        await repository.getPaymentMethods();

    expect(client.lastPath, '/checkout/payment-methods');
    expect(methods.availableMethods, <String>['COD', 'WALLET', 'INSTAPAY']);
    expect(methods.walletNumber, '01099998888');
  });

  test('placeOrder posts /orders with the idempotency key and no nulls',
      () async {
    client.dataToReturn = _order();

    final OrderDto order = await repository.placeOrder(
      const PlaceOrderDto(
        addressId: 'addr-1',
        paymentMethod: PaymentMethod.cod,
        transferSender: null,
        customerNote: 'Ring twice',
      ),
      'idem-123',
    );

    expect(client.lastPath, '/orders');
    expect(client.lastHeaders, <String, String>{'Idempotency-Key': 'idem-123'});
    final Map<String, dynamic> body = client.lastBody as Map<String, dynamic>;
    expect(body['addressId'], 'addr-1');
    expect(body['paymentMethod'], 'COD');
    expect(body['customerNote'], 'Ring twice');
    // Null fields are stripped — the API treats explicit null differently
    // from an absent field on some DTOs.
    expect(body.containsKey('transferSender'), isFalse);
    expect(order.orderNumber, 'NE-1001');
  });

  test('listAddresses gets /users/me/addresses', () async {
    client.dataToReturn = <AddressDto>[_address('a1')];

    final List<AddressDto> addresses = await repository.listAddresses();

    expect(client.lastPath, '/users/me/addresses');
    expect(addresses, hasLength(1));
    expect(addresses.single.id, 'a1');
  });

  test('createAddress posts without null fields', () async {
    client.dataToReturn = _address('a2');

    final AddressDto created = await repository.createAddress(
      const CreateAddressDto(
        label: 'Work',
        fullName: 'Test User',
        phone: '01000000000',
        street: '2 Work St',
        city: 'Giza',
        governorate: 'Giza',
      ),
    );

    expect(client.lastPath, '/users/me/addresses');
    final Map<String, dynamic> body = client.lastBody as Map<String, dynamic>;
    expect(body['label'], 'Work');
    expect(body.containsKey('postalCode'), isFalse);
    expect(body.containsKey('isDefault'), isFalse);
    expect(created.id, 'a2');
  });
}
