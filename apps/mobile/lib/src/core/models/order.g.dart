// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderCustomerDtoImpl _$$OrderCustomerDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderCustomerDtoImpl(
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$$OrderCustomerDtoImplToJson(
  _$OrderCustomerDtoImpl instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
};

_$OrderItemDtoImpl _$$OrderItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemDtoImpl(
      productId: json['productId'] as String,
      sku: json['sku'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      brandName: json['brandName'] as String,
      imagePublicId: json['imagePublicId'] as String,
      unitPrice: MoneyDto.fromJson(json['unitPrice'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      lineTotal: MoneyDto.fromJson(json['lineTotal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderItemDtoImplToJson(_$OrderItemDtoImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'sku': instance.sku,
      'slug': instance.slug,
      'name': instance.name,
      'brandName': instance.brandName,
      'imagePublicId': instance.imagePublicId,
      'unitPrice': instance.unitPrice,
      'quantity': instance.quantity,
      'lineTotal': instance.lineTotal,
    };

_$OrderPaymentVerificationDtoImpl _$$OrderPaymentVerificationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderPaymentVerificationDtoImpl(
  transferSender: json['transferSender'] as String,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  decidedAt: json['decidedAt'] == null
      ? null
      : DateTime.parse(json['decidedAt'] as String),
  decisionNote: json['decisionNote'] as String?,
);

Map<String, dynamic> _$$OrderPaymentVerificationDtoImplToJson(
  _$OrderPaymentVerificationDtoImpl instance,
) => <String, dynamic>{
  'transferSender': instance.transferSender,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'decidedAt': instance.decidedAt?.toIso8601String(),
  'decisionNote': instance.decisionNote,
};

_$OrderPaymentDtoImpl _$$OrderPaymentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderPaymentDtoImpl(
  method: $enumDecode(
    _$PaymentMethodEnumMap,
    json['method'],
    unknownValue: PaymentMethod.unknown,
  ),
  status: $enumDecode(
    _$PaymentStatusEnumMap,
    json['status'],
    unknownValue: PaymentStatus.unknown,
  ),
  collectedAt: json['collectedAt'] == null
      ? null
      : DateTime.parse(json['collectedAt'] as String),
  verification: json['verification'] == null
      ? null
      : OrderPaymentVerificationDto.fromJson(
          json['verification'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$OrderPaymentDtoImplToJson(
  _$OrderPaymentDtoImpl instance,
) => <String, dynamic>{
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'collectedAt': instance.collectedAt?.toIso8601String(),
  'verification': instance.verification,
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cod: 'COD',
  PaymentMethod.wallet: 'WALLET',
  PaymentMethod.instapay: 'INSTAPAY',
  PaymentMethod.unknown: 'unknown',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'PENDING',
  PaymentStatus.pendingVerification: 'PENDING_VERIFICATION',
  PaymentStatus.verificationRejected: 'VERIFICATION_REJECTED',
  PaymentStatus.paid: 'PAID',
  PaymentStatus.refunded: 'REFUNDED',
  PaymentStatus.unknown: 'unknown',
};

_$OrderCancellationDtoImpl _$$OrderCancellationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderCancellationDtoImpl(
  reason: json['reason'] as String,
  by: $enumDecode(_$RoleEnumMap, json['by'], unknownValue: Role.unknown),
  at: DateTime.parse(json['at'] as String),
);

Map<String, dynamic> _$$OrderCancellationDtoImplToJson(
  _$OrderCancellationDtoImpl instance,
) => <String, dynamic>{
  'reason': instance.reason,
  'by': _$RoleEnumMap[instance.by]!,
  'at': instance.at.toIso8601String(),
};

const _$RoleEnumMap = {
  Role.customer: 'CUSTOMER',
  Role.admin: 'ADMIN',
  Role.superAdmin: 'SUPER_ADMIN',
  Role.unknown: 'unknown',
};

_$OrderShipmentDtoImpl _$$OrderShipmentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderShipmentDtoImpl(
  carrier: json['carrier'] as String,
  trackingNumber: json['trackingNumber'] as String,
  shippedAt: DateTime.parse(json['shippedAt'] as String),
  deliveredAt: json['deliveredAt'] == null
      ? null
      : DateTime.parse(json['deliveredAt'] as String),
  deliveryAttempts: (json['deliveryAttempts'] as num).toInt(),
);

Map<String, dynamic> _$$OrderShipmentDtoImplToJson(
  _$OrderShipmentDtoImpl instance,
) => <String, dynamic>{
  'carrier': instance.carrier,
  'trackingNumber': instance.trackingNumber,
  'shippedAt': instance.shippedAt.toIso8601String(),
  'deliveredAt': instance.deliveredAt?.toIso8601String(),
  'deliveryAttempts': instance.deliveryAttempts,
};

_$OrderShippingAddressDtoImpl _$$OrderShippingAddressDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderShippingAddressDtoImpl(
  fullName: json['fullName'] as String,
  phone: json['phone'] as String,
  street: json['street'] as String,
  city: json['city'] as String,
  governorate: json['governorate'] as String,
  postalCode: json['postalCode'] as String,
);

Map<String, dynamic> _$$OrderShippingAddressDtoImplToJson(
  _$OrderShippingAddressDtoImpl instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'phone': instance.phone,
  'street': instance.street,
  'city': instance.city,
  'governorate': instance.governorate,
  'postalCode': instance.postalCode,
};

_$OrderHistoryActorDtoImpl _$$OrderHistoryActorDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderHistoryActorDtoImpl(
  id: json['id'] as String?,
  role: $enumDecode(_$RoleEnumMap, json['role'], unknownValue: Role.unknown),
  name: json['name'] as String,
);

Map<String, dynamic> _$$OrderHistoryActorDtoImplToJson(
  _$OrderHistoryActorDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'role': _$RoleEnumMap[instance.role]!,
  'name': instance.name,
};

_$OrderStatusHistoryEntryDtoImpl _$$OrderStatusHistoryEntryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusHistoryEntryDtoImpl(
  from: $enumDecode(
    _$OrderStatusEnumMap,
    json['from'],
    unknownValue: OrderStatus.unknown,
  ),
  to: $enumDecode(
    _$OrderStatusEnumMap,
    json['to'],
    unknownValue: OrderStatus.unknown,
  ),
  actor: OrderHistoryActorDto.fromJson(json['actor'] as Map<String, dynamic>),
  note: json['note'] as String,
  at: DateTime.parse(json['at'] as String),
);

Map<String, dynamic> _$$OrderStatusHistoryEntryDtoImplToJson(
  _$OrderStatusHistoryEntryDtoImpl instance,
) => <String, dynamic>{
  'from': _$OrderStatusEnumMap[instance.from]!,
  'to': _$OrderStatusEnumMap[instance.to]!,
  'actor': instance.actor,
  'note': instance.note,
  'at': instance.at.toIso8601String(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.placed: 'PLACED',
  OrderStatus.confirmed: 'CONFIRMED',
  OrderStatus.shipped: 'SHIPPED',
  OrderStatus.delivered: 'DELIVERED',
  OrderStatus.deliveryFailed: 'DELIVERY_FAILED',
  OrderStatus.cancelled: 'CANCELLED',
  OrderStatus.returned: 'RETURNED',
  OrderStatus.unknown: 'unknown',
};

_$OrderDtoImpl _$$OrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$OrderDtoImpl(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      status: $enumDecode(
        _$OrderStatusEnumMap,
        json['status'],
        unknownValue: OrderStatus.unknown,
      ),
      customer: OrderCustomerDto.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      currency: json['currency'] as String,
      pricing: PricingBreakdownDto.fromJson(
        json['pricing'] as Map<String, dynamic>,
      ),
      payment: json['payment'] == null
          ? null
          : OrderPaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
      shippingAddress: OrderShippingAddressDto.fromJson(
        json['shippingAddress'] as Map<String, dynamic>,
      ),
      customerNote: json['customerNote'] as String,
      cancellation: json['cancellation'] == null
          ? null
          : OrderCancellationDto.fromJson(
              json['cancellation'] as Map<String, dynamic>,
            ),
      shipment: json['shipment'] == null
          ? null
          : OrderShipmentDto.fromJson(json['shipment'] as Map<String, dynamic>),
      placedAt: DateTime.parse(json['placedAt'] as String),
    );

Map<String, dynamic> _$$OrderDtoImplToJson(_$OrderDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'customer': instance.customer,
      'items': instance.items,
      'currency': instance.currency,
      'pricing': instance.pricing,
      'payment': instance.payment,
      'shippingAddress': instance.shippingAddress,
      'customerNote': instance.customerNote,
      'cancellation': instance.cancellation,
      'shipment': instance.shipment,
      'placedAt': instance.placedAt.toIso8601String(),
    };

_$OrderSummaryDtoImpl _$$OrderSummaryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderSummaryDtoImpl(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  status: $enumDecode(
    _$OrderStatusEnumMap,
    json['status'],
    unknownValue: OrderStatus.unknown,
  ),
  payment: json['payment'] == null
      ? null
      : OrderPaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
  pricing: PricingBreakdownDto.fromJson(
    json['pricing'] as Map<String, dynamic>,
  ),
  itemCount: (json['itemCount'] as num).toInt(),
  totalQuantity: (json['totalQuantity'] as num).toInt(),
  previewImagePublicId: json['previewImagePublicId'] as String,
  placedAt: DateTime.parse(json['placedAt'] as String),
);

Map<String, dynamic> _$$OrderSummaryDtoImplToJson(
  _$OrderSummaryDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderNumber': instance.orderNumber,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'payment': instance.payment,
  'pricing': instance.pricing,
  'itemCount': instance.itemCount,
  'totalQuantity': instance.totalQuantity,
  'previewImagePublicId': instance.previewImagePublicId,
  'placedAt': instance.placedAt.toIso8601String(),
};

_$CancelOrderDtoImpl _$$CancelOrderDtoImplFromJson(Map<String, dynamic> json) =>
    _$CancelOrderDtoImpl(reason: json['reason'] as String);

Map<String, dynamic> _$$CancelOrderDtoImplToJson(
  _$CancelOrderDtoImpl instance,
) => <String, dynamic>{'reason': instance.reason};

_$ResubmitPaymentDtoImpl _$$ResubmitPaymentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ResubmitPaymentDtoImpl(transferSender: json['transferSender'] as String);

Map<String, dynamic> _$$ResubmitPaymentDtoImplToJson(
  _$ResubmitPaymentDtoImpl instance,
) => <String, dynamic>{'transferSender': instance.transferSender};
