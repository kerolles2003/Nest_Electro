import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/money.dart';

part 'checkout.freezed.dart';
part 'checkout.g.dart';

@freezed
class QuoteLineDto with _$QuoteLineDto {
  const factory QuoteLineDto({
    required String productId,
    required String sku,
    required String slug,
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
  }) = _QuoteLineDto;

  factory QuoteLineDto.fromJson(Map<String, dynamic> json) =>
      _$QuoteLineDtoFromJson(json);
}

@freezed
class PricingBreakdownDto with _$PricingBreakdownDto {
  const factory PricingBreakdownDto({
    required MoneyDto itemsSubtotal,
    MoneyDto? discountTotal,
    // Null while shipping is unpriced (`shippingPriced == false`).
    MoneyDto? shippingFee,
    required bool shippingPriced,
    required MoneyDto grandTotal,
    required bool vatInclusive,
    required int vatRateBps,
  }) = _PricingBreakdownDto;

  factory PricingBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$PricingBreakdownDtoFromJson(json);
}

@freezed
class CheckoutQuoteViewDto with _$CheckoutQuoteViewDto {
  const factory CheckoutQuoteViewDto({
    required List<QuoteLineDto> items,
    required int itemCount,
    required int totalQuantity,
    required String currency,
    required PricingBreakdownDto pricing,
    required bool hasBlockingIssues,
    required bool canPlaceOrder,
    required DateTime generatedAt,
  }) = _CheckoutQuoteViewDto;

  factory CheckoutQuoteViewDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutQuoteViewDtoFromJson(json);
}

@freezed
class CheckoutQuoteDto with _$CheckoutQuoteDto {
  const factory CheckoutQuoteDto({
    String? addressId,
  }) = _CheckoutQuoteDto;

  factory CheckoutQuoteDto.fromJson(Map<String, dynamic> json) =>
      _$CheckoutQuoteDtoFromJson(json);
}

/// Manual-payment instructions (wallet / InstaPay). The API returns these
/// only when the owner configured them; an unconfigured method is not
/// offered (see API_GAPS.md G6).
@freezed
class ManualPaymentInstructionsDto with _$ManualPaymentInstructionsDto {
  const factory ManualPaymentInstructionsDto({
    required List<String> availableMethods,
    required String walletNumber,
    required String instapayAddress,
    required String whatsappNumber,
  }) = _ManualPaymentInstructionsDto;

  factory ManualPaymentInstructionsDto.fromJson(Map<String, dynamic> json) =>
      _$ManualPaymentInstructionsDtoFromJson(json);
}

@freezed
class PlaceOrderDto with _$PlaceOrderDto {
  const factory PlaceOrderDto({
    required String addressId,
    String? customerNote,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    PaymentMethod? paymentMethod,
    String? transferSender,
  }) = _PlaceOrderDto;

  factory PlaceOrderDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderDtoFromJson(json);
}
