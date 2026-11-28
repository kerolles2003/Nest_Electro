import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/profile.dart';

/// Checkout: quote, payment methods, order placement, and the delivery
/// addresses the checkout needs. Address CRUD beyond list/create lives in
/// Phase 6 (account); the checkout only reads the list and creates one
/// when the user has none.
class CheckoutRepository {
  CheckoutRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  /// `POST /checkout/quote { addressId }` — the quote is per address
  /// (shipping rates differ by governorate).
  Future<CheckoutQuoteViewDto> getQuote(String addressId) {
    return _client.postData<CheckoutQuoteViewDto>(
      '/checkout/quote',
      body: CheckoutQuoteDto(addressId: addressId).toJson(),
      fromJson: (Object? json) =>
          CheckoutQuoteViewDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /checkout/payment-methods` — manual-payment instructions.
  /// Only methods the owner configured are returned; an unconfigured
  /// method is not offered (API_GAPS.md G6).
  Future<ManualPaymentInstructionsDto> getPaymentMethods() {
    return _client.getData<ManualPaymentInstructionsDto>(
      '/checkout/payment-methods',
      fromJson: (Object? json) =>
          ManualPaymentInstructionsDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `POST /orders` with an `Idempotency-Key` header. The key is generated
  /// once per checkout attempt (by the controller) and reused across
  /// retries, so a retry after a dropped response cannot create a second
  /// order. Null fields are stripped — the API's validators treat an
  /// explicit `null` differently from an absent field on some DTOs.
  Future<OrderDto> placeOrder(PlaceOrderDto dto, String idempotencyKey) {
    final Map<String, dynamic> body = dto.toJson()
      ..removeWhere((String _, Object? value) => value == null);
    return _client.postData<OrderDto>(
      '/orders',
      body: body,
      headers: <String, String>{'Idempotency-Key': idempotencyKey},
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
    return _client.postData<AddressDto>(
      '/users/me/addresses',
      body: dto.toJson()..removeWhere((String _, Object? v) => v == null),
      fromJson: (Object? json) =>
          AddressDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
