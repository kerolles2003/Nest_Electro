import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/cart.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/cart/data/cart_repository.dart';
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

CartDto _cart() {
  return CartDto.fromJson(<String, dynamic>{
    'items': <dynamic>[],
    'itemCount': 0,
    'totalQuantity': 0,
    'itemsSubtotal': <String, dynamic>{
      'amount': 0,
      'currency': 'EGP',
      'formatted': '0.00 EGP',
    },
    'currency': 'EGP',
    'hasBlockingIssues': false,
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'expiresAt': '2026-01-02T00:00:00.000Z',
  });
}

void main() {
  late _FakeApiClient client;

  setUp(() {
    client = _FakeApiClient();
    client.dataToReturn = _cart();
  });

  group('CartRepository', () {
    late CartRepository repository;

    setUp(() {
      repository = CartRepository(client: client);
    });

    test('getCart calls GET /cart', () async {
      await repository.getCart();
      expect(client.lastPath, '/cart');
    });

    test('addItem posts productId + quantity', () async {
      await repository.addItem('p1', 2);
      expect(client.lastPath, '/cart/items');
      expect(
        client.lastBody,
        <String, dynamic>{'productId': 'p1', 'quantity': 2},
      );
    });

    test('updateItem patches the quantity', () async {
      await repository.updateItem('p1', 3);
      expect(client.lastPath, '/cart/items/p1');
      expect(client.lastBody, <String, dynamic>{'quantity': 3});
    });

    test('removeItem deletes the line, clearCart deletes the cart', () async {
      await repository.removeItem('p1');
      expect(client.lastPath, '/cart/items/p1');
      await repository.clearCart();
      expect(client.lastPath, '/cart');
    });

    test('preview posts the guest lines', () async {
      await repository.preview(
        const <GuestCartLineDto>[
          GuestCartLineDto(productId: 'p1', quantity: 1),
        ],
      );
      expect(client.lastPath, '/cart/preview');
      // The body's nested DTOs serialize through jsonEncode (dio does the
      // same on the wire), so compare the encoded form.
      expect(
        jsonDecode(jsonEncode(client.lastBody)),
        <String, dynamic>{
          'items': <dynamic>[
            <String, dynamic>{'productId': 'p1', 'quantity': 1},
          ],
        },
      );
    });
  });

  group('CheckoutRepository', () {
    late CheckoutRepository repository;

    setUp(() {
      repository = CheckoutRepository(client: client);
    });

    test('getQuote posts the address id', () async {
      client.dataToReturn = CheckoutQuoteViewDto.fromJson(<String, dynamic>{
        'items': <dynamic>[],
        'itemCount': 0,
        'totalQuantity': 0,
        'currency': 'EGP',
        'pricing': <String, dynamic>{
          'itemsSubtotal': <String, dynamic>{
            'amount': 0,
            'currency': 'EGP',
            'formatted': '0.00 EGP',
          },
          'discountTotal': null,
          'shippingFee': null,
          'shippingPriced': false,
          'grandTotal': <String, dynamic>{
            'amount': 0,
            'currency': 'EGP',
            'formatted': '0.00 EGP',
          },
          'vatInclusive': true,
          'vatRateBps': 1400,
        },
        'hasBlockingIssues': false,
        'canPlaceOrder': false,
        'generatedAt': '2026-01-01T00:00:00.000Z',
      });
      await repository.getQuote('addr-1');
      expect(client.lastPath, '/checkout/quote');
      expect(client.lastBody, <String, dynamic>{'addressId': 'addr-1'});
    });

    test('getPaymentMethods calls GET /checkout/payment-methods', () async {
      client.dataToReturn =
          ManualPaymentInstructionsDto.fromJson(<String, dynamic>{
        'availableMethods': <String>['COD'],
        'walletNumber': '',
        'instapayAddress': '',
        'whatsappNumber': '',
      });
      await repository.getPaymentMethods();
      expect(client.lastPath, '/checkout/payment-methods');
    });

    test('placeOrder sends the idempotency key and strips nulls', () async {
      client.dataToReturn = OrderDto.fromJson(<String, dynamic>{
        'id': 'o1',
        'orderNumber': 'NE-1',
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
            'amount': 0,
            'currency': 'EGP',
            'formatted': '0.00 EGP',
          },
          'discountTotal': null,
          'shippingFee': null,
          'shippingPriced': false,
          'grandTotal': <String, dynamic>{
            'amount': 0,
            'currency': 'EGP',
            'formatted': '0.00 EGP',
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
      await repository.placeOrder(
        const PlaceOrderDto(addressId: 'addr-1'),
        'key-123',
      );
      expect(client.lastPath, '/orders');
      expect(client.lastHeaders?['Idempotency-Key'], 'key-123');
      final Map<String, dynamic> body =
          client.lastBody as Map<String, dynamic>;
      expect(body['addressId'], 'addr-1');
      expect(body.containsKey('customerNote'), false);
      expect(body.containsKey('transferSender'), false);
    });

    test('listAddresses + createAddress hit /users/me/addresses', () async {
      client.dataToReturn = <AddressDto>[];
      await repository.listAddresses();
      expect(client.lastPath, '/users/me/addresses');
      client.dataToReturn = AddressDto.fromJson(<String, dynamic>{
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
      await repository.createAddress(
        const CreateAddressDto(
          label: 'Home',
          fullName: 'Test User',
          phone: '01000000000',
          street: '1 Main St',
          city: 'Cairo',
          governorate: 'Cairo',
        ),
      );
      expect(client.lastPath, '/users/me/addresses');
      final Map<String, dynamic> body =
          client.lastBody as Map<String, dynamic>;
      expect(body['label'], 'Home');
      expect(body.containsKey('postalCode'), false);
    });
  });
}
