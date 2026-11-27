import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';

/// Fake client: records path/body/query and returns canned data.
class _FakeApiClient extends Fake implements ApiClient {
  String? lastPath;
  Object? lastBody;
  Map<String, dynamic>? lastQuery;
  dynamic dataToReturn;

  @override
  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastQuery = queryParameters;
    return dataToReturn as T;
  }

  @override
  Future<PaginatedList<T>> getPage<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastQuery = queryParameters;
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

Map<String, dynamic> _addressJson(String id) {
  return <String, dynamic>{
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
  };
}

OrderDto _orderJson() {
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
  late AccountRepository repository;

  setUp(() {
    client = _FakeApiClient();
    repository = AccountRepository(client: client);
  });

  test('getProfile calls GET /auth/me', () async {
    client.dataToReturn = AuthUserDto.fromJson(<String, dynamic>{
      'id': 'u1',
      'email': 'user@example.com',
      'fullName': 'Test User',
      'phone': null,
      'role': 'CUSTOMER',
      'emailVerified': true,
      'lastLoginAt': null,
      'createdAt': '2026-01-01T00:00:00.000Z',
    });
    await repository.getProfile();
    expect(client.lastPath, '/auth/me');
  });

  test('updateProfile PATCHes only the supplied fields', () async {
    client.dataToReturn = UserProfileDto.fromJson(<String, dynamic>{
      'id': 'u1',
      'email': 'user@example.com',
      'fullName': 'New Name',
      'phone': null,
      'role': 'CUSTOMER',
      'emailVerified': true,
      'lastLoginAt': null,
      'createdAt': '2026-01-01T00:00:00.000Z',
    });
    await repository.updateProfile(
      const UpdateProfileDto(fullName: 'New Name'),
    );
    expect(client.lastPath, '/users/me');
    final Map<String, dynamic> body =
        client.lastBody as Map<String, dynamic>;
    expect(body, <String, dynamic>{'fullName': 'New Name'});
  });

  test('listOrders passes page/limit and the status array', () async {
    client.dataToReturn = PaginatedList<OrderSummaryDto>(
      items: const <OrderSummaryDto>[],
      meta: PaginationMetaDto.fromJson(<String, dynamic>{
        'page': 1,
        'limit': 20,
        'total': 0,
        'totalPages': 0,
        'hasNext': false,
        'hasPrev': false,
      }),
    );
    await repository.listOrders(
      page: 2,
      limit: 20,
      status: OrderStatus.deliveryFailed,
    );
    expect(client.lastPath, '/orders');
    expect(client.lastQuery?['page'], 2);
    expect(client.lastQuery?['limit'], 20);
    // The wire value is DELIVERY_FAILED, not DELIVERYFAILED.
    expect(client.lastQuery?['status'], <String>['DELIVERY_FAILED']);
  });

  test('getOrder / cancelOrder / resubmitPayment hit the order paths',
      () async {
    client.dataToReturn = _orderJson();
    await repository.getOrder('o1');
    expect(client.lastPath, '/orders/o1');

    await repository.cancelOrder('o1', 'changed my mind');
    expect(client.lastPath, '/orders/o1/cancel');
    expect(
      jsonDecode(jsonEncode(client.lastBody)),
      <String, dynamic>{'reason': 'changed my mind'},
    );

    await repository.resubmitPayment('o1', '01011112222');
    expect(client.lastPath, '/orders/o1/payment/resubmit');
    expect(
      jsonDecode(jsonEncode(client.lastBody)),
      <String, dynamic>{'transferSender': '01011112222'},
    );
  });

  test('address CRUD hits /users/me/addresses', () async {
    client.dataToReturn = <AddressDto>[
      AddressDto.fromJson(_addressJson('a1')),
    ];
    await repository.listAddresses();
    expect(client.lastPath, '/users/me/addresses');

    client.dataToReturn = AddressDto.fromJson(_addressJson('a2'));
    await repository.createAddress(
      const CreateAddressDto(
        label: 'Work',
        fullName: 'Test User',
        phone: '01000000000',
        street: '2 Work St',
        city: 'Cairo',
        governorate: 'Cairo',
      ),
    );
    expect(client.lastPath, '/users/me/addresses');
    final Map<String, dynamic> createBody =
        client.lastBody as Map<String, dynamic>;
    expect(createBody['label'], 'Work');
    expect(createBody.containsKey('postalCode'), false);

    await repository.updateAddress(
      'a2',
      const UpdateAddressDto(label: 'Office'),
    );
    expect(client.lastPath, '/users/me/addresses/a2');
    expect(
      client.lastBody,
      <String, dynamic>{'label': 'Office'},
    );

    client.dataToReturn = <AddressDto>[];
    await repository.deleteAddress('a2');
    expect(client.lastPath, '/users/me/addresses/a2');

    await repository.setDefaultAddress('a1');
    expect(client.lastPath, '/users/me/addresses/a1/default');
  });
}
