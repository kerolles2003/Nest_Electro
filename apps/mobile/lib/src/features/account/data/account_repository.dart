import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/profile.dart';

import 'package:nest_electro/src/core/models/enums.dart';

/// Wire value for an [OrderStatus] — `deliveryFailed.name` would give
/// `DELIVERYFAILED`, the API expects `DELIVERY_FAILED`.
String _orderStatusWireValue(OrderStatus status) {
  return switch (status) {
    OrderStatus.placed => 'PLACED',
    OrderStatus.confirmed => 'CONFIRMED',
    OrderStatus.shipped => 'SHIPPED',
    OrderStatus.delivered => 'DELIVERED',
    OrderStatus.deliveryFailed => 'DELIVERY_FAILED',
    OrderStatus.cancelled => 'CANCELLED',
    OrderStatus.returned => 'RETURNED',
    OrderStatus.unknown => 'UNKNOWN',
  };
}

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(client: ref.watch(apiClientProvider));
});

/// Account data: profile, orders, addresses.
///
/// The profile is read through `GET /auth/me` (same endpoint the auth
/// controller restores the session from); `PATCH /users/me` returns the
/// updated [UserProfileDto]. Address list/create are shared with the
/// checkout flow — the two repositories deliberately duplicate those two
/// calls so checkout does not depend on the account feature (D-22).
class AccountRepository {
  AccountRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  /// `GET /auth/me`.
  Future<AuthUserDto> getProfile() {
    return _client.getData<AuthUserDto>(
      '/auth/me',
      fromJson: (Object? json) =>
          AuthUserDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `PATCH /users/me` — only the supplied fields are sent.
  Future<UserProfileDto> updateProfile(UpdateProfileDto dto) {
    final Map<String, dynamic> body = dto.toJson()
      ..removeWhere((String key, Object? value) => value == null);
    return _client.patchData<UserProfileDto>(
      '/users/me',
      body: body,
      fromJson: (Object? json) =>
          UserProfileDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /orders` — paginated, newest first; `status` filters by
  /// [OrderStatus] (`PLACED`, `CONFIRMED`, …); null means all orders.
  Future<PaginatedList<OrderSummaryDto>> listOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  }) {
    final Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (status != null) {
      // The API takes `status` as an array (`?status=PLACED&status=…`).
      params['status'] = <String>[_orderStatusWireValue(status)];
    }
    return _client.getPage<OrderSummaryDto>(
      '/orders',
      queryParameters: params,
      fromJson: (Object? json) =>
          OrderSummaryDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /orders/{id}`.
  Future<OrderDto> getOrder(String id) {
    return _client.getData<OrderDto>(
      '/orders/$id',
      fromJson: (Object? json) =>
          OrderDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `POST /orders/{id}/cancel` — the API honours it only for PLACED /
  /// CONFIRMED orders (409 otherwise); the screen offers the button for
  /// those statuses only, mirroring the storefront.
  Future<OrderDto> cancelOrder(String id, String reason) {
    return _client.postData<OrderDto>(
      '/orders/$id/cancel',
      body: CancelOrderDto(reason: reason).toJson(),
      fromJson: (Object? json) =>
          OrderDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `POST /orders/{id}/payment/resubmit` — for wallet/InstaPay orders
  /// whose verification was rejected.
  Future<OrderDto> resubmitPayment(String id, String transferSender) {
    return _client.postData<OrderDto>(
      '/orders/$id/payment/resubmit',
      body: ResubmitPaymentDto(transferSender: transferSender).toJson(),
      fromJson: (Object? json) =>
          OrderDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /users/me/addresses`.
  Future<List<AddressDto>> listAddresses() {
    return _client.getData<List<AddressDto>>(
      '/users/me/addresses',
      fromJson: (Object? json) => (json as List<dynamic>)
          .map(
            (Object? e) => AddressDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// `POST /users/me/addresses`.
  Future<AddressDto> createAddress(CreateAddressDto dto) {
    final Map<String, dynamic> body = dto.toJson()
      ..removeWhere((String key, Object? value) => value == null);
    return _client.postData<AddressDto>(
      '/users/me/addresses',
      body: body,
      fromJson: (Object? json) =>
          AddressDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `PATCH /users/me/addresses/{addressId}`.
  Future<AddressDto> updateAddress(String id, UpdateAddressDto dto) {
    final Map<String, dynamic> body = dto.toJson()
      ..removeWhere((String key, Object? value) => value == null);
    return _client.patchData<AddressDto>(
      '/users/me/addresses/$id',
      body: body,
      fromJson: (Object? json) =>
          AddressDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `DELETE /users/me/addresses/{addressId}` — returns the remaining list.
  Future<List<AddressDto>> deleteAddress(String id) {
    return _client.deleteData<List<AddressDto>>(
      '/users/me/addresses/$id',
      fromJson: (Object? json) => (json as List<dynamic>)
          .map(
            (Object? e) => AddressDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// `POST /users/me/addresses/{addressId}/default` — returns the list
  /// with the new default applied.
  Future<List<AddressDto>> setDefaultAddress(String id) {
    return _client.postData<List<AddressDto>>(
      '/users/me/addresses/$id/default',
      fromJson: (Object? json) => (json as List<dynamic>)
          .map(
            (Object? e) => AddressDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
