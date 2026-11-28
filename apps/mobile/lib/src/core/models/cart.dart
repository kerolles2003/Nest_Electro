import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/money.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class CartLineDto with _$CartLineDto {
  const factory CartLineDto({
    required String productId,
    required String slug,
    required String sku,
    required String name,
    required String imagePublicId,
    required int quantity,
    required int effectiveQuantity,
    required int availableQuantity,
    MoneyDto? unitPrice,
    MoneyDto? previousUnitPrice,
    MoneyDto? lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown)
    required CartLineStatus status,
    required DateTime addedAt,
  }) = _CartLineDto;

  factory CartLineDto.fromJson(Map<String, dynamic> json) =>
      _$CartLineDtoFromJson(json);
}

@freezed
class CartDto with _$CartDto {
  const factory CartDto({
    required List<CartLineDto> items,
    required int itemCount,
    required int totalQuantity,
    required MoneyDto itemsSubtotal,
    required String currency,
    required bool hasBlockingIssues,
    required DateTime updatedAt,
    required DateTime expiresAt,
  }) = _CartDto;

  factory CartDto.fromJson(Map<String, dynamic> json) =>
      _$CartDtoFromJson(json);
}

@freezed
class AddCartItemDto with _$AddCartItemDto {
  const factory AddCartItemDto({
    required String productId,
    required int quantity,
  }) = _AddCartItemDto;

  factory AddCartItemDto.fromJson(Map<String, dynamic> json) =>
      _$AddCartItemDtoFromJson(json);
}

@freezed
class UpdateCartItemDto with _$UpdateCartItemDto {
  const factory UpdateCartItemDto({
    required int quantity,
  }) = _UpdateCartItemDto;

  factory UpdateCartItemDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemDtoFromJson(json);
}

@freezed
class GuestCartLineDto with _$GuestCartLineDto {
  const factory GuestCartLineDto({
    required String productId,
    required int quantity,
  }) = _GuestCartLineDto;

  factory GuestCartLineDto.fromJson(Map<String, dynamic> json) =>
      _$GuestCartLineDtoFromJson(json);
}

@freezed
class PreviewGuestCartDto with _$PreviewGuestCartDto {
  const factory PreviewGuestCartDto({
    required List<GuestCartLineDto> items,
  }) = _PreviewGuestCartDto;

  factory PreviewGuestCartDto.fromJson(Map<String, dynamic> json) =>
      _$PreviewGuestCartDtoFromJson(json);
}
