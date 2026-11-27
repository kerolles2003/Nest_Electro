import 'package:json_annotation/json_annotation.dart';

/// API enums. Every enum carries an `unknown` fallback so a new server-side
/// value degrades to `unknown` instead of crashing response parsing
/// (via `@JsonKey(unknownEnumValue: ...)` on the field).

enum Availability {
  @JsonValue('IN_STOCK')
  inStock,
  @JsonValue('LOW_STOCK')
  lowStock,
  @JsonValue('OUT_OF_STOCK')
  outOfStock,
  unknown,
}

enum OrderStatus {
  @JsonValue('PLACED')
  placed,
  @JsonValue('CONFIRMED')
  confirmed,
  @JsonValue('SHIPPED')
  shipped,
  @JsonValue('DELIVERED')
  delivered,
  @JsonValue('DELIVERY_FAILED')
  deliveryFailed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('RETURNED')
  returned,
  unknown,
}

enum PaymentMethod {
  @JsonValue('COD')
  cod,
  @JsonValue('WALLET')
  wallet,
  @JsonValue('INSTAPAY')
  instapay,
  unknown,
}

enum PaymentStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('PENDING_VERIFICATION')
  pendingVerification,
  @JsonValue('VERIFICATION_REJECTED')
  verificationRejected,
  @JsonValue('PAID')
  paid,
  @JsonValue('REFUNDED')
  refunded,
  unknown,
}

enum CartLineStatus {
  @JsonValue('OK')
  ok,
  @JsonValue('PRICE_CHANGED')
  priceChanged,
  @JsonValue('REDUCED_STOCK')
  reducedStock,
  @JsonValue('OUT_OF_STOCK')
  outOfStock,
  @JsonValue('UNAVAILABLE')
  unavailable,
  unknown,
}

enum Role {
  @JsonValue('CUSTOMER')
  customer,
  @JsonValue('ADMIN')
  admin,
  @JsonValue('SUPER_ADMIN')
  superAdmin,
  unknown,
}
