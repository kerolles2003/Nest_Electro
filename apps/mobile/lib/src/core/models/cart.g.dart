// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartLineDtoImpl _$$CartLineDtoImplFromJson(Map<String, dynamic> json) =>
    _$CartLineDtoImpl(
      productId: json['productId'] as String,
      slug: json['slug'] as String,
      sku: json['sku'] as String,
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
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$$CartLineDtoImplToJson(_$CartLineDtoImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'slug': instance.slug,
      'sku': instance.sku,
      'name': instance.name,
      'imagePublicId': instance.imagePublicId,
      'quantity': instance.quantity,
      'effectiveQuantity': instance.effectiveQuantity,
      'availableQuantity': instance.availableQuantity,
      'unitPrice': instance.unitPrice,
      'previousUnitPrice': instance.previousUnitPrice,
      'lineTotal': instance.lineTotal,
      'status': _$CartLineStatusEnumMap[instance.status]!,
      'addedAt': instance.addedAt.toIso8601String(),
    };

const _$CartLineStatusEnumMap = {
  CartLineStatus.ok: 'OK',
  CartLineStatus.priceChanged: 'PRICE_CHANGED',
  CartLineStatus.reducedStock: 'REDUCED_STOCK',
  CartLineStatus.outOfStock: 'OUT_OF_STOCK',
  CartLineStatus.unavailable: 'UNAVAILABLE',
  CartLineStatus.unknown: 'unknown',
};

_$CartDtoImpl _$$CartDtoImplFromJson(Map<String, dynamic> json) =>
    _$CartDtoImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartLineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemCount: (json['itemCount'] as num).toInt(),
      totalQuantity: (json['totalQuantity'] as num).toInt(),
      itemsSubtotal: MoneyDto.fromJson(
        json['itemsSubtotal'] as Map<String, dynamic>,
      ),
      currency: json['currency'] as String,
      hasBlockingIssues: json['hasBlockingIssues'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$CartDtoImplToJson(_$CartDtoImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'itemCount': instance.itemCount,
      'totalQuantity': instance.totalQuantity,
      'itemsSubtotal': instance.itemsSubtotal,
      'currency': instance.currency,
      'hasBlockingIssues': instance.hasBlockingIssues,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_$AddCartItemDtoImpl _$$AddCartItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$AddCartItemDtoImpl(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$AddCartItemDtoImplToJson(
  _$AddCartItemDtoImpl instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
};

_$UpdateCartItemDtoImpl _$$UpdateCartItemDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateCartItemDtoImpl(quantity: (json['quantity'] as num).toInt());

Map<String, dynamic> _$$UpdateCartItemDtoImplToJson(
  _$UpdateCartItemDtoImpl instance,
) => <String, dynamic>{'quantity': instance.quantity};

_$GuestCartLineDtoImpl _$$GuestCartLineDtoImplFromJson(
  Map<String, dynamic> json,
) => _$GuestCartLineDtoImpl(
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$$GuestCartLineDtoImplToJson(
  _$GuestCartLineDtoImpl instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
};

_$PreviewGuestCartDtoImpl _$$PreviewGuestCartDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PreviewGuestCartDtoImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => GuestCartLineDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PreviewGuestCartDtoImplToJson(
  _$PreviewGuestCartDtoImpl instance,
) => <String, dynamic>{'items': instance.items};
