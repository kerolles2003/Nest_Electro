import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/money.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class OrderCustomerDto with _$OrderCustomerDto {
  const factory OrderCustomerDto({
    required String fullName,
    required String email,
    String? phone,
  }) = _OrderCustomerDto;

  factory OrderCustomerDto.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomerDtoFromJson(json);
}

@freezed
class OrderItemDto with _$OrderItemDto {
  const factory OrderItemDto({
    required String productId,
    required String sku,
    required String slug,
    required String name,
    required String brandName,
    required String imagePublicId,
    required MoneyDto unitPrice,
    required int quantity,
    required MoneyDto lineTotal,
  }) = _OrderItemDto;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);
}

@freezed
class OrderPaymentVerificationDto with _$OrderPaymentVerificationDto {
  const factory OrderPaymentVerificationDto({
    required String transferSender,
    required DateTime submittedAt,
    DateTime? decidedAt,
    String? decisionNote,
  }) = _OrderPaymentVerificationDto;

  factory OrderPaymentVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentVerificationDtoFromJson(json);
}

@freezed
class OrderPaymentDto with _$OrderPaymentDto {
  const factory OrderPaymentDto({
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    required PaymentMethod method,
    @JsonKey(unknownEnumValue: PaymentStatus.unknown)
    required PaymentStatus status,
    DateTime? collectedAt,
    OrderPaymentVerificationDto? verification,
  }) = _OrderPaymentDto;

  factory OrderPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentDtoFromJson(json);
}

@freezed
class OrderCancellationDto with _$OrderCancellationDto {
  const factory OrderCancellationDto({
    required String reason,
    @JsonKey(unknownEnumValue: Role.unknown) required Role by,
    required DateTime at,
  }) = _OrderCancellationDto;

  factory OrderCancellationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderCancellationDtoFromJson(json);
}

@freezed
class OrderShipmentDto with _$OrderShipmentDto {
  const factory OrderShipmentDto({
    required String carrier,
    required String trackingNumber,
    required DateTime shippedAt,
    DateTime? deliveredAt,
    required int deliveryAttempts,
  }) = _OrderShipmentDto;

  factory OrderShipmentDto.fromJson(Map<String, dynamic> json) =>
      _$OrderShipmentDtoFromJson(json);
}

@freezed
class OrderShippingAddressDto with _$OrderShippingAddressDto {
  const factory OrderShippingAddressDto({
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String governorate,
    required String postalCode,
  }) = _OrderShippingAddressDto;

  factory OrderShippingAddressDto.fromJson(Map<String, dynamic> json) =>
      _$OrderShippingAddressDtoFromJson(json);
}

@freezed
class OrderHistoryActorDto with _$OrderHistoryActorDto {
  const factory OrderHistoryActorDto({
    String? id,
    @JsonKey(unknownEnumValue: Role.unknown) required Role role,
    required String name,
  }) = _OrderHistoryActorDto;

  factory OrderHistoryActorDto.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryActorDtoFromJson(json);
}

@freezed
class OrderStatusHistoryEntryDto with _$OrderStatusHistoryEntryDto {
  const factory OrderStatusHistoryEntryDto({
    @JsonKey(unknownEnumValue: OrderStatus.unknown) required OrderStatus from,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) required OrderStatus to,
    required OrderHistoryActorDto actor,
    required String note,
    required DateTime at,
  }) = _OrderStatusHistoryEntryDto;

  factory OrderStatusHistoryEntryDto.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryEntryDtoFromJson(json);
}

@freezed
class OrderDto with _$OrderDto {
  const factory OrderDto({
    required String id,
    required String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown)
    required OrderStatus status,
    required OrderCustomerDto customer,
    required List<OrderItemDto> items,
    required String currency,
    required PricingBreakdownDto pricing,
    OrderPaymentDto? payment,
    required OrderShippingAddressDto shippingAddress,
    required String customerNote,
    OrderCancellationDto? cancellation,
    OrderShipmentDto? shipment,
    required DateTime placedAt,
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);
}

@freezed
class OrderSummaryDto with _$OrderSummaryDto {
  const factory OrderSummaryDto({
    required String id,
    required String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown)
    required OrderStatus status,
    OrderPaymentDto? payment,
    required PricingBreakdownDto pricing,
    required int itemCount,
    required int totalQuantity,
    required String previewImagePublicId,
    required DateTime placedAt,
  }) = _OrderSummaryDto;

  factory OrderSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryDtoFromJson(json);
}

@freezed
class CancelOrderDto with _$CancelOrderDto {
  const factory CancelOrderDto({
    required String reason,
  }) = _CancelOrderDto;

  factory CancelOrderDto.fromJson(Map<String, dynamic> json) =>
      _$CancelOrderDtoFromJson(json);
}

@freezed
class ResubmitPaymentDto with _$ResubmitPaymentDto {
  const factory ResubmitPaymentDto({
    required String transferSender,
  }) = _ResubmitPaymentDto;

  factory ResubmitPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$ResubmitPaymentDtoFromJson(json);
}
