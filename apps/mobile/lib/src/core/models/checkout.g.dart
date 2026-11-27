// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteLineDtoImpl _$$QuoteLineDtoImplFromJson(Map<String, dynamic> json) =>
    _$QuoteLineDtoImpl(
      productId: json['productId'] as String,
      sku: json['sku'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      imagePublicId: json['imagePublicId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      effectiveQuantity: (json['effectiveQuantity'] as num).toInt(),
      availableQuantity: (json['availableQuantity'] as num).toInt(),
      unitPrice: json['unitPrice'] == null
          ? null
          : MoneyDto.fromJson(json['unitPrice'] as Map<String, dynamic>),
      previousUnitPrice: json['previousUnitPrice'] == null
          ? null
          : MoneyDto.fromJson(
              json['previousUnitPrice'] as Map<String, dynamic>,
            ),
      lineTotal: json['lineTotal'] == null
          ? null
          : MoneyDto.fromJson(json['lineTotal'] as Map<String, dynamic>),
      status: $enumDecode(
        _$CartLineStatusEnumMap,
        json['status'],
        unknownValue: CartLineStatus.unknown,
      ),
    );

Map<String, dynamic> _$$QuoteLineDtoImplToJson(_$QuoteLineDtoImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'sku': instance.sku,
      'slug': instance.slug,
      'name': instance.name,
      'imagePublicId': instance.imagePublicId,
      'quantity': instance.quantity,
      'effectiveQuantity': instance.effectiveQuantity,
      'availableQuantity': instance.availableQuantity,
      'unitPrice': instance.unitPrice,
      'previousUnitPrice': instance.previousUnitPrice,
      'lineTotal': instance.lineTotal,
      'status': _$CartLineStatusEnumMap[instance.status]!,
    };

const _$CartLineStatusEnumMap = {
  CartLineStatus.ok: 'OK',
  CartLineStatus.priceChanged: 'PRICE_CHANGED',
  CartLineStatus.reducedStock: 'REDUCED_STOCK',
  CartLineStatus.outOfStock: 'OUT_OF_STOCK',
  CartLineStatus.unavailable: 'UNAVAILABLE',
  CartLineStatus.unknown: 'unknown',
};

_$PricingBreakdownDtoImpl _$$PricingBreakdownDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PricingBreakdownDtoImpl(
  itemsSubtotal: MoneyDto.fromJson(
    json['itemsSubtotal'] as Map<String, dynamic>,
  ),
  discountTotal: json['discountTotal'] == null
      ? null
      : MoneyDto.fromJson(json['discountTotal'] as Map<String, dynamic>),
  shippingFee: json['shippingFee'] == null
      ? null
      : MoneyDto.fromJson(json['shippingFee'] as Map<String, dynamic>),
  shippingPriced: json['shippingPriced'] as bool,
  grandTotal: MoneyDto.fromJson(json['grandTotal'] as Map<String, dynamic>),
  vatInclusive: json['vatInclusive'] as bool,
  vatRateBps: (json['vatRateBps'] as num).toInt(),
);

Map<String, dynamic> _$$PricingBreakdownDtoImplToJson(
  _$PricingBreakdownDtoImpl instance,
) => <String, dynamic>{
  'itemsSubtotal': instance.itemsSubtotal,
  'discountTotal': instance.discountTotal,
  'shippingFee': instance.shippingFee,
  'shippingPriced': instance.shippingPriced,
  'grandTotal': instance.grandTotal,
  'vatInclusive': instance.vatInclusive,
  'vatRateBps': instance.vatRateBps,
};

_$CheckoutQuoteViewDtoImpl _$$CheckoutQuoteViewDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutQuoteViewDtoImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => QuoteLineDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  itemCount: (json['itemCount'] as num).toInt(),
  totalQuantity: (json['totalQuantity'] as num).toInt(),
  currency: json['currency'] as String,
  pricing: PricingBreakdownDto.fromJson(
    json['pricing'] as Map<String, dynamic>,
  ),
  hasBlockingIssues: json['hasBlockingIssues'] as bool,
  canPlaceOrder: json['canPlaceOrder'] as bool,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
);

Map<String, dynamic> _$$CheckoutQuoteViewDtoImplToJson(
  _$CheckoutQuoteViewDtoImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'itemCount': instance.itemCount,
  'totalQuantity': instance.totalQuantity,
  'currency': instance.currency,
  'pricing': instance.pricing,
  'hasBlockingIssues': instance.hasBlockingIssues,
  'canPlaceOrder': instance.canPlaceOrder,
  'generatedAt': instance.generatedAt.toIso8601String(),
};

_$CheckoutQuoteDtoImpl _$$CheckoutQuoteDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutQuoteDtoImpl(addressId: json['addressId'] as String?);

Map<String, dynamic> _$$CheckoutQuoteDtoImplToJson(
  _$CheckoutQuoteDtoImpl instance,
) => <String, dynamic>{'addressId': instance.addressId};

_$ManualPaymentInstructionsDtoImpl _$$ManualPaymentInstructionsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ManualPaymentInstructionsDtoImpl(
  availableMethods: (json['availableMethods'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  walletNumber: json['walletNumber'] as String,
  instapayAddress: json['instapayAddress'] as String,
  whatsappNumber: json['whatsappNumber'] as String,
);

Map<String, dynamic> _$$ManualPaymentInstructionsDtoImplToJson(
  _$ManualPaymentInstructionsDtoImpl instance,
) => <String, dynamic>{
  'availableMethods': instance.availableMethods,
  'walletNumber': instance.walletNumber,
  'instapayAddress': instance.instapayAddress,
  'whatsappNumber': instance.whatsappNumber,
};

_$PlaceOrderDtoImpl _$$PlaceOrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$PlaceOrderDtoImpl(
      addressId: json['addressId'] as String,
      customerNote: json['customerNote'] as String?,
      paymentMethod: $enumDecodeNullable(
        _$PaymentMethodEnumMap,
        json['paymentMethod'],
        unknownValue: PaymentMethod.unknown,
      ),
      transferSender: json['transferSender'] as String?,
    );

Map<String, dynamic> _$$PlaceOrderDtoImplToJson(_$PlaceOrderDtoImpl instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'customerNote': instance.customerNote,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
      'transferSender': instance.transferSender,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cod: 'COD',
  PaymentMethod.wallet: 'WALLET',
  PaymentMethod.instapay: 'INSTAPAY',
  PaymentMethod.unknown: 'unknown',
};
