import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/cart.dart';

/// Server cart (authed) + guest preview. Every mutation returns the whole
/// updated cart — the API's cart endpoints all respond `CartResponseDto`
/// (`{ data: CartDto }`), so the controller just replaces its state.
class CartRepository {
  CartRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  static CartDto _cartFromJson(Object? json) =>
      CartDto.fromJson(json as Map<String, dynamic>);

  /// `GET /cart` — the signed-in user's cart.
  Future<CartDto> getCart() {
    return _client.getData<CartDto>('/cart', fromJson: _cartFromJson);
  }

  /// `POST /cart/items`.
  Future<CartDto> addItem(String productId, int quantity) {
    return _client.postData<CartDto>(
      '/cart/items',
      body: AddCartItemDto(productId: productId, quantity: quantity).toJson(),
      fromJson: _cartFromJson,
    );
  }

  /// `PATCH /cart/items/{productId}`.
  Future<CartDto> updateItem(String productId, int quantity) {
    return _client.patchData<CartDto>(
      '/cart/items/$productId',
      body: UpdateCartItemDto(quantity: quantity).toJson(),
      fromJson: _cartFromJson,
    );
  }

  /// `DELETE /cart/items/{productId}`.
  Future<CartDto> removeItem(String productId) {
    return _client.deleteData<CartDto>(
      '/cart/items/$productId',
      fromJson: _cartFromJson,
    );
  }

  /// `DELETE /cart`.
  Future<CartDto> clearCart() {
    return _client.deleteData<CartDto>('/cart', fromJson: _cartFromJson);
  }

  /// `POST /cart/preview` — prices an anonymous basket (no auth needed).
  /// Returns the same priced `CartDto` shape as the authed cart, so the
  /// guest cart screen renders exactly like the authed one.
  Future<CartDto> preview(List<GuestCartLineDto> items) {
    return _client.postData<CartDto>(
      '/cart/preview',
      body: PreviewGuestCartDto(items: items).toJson(),
      fromJson: _cartFromJson,
    );
  }
}
