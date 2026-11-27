// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuoteLineDto _$QuoteLineDtoFromJson(Map<String, dynamic> json) {
  return _QuoteLineDto.fromJson(json);
}

/// @nodoc
mixin _$QuoteLineDto {
  String get productId => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imagePublicId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get effectiveQuantity => throw _privateConstructorUsedError;
  int get availableQuantity => throw _privateConstructorUsedError;
  MoneyDto? get unitPrice => throw _privateConstructorUsedError;
  MoneyDto? get previousUnitPrice => throw _privateConstructorUsedError;
  MoneyDto? get lineTotal => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: CartLineStatus.unknown)
  CartLineStatus get status => throw _privateConstructorUsedError;

  /// Serializes this QuoteLineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteLineDtoCopyWith<QuoteLineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteLineDtoCopyWith<$Res> {
  factory $QuoteLineDtoCopyWith(
    QuoteLineDto value,
    $Res Function(QuoteLineDto) then,
  ) = _$QuoteLineDtoCopyWithImpl<$Res, QuoteLineDto>;
  @useResult
  $Res call({
    String productId,
    String sku,
    String slug,
    String name,
    String imagePublicId,
    int quantity,
    int effectiveQuantity,
    int availableQuantity,
    MoneyDto? unitPrice,
    MoneyDto? previousUnitPrice,
    MoneyDto? lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown) CartLineStatus status,
  });

  $MoneyDtoCopyWith<$Res>? get unitPrice;
  $MoneyDtoCopyWith<$Res>? get previousUnitPrice;
  $MoneyDtoCopyWith<$Res>? get lineTotal;
}

/// @nodoc
class _$QuoteLineDtoCopyWithImpl<$Res, $Val extends QuoteLineDto>
    implements $QuoteLineDtoCopyWith<$Res> {
  _$QuoteLineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? slug = null,
    Object? name = null,
    Object? imagePublicId = null,
    Object? quantity = null,
    Object? effectiveQuantity = null,
    Object? availableQuantity = null,
    Object? unitPrice = freezed,
    Object? previousUnitPrice = freezed,
    Object? lineTotal = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imagePublicId: null == imagePublicId
                ? _value.imagePublicId
                : imagePublicId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            effectiveQuantity: null == effectiveQuantity
                ? _value.effectiveQuantity
                : effectiveQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            availableQuantity: null == availableQuantity
                ? _value.availableQuantity
                : availableQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as MoneyDto?,
            previousUnitPrice: freezed == previousUnitPrice
                ? _value.previousUnitPrice
                : previousUnitPrice // ignore: cast_nullable_to_non_nullable
                      as MoneyDto?,
            lineTotal: freezed == lineTotal
                ? _value.lineTotal
                : lineTotal // ignore: cast_nullable_to_non_nullable
                      as MoneyDto?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CartLineStatus,
          )
          as $Val,
    );
  }

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res>? get unitPrice {
    if (_value.unitPrice == null) {
      return null;
    }

    return $MoneyDtoCopyWith<$Res>(_value.unitPrice!, (value) {
      return _then(_value.copyWith(unitPrice: value) as $Val);
    });
  }

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res>? get previousUnitPrice {
    if (_value.previousUnitPrice == null) {
      return null;
    }

    return $MoneyDtoCopyWith<$Res>(_value.previousUnitPrice!, (value) {
      return _then(_value.copyWith(previousUnitPrice: value) as $Val);
    });
  }

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res>? get lineTotal {
    if (_value.lineTotal == null) {
      return null;
    }

    return $MoneyDtoCopyWith<$Res>(_value.lineTotal!, (value) {
      return _then(_value.copyWith(lineTotal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuoteLineDtoImplCopyWith<$Res>
    implements $QuoteLineDtoCopyWith<$Res> {
  factory _$$QuoteLineDtoImplCopyWith(
    _$QuoteLineDtoImpl value,
    $Res Function(_$QuoteLineDtoImpl) then,
  ) = __$$QuoteLineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String sku,
    String slug,
    String name,
    String imagePublicId,
    int quantity,
    int effectiveQuantity,
    int availableQuantity,
    MoneyDto? unitPrice,
    MoneyDto? previousUnitPrice,
    MoneyDto? lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown) CartLineStatus status,
  });

  @override
  $MoneyDtoCopyWith<$Res>? get unitPrice;
  @override
  $MoneyDtoCopyWith<$Res>? get previousUnitPrice;
  @override
  $MoneyDtoCopyWith<$Res>? get lineTotal;
}

/// @nodoc
class __$$QuoteLineDtoImplCopyWithImpl<$Res>
    extends _$QuoteLineDtoCopyWithImpl<$Res, _$QuoteLineDtoImpl>
    implements _$$QuoteLineDtoImplCopyWith<$Res> {
  __$$QuoteLineDtoImplCopyWithImpl(
    _$QuoteLineDtoImpl _value,
    $Res Function(_$QuoteLineDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? slug = null,
    Object? name = null,
    Object? imagePublicId = null,
    Object? quantity = null,
    Object? effectiveQuantity = null,
    Object? availableQuantity = null,
    Object? unitPrice = freezed,
    Object? previousUnitPrice = freezed,
    Object? lineTotal = freezed,
    Object? status = null,
  }) {
    return _then(
      _$QuoteLineDtoImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imagePublicId: null == imagePublicId
            ? _value.imagePublicId
            : imagePublicId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        effectiveQuantity: null == effectiveQuantity
            ? _value.effectiveQuantity
            : effectiveQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        availableQuantity: null == availableQuantity
            ? _value.availableQuantity
            : availableQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: freezed == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as MoneyDto?,
        previousUnitPrice: freezed == previousUnitPrice
            ? _value.previousUnitPrice
            : previousUnitPrice // ignore: cast_nullable_to_non_nullable
                  as MoneyDto?,
        lineTotal: freezed == lineTotal
            ? _value.lineTotal
            : lineTotal // ignore: cast_nullable_to_non_nullable
                  as MoneyDto?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CartLineStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteLineDtoImpl implements _QuoteLineDto {
  const _$QuoteLineDtoImpl({
    required this.productId,
    required this.sku,
    required this.slug,
    required this.name,
    required this.imagePublicId,
    required this.quantity,
    required this.effectiveQuantity,
    required this.availableQuantity,
    this.unitPrice,
    this.previousUnitPrice,
    this.lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown) required this.status,
  });

  factory _$QuoteLineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteLineDtoImplFromJson(json);

  @override
  final String productId;
  @override
  final String sku;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String imagePublicId;
  @override
  final int quantity;
  @override
  final int effectiveQuantity;
  @override
  final int availableQuantity;
  @override
  final MoneyDto? unitPrice;
  @override
  final MoneyDto? previousUnitPrice;
  @override
  final MoneyDto? lineTotal;
  @override
  @JsonKey(unknownEnumValue: CartLineStatus.unknown)
  final CartLineStatus status;

  @override
  String toString() {
    return 'QuoteLineDto(productId: $productId, sku: $sku, slug: $slug, name: $name, imagePublicId: $imagePublicId, quantity: $quantity, effectiveQuantity: $effectiveQuantity, availableQuantity: $availableQuantity, unitPrice: $unitPrice, previousUnitPrice: $previousUnitPrice, lineTotal: $lineTotal, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteLineDtoImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imagePublicId, imagePublicId) ||
                other.imagePublicId == imagePublicId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.effectiveQuantity, effectiveQuantity) ||
                other.effectiveQuantity == effectiveQuantity) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.previousUnitPrice, previousUnitPrice) ||
                other.previousUnitPrice == previousUnitPrice) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    sku,
    slug,
    name,
    imagePublicId,
    quantity,
    effectiveQuantity,
    availableQuantity,
    unitPrice,
    previousUnitPrice,
    lineTotal,
    status,
  );

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteLineDtoImplCopyWith<_$QuoteLineDtoImpl> get copyWith =>
      __$$QuoteLineDtoImplCopyWithImpl<_$QuoteLineDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteLineDtoImplToJson(this);
  }
}

abstract class _QuoteLineDto implements QuoteLineDto {
  const factory _QuoteLineDto({
    required final String productId,
    required final String sku,
    required final String slug,
    required final String name,
    required final String imagePublicId,
    required final int quantity,
    required final int effectiveQuantity,
    required final int availableQuantity,
    final MoneyDto? unitPrice,
    final MoneyDto? previousUnitPrice,
    final MoneyDto? lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown)
    required final CartLineStatus status,
  }) = _$QuoteLineDtoImpl;

  factory _QuoteLineDto.fromJson(Map<String, dynamic> json) =
      _$QuoteLineDtoImpl.fromJson;

  @override
  String get productId;
  @override
  String get sku;
  @override
  String get slug;
  @override
  String get name;
  @override
  String get imagePublicId;
  @override
  int get quantity;
  @override
  int get effectiveQuantity;
  @override
  int get availableQuantity;
  @override
  MoneyDto? get unitPrice;
  @override
  MoneyDto? get previousUnitPrice;
  @override
  MoneyDto? get lineTotal;
  @override
  @JsonKey(unknownEnumValue: CartLineStatus.unknown)
  CartLineStatus get status;

  /// Create a copy of QuoteLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteLineDtoImplCopyWith<_$QuoteLineDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PricingBreakdownDto _$PricingBreakdownDtoFromJson(Map<String, dynamic> json) {
  return _PricingBreakdownDto.fromJson(json);
}

/// @nodoc
mixin _$PricingBreakdownDto {
  MoneyDto get itemsSubtotal => throw _privateConstructorUsedError;
  MoneyDto? get discountTotal =>
      throw _privateConstructorUsedError; // Null while shipping is unpriced (`shippingPriced == false`).
  MoneyDto? get shippingFee => throw _privateConstructorUsedError;
  bool get shippingPriced => throw _privateConstructorUsedError;
  MoneyDto get grandTotal => throw _privateConstructorUsedError;
  bool get vatInclusive => throw _privateConstructorUsedError;
  int get vatRateBps => throw _privateConstructorUsedError;

  /// Serializes this PricingBreakdownDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PricingBreakdownDtoCopyWith<PricingBreakdownDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PricingBreakdownDtoCopyWith<$Res> {
  factory $PricingBreakdownDtoCopyWith(
    PricingBreakdownDto value,
    $Res Function(PricingBreakdownDto) then,
  ) = _$PricingBreakdownDtoCopyWithImpl<$Res, PricingBreakdownDto>;
  @useResult
  $Res call({
    MoneyDto itemsSubtotal,
    MoneyDto? discountTotal,
    MoneyDto? shippingFee,
    bool shippingPriced,
    MoneyDto grandTotal,
    bool vatInclusive,
    int vatRateBps,
  });

  $MoneyDtoCopyWith<$Res> get itemsSubtotal;
  $MoneyDtoCopyWith<$Res>? get discountTotal;
  $MoneyDtoCopyWith<$Res>? get shippingFee;
  $MoneyDtoCopyWith<$Res> get grandTotal;
}

/// @nodoc
class _$PricingBreakdownDtoCopyWithImpl<$Res, $Val extends PricingBreakdownDto>
    implements $PricingBreakdownDtoCopyWith<$Res> {
  _$PricingBreakdownDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsSubtotal = null,
    Object? discountTotal = freezed,
    Object? shippingFee = freezed,
    Object? shippingPriced = null,
    Object? grandTotal = null,
    Object? vatInclusive = null,
    Object? vatRateBps = null,
  }) {
    return _then(
      _value.copyWith(
            itemsSubtotal: null == itemsSubtotal
                ? _value.itemsSubtotal
                : itemsSubtotal // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            discountTotal: freezed == discountTotal
                ? _value.discountTotal
                : discountTotal // ignore: cast_nullable_to_non_nullable
                      as MoneyDto?,
            shippingFee: freezed == shippingFee
                ? _value.shippingFee
                : shippingFee // ignore: cast_nullable_to_non_nullable
                      as MoneyDto?,
            shippingPriced: null == shippingPriced
                ? _value.shippingPriced
                : shippingPriced // ignore: cast_nullable_to_non_nullable
                      as bool,
            grandTotal: null == grandTotal
                ? _value.grandTotal
                : grandTotal // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            vatInclusive: null == vatInclusive
                ? _value.vatInclusive
                : vatInclusive // ignore: cast_nullable_to_non_nullable
                      as bool,
            vatRateBps: null == vatRateBps
                ? _value.vatRateBps
                : vatRateBps // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get itemsSubtotal {
    return $MoneyDtoCopyWith<$Res>(_value.itemsSubtotal, (value) {
      return _then(_value.copyWith(itemsSubtotal: value) as $Val);
    });
  }

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res>? get discountTotal {
    if (_value.discountTotal == null) {
      return null;
    }

    return $MoneyDtoCopyWith<$Res>(_value.discountTotal!, (value) {
      return _then(_value.copyWith(discountTotal: value) as $Val);
    });
  }

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res>? get shippingFee {
    if (_value.shippingFee == null) {
      return null;
    }

    return $MoneyDtoCopyWith<$Res>(_value.shippingFee!, (value) {
      return _then(_value.copyWith(shippingFee: value) as $Val);
    });
  }

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get grandTotal {
    return $MoneyDtoCopyWith<$Res>(_value.grandTotal, (value) {
      return _then(_value.copyWith(grandTotal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PricingBreakdownDtoImplCopyWith<$Res>
    implements $PricingBreakdownDtoCopyWith<$Res> {
  factory _$$PricingBreakdownDtoImplCopyWith(
    _$PricingBreakdownDtoImpl value,
    $Res Function(_$PricingBreakdownDtoImpl) then,
  ) = __$$PricingBreakdownDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MoneyDto itemsSubtotal,
    MoneyDto? discountTotal,
    MoneyDto? shippingFee,
    bool shippingPriced,
    MoneyDto grandTotal,
    bool vatInclusive,
    int vatRateBps,
  });

  @override
  $MoneyDtoCopyWith<$Res> get itemsSubtotal;
  @override
  $MoneyDtoCopyWith<$Res>? get discountTotal;
  @override
  $MoneyDtoCopyWith<$Res>? get shippingFee;
  @override
  $MoneyDtoCopyWith<$Res> get grandTotal;
}

/// @nodoc
class __$$PricingBreakdownDtoImplCopyWithImpl<$Res>
    extends _$PricingBreakdownDtoCopyWithImpl<$Res, _$PricingBreakdownDtoImpl>
    implements _$$PricingBreakdownDtoImplCopyWith<$Res> {
  __$$PricingBreakdownDtoImplCopyWithImpl(
    _$PricingBreakdownDtoImpl _value,
    $Res Function(_$PricingBreakdownDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsSubtotal = null,
    Object? discountTotal = freezed,
    Object? shippingFee = freezed,
    Object? shippingPriced = null,
    Object? grandTotal = null,
    Object? vatInclusive = null,
    Object? vatRateBps = null,
  }) {
    return _then(
      _$PricingBreakdownDtoImpl(
        itemsSubtotal: null == itemsSubtotal
            ? _value.itemsSubtotal
            : itemsSubtotal // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        discountTotal: freezed == discountTotal
            ? _value.discountTotal
            : discountTotal // ignore: cast_nullable_to_non_nullable
                  as MoneyDto?,
        shippingFee: freezed == shippingFee
            ? _value.shippingFee
            : shippingFee // ignore: cast_nullable_to_non_nullable
                  as MoneyDto?,
        shippingPriced: null == shippingPriced
            ? _value.shippingPriced
            : shippingPriced // ignore: cast_nullable_to_non_nullable
                  as bool,
        grandTotal: null == grandTotal
            ? _value.grandTotal
            : grandTotal // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        vatInclusive: null == vatInclusive
            ? _value.vatInclusive
            : vatInclusive // ignore: cast_nullable_to_non_nullable
                  as bool,
        vatRateBps: null == vatRateBps
            ? _value.vatRateBps
            : vatRateBps // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PricingBreakdownDtoImpl implements _PricingBreakdownDto {
  const _$PricingBreakdownDtoImpl({
    required this.itemsSubtotal,
    this.discountTotal,
    this.shippingFee,
    required this.shippingPriced,
    required this.grandTotal,
    required this.vatInclusive,
    required this.vatRateBps,
  });

  factory _$PricingBreakdownDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PricingBreakdownDtoImplFromJson(json);

  @override
  final MoneyDto itemsSubtotal;
  @override
  final MoneyDto? discountTotal;
  // Null while shipping is unpriced (`shippingPriced == false`).
  @override
  final MoneyDto? shippingFee;
  @override
  final bool shippingPriced;
  @override
  final MoneyDto grandTotal;
  @override
  final bool vatInclusive;
  @override
  final int vatRateBps;

  @override
  String toString() {
    return 'PricingBreakdownDto(itemsSubtotal: $itemsSubtotal, discountTotal: $discountTotal, shippingFee: $shippingFee, shippingPriced: $shippingPriced, grandTotal: $grandTotal, vatInclusive: $vatInclusive, vatRateBps: $vatRateBps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PricingBreakdownDtoImpl &&
            (identical(other.itemsSubtotal, itemsSubtotal) ||
                other.itemsSubtotal == itemsSubtotal) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.shippingFee, shippingFee) ||
                other.shippingFee == shippingFee) &&
            (identical(other.shippingPriced, shippingPriced) ||
                other.shippingPriced == shippingPriced) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.vatInclusive, vatInclusive) ||
                other.vatInclusive == vatInclusive) &&
            (identical(other.vatRateBps, vatRateBps) ||
                other.vatRateBps == vatRateBps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    itemsSubtotal,
    discountTotal,
    shippingFee,
    shippingPriced,
    grandTotal,
    vatInclusive,
    vatRateBps,
  );

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PricingBreakdownDtoImplCopyWith<_$PricingBreakdownDtoImpl> get copyWith =>
      __$$PricingBreakdownDtoImplCopyWithImpl<_$PricingBreakdownDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PricingBreakdownDtoImplToJson(this);
  }
}

abstract class _PricingBreakdownDto implements PricingBreakdownDto {
  const factory _PricingBreakdownDto({
    required final MoneyDto itemsSubtotal,
    final MoneyDto? discountTotal,
    final MoneyDto? shippingFee,
    required final bool shippingPriced,
    required final MoneyDto grandTotal,
    required final bool vatInclusive,
    required final int vatRateBps,
  }) = _$PricingBreakdownDtoImpl;

  factory _PricingBreakdownDto.fromJson(Map<String, dynamic> json) =
      _$PricingBreakdownDtoImpl.fromJson;

  @override
  MoneyDto get itemsSubtotal;
  @override
  MoneyDto? get discountTotal; // Null while shipping is unpriced (`shippingPriced == false`).
  @override
  MoneyDto? get shippingFee;
  @override
  bool get shippingPriced;
  @override
  MoneyDto get grandTotal;
  @override
  bool get vatInclusive;
  @override
  int get vatRateBps;

  /// Create a copy of PricingBreakdownDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PricingBreakdownDtoImplCopyWith<_$PricingBreakdownDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckoutQuoteViewDto _$CheckoutQuoteViewDtoFromJson(Map<String, dynamic> json) {
  return _CheckoutQuoteViewDto.fromJson(json);
}

/// @nodoc
mixin _$CheckoutQuoteViewDto {
  List<QuoteLineDto> get items => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PricingBreakdownDto get pricing => throw _privateConstructorUsedError;
  bool get hasBlockingIssues => throw _privateConstructorUsedError;
  bool get canPlaceOrder => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this CheckoutQuoteViewDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutQuoteViewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutQuoteViewDtoCopyWith<CheckoutQuoteViewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutQuoteViewDtoCopyWith<$Res> {
  factory $CheckoutQuoteViewDtoCopyWith(
    CheckoutQuoteViewDto value,
    $Res Function(CheckoutQuoteViewDto) then,
  ) = _$CheckoutQuoteViewDtoCopyWithImpl<$Res, CheckoutQuoteViewDto>;
  @useResult
  $Res call({
    List<QuoteLineDto> items,
    int itemCount,
    int totalQuantity,
    String currency,
    PricingBreakdownDto pricing,
    bool hasBlockingIssues,
    bool canPlaceOrder,
    DateTime generatedAt,
  });

  $PricingBreakdownDtoCopyWith<$Res> get pricing;
}

/// @nodoc
class _$CheckoutQuoteViewDtoCopyWithImpl<
  $Res,
  $Val extends CheckoutQuoteViewDto
>
    implements $CheckoutQuoteViewDtoCopyWith<$Res> {
  _$CheckoutQuoteViewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutQuoteViewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemCount = null,
    Object? totalQuantity = null,
    Object? currency = null,
    Object? pricing = null,
    Object? hasBlockingIssues = null,
    Object? canPlaceOrder = null,
    Object? generatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<QuoteLineDto>,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuantity: null == totalQuantity
                ? _value.totalQuantity
                : totalQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            pricing: null == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as PricingBreakdownDto,
            hasBlockingIssues: null == hasBlockingIssues
                ? _value.hasBlockingIssues
                : hasBlockingIssues // ignore: cast_nullable_to_non_nullable
                      as bool,
            canPlaceOrder: null == canPlaceOrder
                ? _value.canPlaceOrder
                : canPlaceOrder // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckoutQuoteViewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PricingBreakdownDtoCopyWith<$Res> get pricing {
    return $PricingBreakdownDtoCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutQuoteViewDtoImplCopyWith<$Res>
    implements $CheckoutQuoteViewDtoCopyWith<$Res> {
  factory _$$CheckoutQuoteViewDtoImplCopyWith(
    _$CheckoutQuoteViewDtoImpl value,
    $Res Function(_$CheckoutQuoteViewDtoImpl) then,
  ) = __$$CheckoutQuoteViewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<QuoteLineDto> items,
    int itemCount,
    int totalQuantity,
    String currency,
    PricingBreakdownDto pricing,
    bool hasBlockingIssues,
    bool canPlaceOrder,
    DateTime generatedAt,
  });

  @override
  $PricingBreakdownDtoCopyWith<$Res> get pricing;
}

/// @nodoc
class __$$CheckoutQuoteViewDtoImplCopyWithImpl<$Res>
    extends _$CheckoutQuoteViewDtoCopyWithImpl<$Res, _$CheckoutQuoteViewDtoImpl>
    implements _$$CheckoutQuoteViewDtoImplCopyWith<$Res> {
  __$$CheckoutQuoteViewDtoImplCopyWithImpl(
    _$CheckoutQuoteViewDtoImpl _value,
    $Res Function(_$CheckoutQuoteViewDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutQuoteViewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemCount = null,
    Object? totalQuantity = null,
    Object? currency = null,
    Object? pricing = null,
    Object? hasBlockingIssues = null,
    Object? canPlaceOrder = null,
    Object? generatedAt = null,
  }) {
    return _then(
      _$CheckoutQuoteViewDtoImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<QuoteLineDto>,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuantity: null == totalQuantity
            ? _value.totalQuantity
            : totalQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        pricing: null == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as PricingBreakdownDto,
        hasBlockingIssues: null == hasBlockingIssues
            ? _value.hasBlockingIssues
            : hasBlockingIssues // ignore: cast_nullable_to_non_nullable
                  as bool,
        canPlaceOrder: null == canPlaceOrder
            ? _value.canPlaceOrder
            : canPlaceOrder // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutQuoteViewDtoImpl implements _CheckoutQuoteViewDto {
  const _$CheckoutQuoteViewDtoImpl({
    required final List<QuoteLineDto> items,
    required this.itemCount,
    required this.totalQuantity,
    required this.currency,
    required this.pricing,
    required this.hasBlockingIssues,
    required this.canPlaceOrder,
    required this.generatedAt,
  }) : _items = items;

  factory _$CheckoutQuoteViewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutQuoteViewDtoImplFromJson(json);

  final List<QuoteLineDto> _items;
  @override
  List<QuoteLineDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int itemCount;
  @override
  final int totalQuantity;
  @override
  final String currency;
  @override
  final PricingBreakdownDto pricing;
  @override
  final bool hasBlockingIssues;
  @override
  final bool canPlaceOrder;
  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'CheckoutQuoteViewDto(items: $items, itemCount: $itemCount, totalQuantity: $totalQuantity, currency: $currency, pricing: $pricing, hasBlockingIssues: $hasBlockingIssues, canPlaceOrder: $canPlaceOrder, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutQuoteViewDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.hasBlockingIssues, hasBlockingIssues) ||
                other.hasBlockingIssues == hasBlockingIssues) &&
            (identical(other.canPlaceOrder, canPlaceOrder) ||
                other.canPlaceOrder == canPlaceOrder) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    itemCount,
    totalQuantity,
    currency,
    pricing,
    hasBlockingIssues,
    canPlaceOrder,
    generatedAt,
  );

  /// Create a copy of CheckoutQuoteViewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutQuoteViewDtoImplCopyWith<_$CheckoutQuoteViewDtoImpl>
  get copyWith =>
      __$$CheckoutQuoteViewDtoImplCopyWithImpl<_$CheckoutQuoteViewDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutQuoteViewDtoImplToJson(this);
  }
}

abstract class _CheckoutQuoteViewDto implements CheckoutQuoteViewDto {
  const factory _CheckoutQuoteViewDto({
    required final List<QuoteLineDto> items,
    required final int itemCount,
    required final int totalQuantity,
    required final String currency,
    required final PricingBreakdownDto pricing,
    required final bool hasBlockingIssues,
    required final bool canPlaceOrder,
    required final DateTime generatedAt,
  }) = _$CheckoutQuoteViewDtoImpl;

  factory _CheckoutQuoteViewDto.fromJson(Map<String, dynamic> json) =
      _$CheckoutQuoteViewDtoImpl.fromJson;

  @override
  List<QuoteLineDto> get items;
  @override
  int get itemCount;
  @override
  int get totalQuantity;
  @override
  String get currency;
  @override
  PricingBreakdownDto get pricing;
  @override
  bool get hasBlockingIssues;
  @override
  bool get canPlaceOrder;
  @override
  DateTime get generatedAt;

  /// Create a copy of CheckoutQuoteViewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutQuoteViewDtoImplCopyWith<_$CheckoutQuoteViewDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CheckoutQuoteDto _$CheckoutQuoteDtoFromJson(Map<String, dynamic> json) {
  return _CheckoutQuoteDto.fromJson(json);
}

/// @nodoc
mixin _$CheckoutQuoteDto {
  String? get addressId => throw _privateConstructorUsedError;

  /// Serializes this CheckoutQuoteDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutQuoteDtoCopyWith<CheckoutQuoteDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutQuoteDtoCopyWith<$Res> {
  factory $CheckoutQuoteDtoCopyWith(
    CheckoutQuoteDto value,
    $Res Function(CheckoutQuoteDto) then,
  ) = _$CheckoutQuoteDtoCopyWithImpl<$Res, CheckoutQuoteDto>;
  @useResult
  $Res call({String? addressId});
}

/// @nodoc
class _$CheckoutQuoteDtoCopyWithImpl<$Res, $Val extends CheckoutQuoteDto>
    implements $CheckoutQuoteDtoCopyWith<$Res> {
  _$CheckoutQuoteDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? addressId = freezed}) {
    return _then(
      _value.copyWith(
            addressId: freezed == addressId
                ? _value.addressId
                : addressId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckoutQuoteDtoImplCopyWith<$Res>
    implements $CheckoutQuoteDtoCopyWith<$Res> {
  factory _$$CheckoutQuoteDtoImplCopyWith(
    _$CheckoutQuoteDtoImpl value,
    $Res Function(_$CheckoutQuoteDtoImpl) then,
  ) = __$$CheckoutQuoteDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? addressId});
}

/// @nodoc
class __$$CheckoutQuoteDtoImplCopyWithImpl<$Res>
    extends _$CheckoutQuoteDtoCopyWithImpl<$Res, _$CheckoutQuoteDtoImpl>
    implements _$$CheckoutQuoteDtoImplCopyWith<$Res> {
  __$$CheckoutQuoteDtoImplCopyWithImpl(
    _$CheckoutQuoteDtoImpl _value,
    $Res Function(_$CheckoutQuoteDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? addressId = freezed}) {
    return _then(
      _$CheckoutQuoteDtoImpl(
        addressId: freezed == addressId
            ? _value.addressId
            : addressId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutQuoteDtoImpl implements _CheckoutQuoteDto {
  const _$CheckoutQuoteDtoImpl({this.addressId});

  factory _$CheckoutQuoteDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutQuoteDtoImplFromJson(json);

  @override
  final String? addressId;

  @override
  String toString() {
    return 'CheckoutQuoteDto(addressId: $addressId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutQuoteDtoImpl &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, addressId);

  /// Create a copy of CheckoutQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutQuoteDtoImplCopyWith<_$CheckoutQuoteDtoImpl> get copyWith =>
      __$$CheckoutQuoteDtoImplCopyWithImpl<_$CheckoutQuoteDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutQuoteDtoImplToJson(this);
  }
}

abstract class _CheckoutQuoteDto implements CheckoutQuoteDto {
  const factory _CheckoutQuoteDto({final String? addressId}) =
      _$CheckoutQuoteDtoImpl;

  factory _CheckoutQuoteDto.fromJson(Map<String, dynamic> json) =
      _$CheckoutQuoteDtoImpl.fromJson;

  @override
  String? get addressId;

  /// Create a copy of CheckoutQuoteDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutQuoteDtoImplCopyWith<_$CheckoutQuoteDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManualPaymentInstructionsDto _$ManualPaymentInstructionsDtoFromJson(
  Map<String, dynamic> json,
) {
  return _ManualPaymentInstructionsDto.fromJson(json);
}

/// @nodoc
mixin _$ManualPaymentInstructionsDto {
  List<String> get availableMethods => throw _privateConstructorUsedError;
  String get walletNumber => throw _privateConstructorUsedError;
  String get instapayAddress => throw _privateConstructorUsedError;
  String get whatsappNumber => throw _privateConstructorUsedError;

  /// Serializes this ManualPaymentInstructionsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManualPaymentInstructionsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManualPaymentInstructionsDtoCopyWith<ManualPaymentInstructionsDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManualPaymentInstructionsDtoCopyWith<$Res> {
  factory $ManualPaymentInstructionsDtoCopyWith(
    ManualPaymentInstructionsDto value,
    $Res Function(ManualPaymentInstructionsDto) then,
  ) =
      _$ManualPaymentInstructionsDtoCopyWithImpl<
        $Res,
        ManualPaymentInstructionsDto
      >;
  @useResult
  $Res call({
    List<String> availableMethods,
    String walletNumber,
    String instapayAddress,
    String whatsappNumber,
  });
}

/// @nodoc
class _$ManualPaymentInstructionsDtoCopyWithImpl<
  $Res,
  $Val extends ManualPaymentInstructionsDto
>
    implements $ManualPaymentInstructionsDtoCopyWith<$Res> {
  _$ManualPaymentInstructionsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManualPaymentInstructionsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableMethods = null,
    Object? walletNumber = null,
    Object? instapayAddress = null,
    Object? whatsappNumber = null,
  }) {
    return _then(
      _value.copyWith(
            availableMethods: null == availableMethods
                ? _value.availableMethods
                : availableMethods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            walletNumber: null == walletNumber
                ? _value.walletNumber
                : walletNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            instapayAddress: null == instapayAddress
                ? _value.instapayAddress
                : instapayAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            whatsappNumber: null == whatsappNumber
                ? _value.whatsappNumber
                : whatsappNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManualPaymentInstructionsDtoImplCopyWith<$Res>
    implements $ManualPaymentInstructionsDtoCopyWith<$Res> {
  factory _$$ManualPaymentInstructionsDtoImplCopyWith(
    _$ManualPaymentInstructionsDtoImpl value,
    $Res Function(_$ManualPaymentInstructionsDtoImpl) then,
  ) = __$$ManualPaymentInstructionsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> availableMethods,
    String walletNumber,
    String instapayAddress,
    String whatsappNumber,
  });
}

/// @nodoc
class __$$ManualPaymentInstructionsDtoImplCopyWithImpl<$Res>
    extends
        _$ManualPaymentInstructionsDtoCopyWithImpl<
          $Res,
          _$ManualPaymentInstructionsDtoImpl
        >
    implements _$$ManualPaymentInstructionsDtoImplCopyWith<$Res> {
  __$$ManualPaymentInstructionsDtoImplCopyWithImpl(
    _$ManualPaymentInstructionsDtoImpl _value,
    $Res Function(_$ManualPaymentInstructionsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManualPaymentInstructionsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableMethods = null,
    Object? walletNumber = null,
    Object? instapayAddress = null,
    Object? whatsappNumber = null,
  }) {
    return _then(
      _$ManualPaymentInstructionsDtoImpl(
        availableMethods: null == availableMethods
            ? _value._availableMethods
            : availableMethods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        walletNumber: null == walletNumber
            ? _value.walletNumber
            : walletNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        instapayAddress: null == instapayAddress
            ? _value.instapayAddress
            : instapayAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        whatsappNumber: null == whatsappNumber
            ? _value.whatsappNumber
            : whatsappNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManualPaymentInstructionsDtoImpl
    implements _ManualPaymentInstructionsDto {
  const _$ManualPaymentInstructionsDtoImpl({
    required final List<String> availableMethods,
    required this.walletNumber,
    required this.instapayAddress,
    required this.whatsappNumber,
  }) : _availableMethods = availableMethods;

  factory _$ManualPaymentInstructionsDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ManualPaymentInstructionsDtoImplFromJson(json);

  final List<String> _availableMethods;
  @override
  List<String> get availableMethods {
    if (_availableMethods is EqualUnmodifiableListView)
      return _availableMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableMethods);
  }

  @override
  final String walletNumber;
  @override
  final String instapayAddress;
  @override
  final String whatsappNumber;

  @override
  String toString() {
    return 'ManualPaymentInstructionsDto(availableMethods: $availableMethods, walletNumber: $walletNumber, instapayAddress: $instapayAddress, whatsappNumber: $whatsappNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManualPaymentInstructionsDtoImpl &&
            const DeepCollectionEquality().equals(
              other._availableMethods,
              _availableMethods,
            ) &&
            (identical(other.walletNumber, walletNumber) ||
                other.walletNumber == walletNumber) &&
            (identical(other.instapayAddress, instapayAddress) ||
                other.instapayAddress == instapayAddress) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_availableMethods),
    walletNumber,
    instapayAddress,
    whatsappNumber,
  );

  /// Create a copy of ManualPaymentInstructionsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManualPaymentInstructionsDtoImplCopyWith<
    _$ManualPaymentInstructionsDtoImpl
  >
  get copyWith =>
      __$$ManualPaymentInstructionsDtoImplCopyWithImpl<
        _$ManualPaymentInstructionsDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManualPaymentInstructionsDtoImplToJson(this);
  }
}

abstract class _ManualPaymentInstructionsDto
    implements ManualPaymentInstructionsDto {
  const factory _ManualPaymentInstructionsDto({
    required final List<String> availableMethods,
    required final String walletNumber,
    required final String instapayAddress,
    required final String whatsappNumber,
  }) = _$ManualPaymentInstructionsDtoImpl;

  factory _ManualPaymentInstructionsDto.fromJson(Map<String, dynamic> json) =
      _$ManualPaymentInstructionsDtoImpl.fromJson;

  @override
  List<String> get availableMethods;
  @override
  String get walletNumber;
  @override
  String get instapayAddress;
  @override
  String get whatsappNumber;

  /// Create a copy of ManualPaymentInstructionsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManualPaymentInstructionsDtoImplCopyWith<
    _$ManualPaymentInstructionsDtoImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

PlaceOrderDto _$PlaceOrderDtoFromJson(Map<String, dynamic> json) {
  return _PlaceOrderDto.fromJson(json);
}

/// @nodoc
mixin _$PlaceOrderDto {
  String get addressId => throw _privateConstructorUsedError;
  String? get customerNote => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  PaymentMethod? get paymentMethod => throw _privateConstructorUsedError;
  String? get transferSender => throw _privateConstructorUsedError;

  /// Serializes this PlaceOrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceOrderDtoCopyWith<PlaceOrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceOrderDtoCopyWith<$Res> {
  factory $PlaceOrderDtoCopyWith(
    PlaceOrderDto value,
    $Res Function(PlaceOrderDto) then,
  ) = _$PlaceOrderDtoCopyWithImpl<$Res, PlaceOrderDto>;
  @useResult
  $Res call({
    String addressId,
    String? customerNote,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    PaymentMethod? paymentMethod,
    String? transferSender,
  });
}

/// @nodoc
class _$PlaceOrderDtoCopyWithImpl<$Res, $Val extends PlaceOrderDto>
    implements $PlaceOrderDtoCopyWith<$Res> {
  _$PlaceOrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressId = null,
    Object? customerNote = freezed,
    Object? paymentMethod = freezed,
    Object? transferSender = freezed,
  }) {
    return _then(
      _value.copyWith(
            addressId: null == addressId
                ? _value.addressId
                : addressId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerNote: freezed == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod?,
            transferSender: freezed == transferSender
                ? _value.transferSender
                : transferSender // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaceOrderDtoImplCopyWith<$Res>
    implements $PlaceOrderDtoCopyWith<$Res> {
  factory _$$PlaceOrderDtoImplCopyWith(
    _$PlaceOrderDtoImpl value,
    $Res Function(_$PlaceOrderDtoImpl) then,
  ) = __$$PlaceOrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String addressId,
    String? customerNote,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    PaymentMethod? paymentMethod,
    String? transferSender,
  });
}

/// @nodoc
class __$$PlaceOrderDtoImplCopyWithImpl<$Res>
    extends _$PlaceOrderDtoCopyWithImpl<$Res, _$PlaceOrderDtoImpl>
    implements _$$PlaceOrderDtoImplCopyWith<$Res> {
  __$$PlaceOrderDtoImplCopyWithImpl(
    _$PlaceOrderDtoImpl _value,
    $Res Function(_$PlaceOrderDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaceOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressId = null,
    Object? customerNote = freezed,
    Object? paymentMethod = freezed,
    Object? transferSender = freezed,
  }) {
    return _then(
      _$PlaceOrderDtoImpl(
        addressId: null == addressId
            ? _value.addressId
            : addressId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerNote: freezed == customerNote
            ? _value.customerNote
            : customerNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod?,
        transferSender: freezed == transferSender
            ? _value.transferSender
            : transferSender // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceOrderDtoImpl implements _PlaceOrderDto {
  const _$PlaceOrderDtoImpl({
    required this.addressId,
    this.customerNote,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown) this.paymentMethod,
    this.transferSender,
  });

  factory _$PlaceOrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceOrderDtoImplFromJson(json);

  @override
  final String addressId;
  @override
  final String? customerNote;
  @override
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  final PaymentMethod? paymentMethod;
  @override
  final String? transferSender;

  @override
  String toString() {
    return 'PlaceOrderDto(addressId: $addressId, customerNote: $customerNote, paymentMethod: $paymentMethod, transferSender: $transferSender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceOrderDtoImpl &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.transferSender, transferSender) ||
                other.transferSender == transferSender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    addressId,
    customerNote,
    paymentMethod,
    transferSender,
  );

  /// Create a copy of PlaceOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceOrderDtoImplCopyWith<_$PlaceOrderDtoImpl> get copyWith =>
      __$$PlaceOrderDtoImplCopyWithImpl<_$PlaceOrderDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceOrderDtoImplToJson(this);
  }
}

abstract class _PlaceOrderDto implements PlaceOrderDto {
  const factory _PlaceOrderDto({
    required final String addressId,
    final String? customerNote,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    final PaymentMethod? paymentMethod,
    final String? transferSender,
  }) = _$PlaceOrderDtoImpl;

  factory _PlaceOrderDto.fromJson(Map<String, dynamic> json) =
      _$PlaceOrderDtoImpl.fromJson;

  @override
  String get addressId;
  @override
  String? get customerNote;
  @override
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  PaymentMethod? get paymentMethod;
  @override
  String? get transferSender;

  /// Create a copy of PlaceOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceOrderDtoImplCopyWith<_$PlaceOrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
