// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartLineDto _$CartLineDtoFromJson(Map<String, dynamic> json) {
  return _CartLineDto.fromJson(json);
}

/// @nodoc
mixin _$CartLineDto {
  String get productId => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
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
  DateTime get addedAt => throw _privateConstructorUsedError;

  /// Serializes this CartLineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartLineDtoCopyWith<CartLineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartLineDtoCopyWith<$Res> {
  factory $CartLineDtoCopyWith(
    CartLineDto value,
    $Res Function(CartLineDto) then,
  ) = _$CartLineDtoCopyWithImpl<$Res, CartLineDto>;
  @useResult
  $Res call({
    String productId,
    String slug,
    String sku,
    String name,
    String imagePublicId,
    int quantity,
    int effectiveQuantity,
    int availableQuantity,
    MoneyDto? unitPrice,
    MoneyDto? previousUnitPrice,
    MoneyDto? lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown) CartLineStatus status,
    DateTime addedAt,
  });

  $MoneyDtoCopyWith<$Res>? get unitPrice;
  $MoneyDtoCopyWith<$Res>? get previousUnitPrice;
  $MoneyDtoCopyWith<$Res>? get lineTotal;
}

/// @nodoc
class _$CartLineDtoCopyWithImpl<$Res, $Val extends CartLineDto>
    implements $CartLineDtoCopyWith<$Res> {
  _$CartLineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? slug = null,
    Object? sku = null,
    Object? name = null,
    Object? imagePublicId = null,
    Object? quantity = null,
    Object? effectiveQuantity = null,
    Object? availableQuantity = null,
    Object? unitPrice = freezed,
    Object? previousUnitPrice = freezed,
    Object? lineTotal = freezed,
    Object? status = null,
    Object? addedAt = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
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
            addedAt: null == addedAt
                ? _value.addedAt
                : addedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of CartLineDto
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

  /// Create a copy of CartLineDto
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

  /// Create a copy of CartLineDto
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
abstract class _$$CartLineDtoImplCopyWith<$Res>
    implements $CartLineDtoCopyWith<$Res> {
  factory _$$CartLineDtoImplCopyWith(
    _$CartLineDtoImpl value,
    $Res Function(_$CartLineDtoImpl) then,
  ) = __$$CartLineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String slug,
    String sku,
    String name,
    String imagePublicId,
    int quantity,
    int effectiveQuantity,
    int availableQuantity,
    MoneyDto? unitPrice,
    MoneyDto? previousUnitPrice,
    MoneyDto? lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown) CartLineStatus status,
    DateTime addedAt,
  });

  @override
  $MoneyDtoCopyWith<$Res>? get unitPrice;
  @override
  $MoneyDtoCopyWith<$Res>? get previousUnitPrice;
  @override
  $MoneyDtoCopyWith<$Res>? get lineTotal;
}

/// @nodoc
class __$$CartLineDtoImplCopyWithImpl<$Res>
    extends _$CartLineDtoCopyWithImpl<$Res, _$CartLineDtoImpl>
    implements _$$CartLineDtoImplCopyWith<$Res> {
  __$$CartLineDtoImplCopyWithImpl(
    _$CartLineDtoImpl _value,
    $Res Function(_$CartLineDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? slug = null,
    Object? sku = null,
    Object? name = null,
    Object? imagePublicId = null,
    Object? quantity = null,
    Object? effectiveQuantity = null,
    Object? availableQuantity = null,
    Object? unitPrice = freezed,
    Object? previousUnitPrice = freezed,
    Object? lineTotal = freezed,
    Object? status = null,
    Object? addedAt = null,
  }) {
    return _then(
      _$CartLineDtoImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
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
        addedAt: null == addedAt
            ? _value.addedAt
            : addedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartLineDtoImpl implements _CartLineDto {
  const _$CartLineDtoImpl({
    required this.productId,
    required this.slug,
    required this.sku,
    required this.name,
    required this.imagePublicId,
    required this.quantity,
    required this.effectiveQuantity,
    required this.availableQuantity,
    this.unitPrice,
    this.previousUnitPrice,
    this.lineTotal,
    @JsonKey(unknownEnumValue: CartLineStatus.unknown) required this.status,
    required this.addedAt,
  });

  factory _$CartLineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartLineDtoImplFromJson(json);

  @override
  final String productId;
  @override
  final String slug;
  @override
  final String sku;
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
  final DateTime addedAt;

  @override
  String toString() {
    return 'CartLineDto(productId: $productId, slug: $slug, sku: $sku, name: $name, imagePublicId: $imagePublicId, quantity: $quantity, effectiveQuantity: $effectiveQuantity, availableQuantity: $availableQuantity, unitPrice: $unitPrice, previousUnitPrice: $previousUnitPrice, lineTotal: $lineTotal, status: $status, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartLineDtoImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sku, sku) || other.sku == sku) &&
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    slug,
    sku,
    name,
    imagePublicId,
    quantity,
    effectiveQuantity,
    availableQuantity,
    unitPrice,
    previousUnitPrice,
    lineTotal,
    status,
    addedAt,
  );

  /// Create a copy of CartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartLineDtoImplCopyWith<_$CartLineDtoImpl> get copyWith =>
      __$$CartLineDtoImplCopyWithImpl<_$CartLineDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartLineDtoImplToJson(this);
  }
}

abstract class _CartLineDto implements CartLineDto {
  const factory _CartLineDto({
    required final String productId,
    required final String slug,
    required final String sku,
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
    required final DateTime addedAt,
  }) = _$CartLineDtoImpl;

  factory _CartLineDto.fromJson(Map<String, dynamic> json) =
      _$CartLineDtoImpl.fromJson;

  @override
  String get productId;
  @override
  String get slug;
  @override
  String get sku;
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
  @override
  DateTime get addedAt;

  /// Create a copy of CartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartLineDtoImplCopyWith<_$CartLineDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartDto _$CartDtoFromJson(Map<String, dynamic> json) {
  return _CartDto.fromJson(json);
}

/// @nodoc
mixin _$CartDto {
  List<CartLineDto> get items => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  MoneyDto get itemsSubtotal => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  bool get hasBlockingIssues => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this CartDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartDtoCopyWith<CartDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartDtoCopyWith<$Res> {
  factory $CartDtoCopyWith(CartDto value, $Res Function(CartDto) then) =
      _$CartDtoCopyWithImpl<$Res, CartDto>;
  @useResult
  $Res call({
    List<CartLineDto> items,
    int itemCount,
    int totalQuantity,
    MoneyDto itemsSubtotal,
    String currency,
    bool hasBlockingIssues,
    DateTime updatedAt,
    DateTime expiresAt,
  });

  $MoneyDtoCopyWith<$Res> get itemsSubtotal;
}

/// @nodoc
class _$CartDtoCopyWithImpl<$Res, $Val extends CartDto>
    implements $CartDtoCopyWith<$Res> {
  _$CartDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemCount = null,
    Object? totalQuantity = null,
    Object? itemsSubtotal = null,
    Object? currency = null,
    Object? hasBlockingIssues = null,
    Object? updatedAt = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartLineDto>,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuantity: null == totalQuantity
                ? _value.totalQuantity
                : totalQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            itemsSubtotal: null == itemsSubtotal
                ? _value.itemsSubtotal
                : itemsSubtotal // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            hasBlockingIssues: null == hasBlockingIssues
                ? _value.hasBlockingIssues
                : hasBlockingIssues // ignore: cast_nullable_to_non_nullable
                      as bool,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of CartDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get itemsSubtotal {
    return $MoneyDtoCopyWith<$Res>(_value.itemsSubtotal, (value) {
      return _then(_value.copyWith(itemsSubtotal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartDtoImplCopyWith<$Res> implements $CartDtoCopyWith<$Res> {
  factory _$$CartDtoImplCopyWith(
    _$CartDtoImpl value,
    $Res Function(_$CartDtoImpl) then,
  ) = __$$CartDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CartLineDto> items,
    int itemCount,
    int totalQuantity,
    MoneyDto itemsSubtotal,
    String currency,
    bool hasBlockingIssues,
    DateTime updatedAt,
    DateTime expiresAt,
  });

  @override
  $MoneyDtoCopyWith<$Res> get itemsSubtotal;
}

/// @nodoc
class __$$CartDtoImplCopyWithImpl<$Res>
    extends _$CartDtoCopyWithImpl<$Res, _$CartDtoImpl>
    implements _$$CartDtoImplCopyWith<$Res> {
  __$$CartDtoImplCopyWithImpl(
    _$CartDtoImpl _value,
    $Res Function(_$CartDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemCount = null,
    Object? totalQuantity = null,
    Object? itemsSubtotal = null,
    Object? currency = null,
    Object? hasBlockingIssues = null,
    Object? updatedAt = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$CartDtoImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartLineDto>,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuantity: null == totalQuantity
            ? _value.totalQuantity
            : totalQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        itemsSubtotal: null == itemsSubtotal
            ? _value.itemsSubtotal
            : itemsSubtotal // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        hasBlockingIssues: null == hasBlockingIssues
            ? _value.hasBlockingIssues
            : hasBlockingIssues // ignore: cast_nullable_to_non_nullable
                  as bool,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartDtoImpl implements _CartDto {
  const _$CartDtoImpl({
    required final List<CartLineDto> items,
    required this.itemCount,
    required this.totalQuantity,
    required this.itemsSubtotal,
    required this.currency,
    required this.hasBlockingIssues,
    required this.updatedAt,
    required this.expiresAt,
  }) : _items = items;

  factory _$CartDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartDtoImplFromJson(json);

  final List<CartLineDto> _items;
  @override
  List<CartLineDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int itemCount;
  @override
  final int totalQuantity;
  @override
  final MoneyDto itemsSubtotal;
  @override
  final String currency;
  @override
  final bool hasBlockingIssues;
  @override
  final DateTime updatedAt;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'CartDto(items: $items, itemCount: $itemCount, totalQuantity: $totalQuantity, itemsSubtotal: $itemsSubtotal, currency: $currency, hasBlockingIssues: $hasBlockingIssues, updatedAt: $updatedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.itemsSubtotal, itemsSubtotal) ||
                other.itemsSubtotal == itemsSubtotal) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.hasBlockingIssues, hasBlockingIssues) ||
                other.hasBlockingIssues == hasBlockingIssues) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    itemCount,
    totalQuantity,
    itemsSubtotal,
    currency,
    hasBlockingIssues,
    updatedAt,
    expiresAt,
  );

  /// Create a copy of CartDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartDtoImplCopyWith<_$CartDtoImpl> get copyWith =>
      __$$CartDtoImplCopyWithImpl<_$CartDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartDtoImplToJson(this);
  }
}

abstract class _CartDto implements CartDto {
  const factory _CartDto({
    required final List<CartLineDto> items,
    required final int itemCount,
    required final int totalQuantity,
    required final MoneyDto itemsSubtotal,
    required final String currency,
    required final bool hasBlockingIssues,
    required final DateTime updatedAt,
    required final DateTime expiresAt,
  }) = _$CartDtoImpl;

  factory _CartDto.fromJson(Map<String, dynamic> json) = _$CartDtoImpl.fromJson;

  @override
  List<CartLineDto> get items;
  @override
  int get itemCount;
  @override
  int get totalQuantity;
  @override
  MoneyDto get itemsSubtotal;
  @override
  String get currency;
  @override
  bool get hasBlockingIssues;
  @override
  DateTime get updatedAt;
  @override
  DateTime get expiresAt;

  /// Create a copy of CartDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartDtoImplCopyWith<_$CartDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddCartItemDto _$AddCartItemDtoFromJson(Map<String, dynamic> json) {
  return _AddCartItemDto.fromJson(json);
}

/// @nodoc
mixin _$AddCartItemDto {
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this AddCartItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddCartItemDtoCopyWith<AddCartItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddCartItemDtoCopyWith<$Res> {
  factory $AddCartItemDtoCopyWith(
    AddCartItemDto value,
    $Res Function(AddCartItemDto) then,
  ) = _$AddCartItemDtoCopyWithImpl<$Res, AddCartItemDto>;
  @useResult
  $Res call({String productId, int quantity});
}

/// @nodoc
class _$AddCartItemDtoCopyWithImpl<$Res, $Val extends AddCartItemDto>
    implements $AddCartItemDtoCopyWith<$Res> {
  _$AddCartItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? quantity = null}) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddCartItemDtoImplCopyWith<$Res>
    implements $AddCartItemDtoCopyWith<$Res> {
  factory _$$AddCartItemDtoImplCopyWith(
    _$AddCartItemDtoImpl value,
    $Res Function(_$AddCartItemDtoImpl) then,
  ) = __$$AddCartItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productId, int quantity});
}

/// @nodoc
class __$$AddCartItemDtoImplCopyWithImpl<$Res>
    extends _$AddCartItemDtoCopyWithImpl<$Res, _$AddCartItemDtoImpl>
    implements _$$AddCartItemDtoImplCopyWith<$Res> {
  __$$AddCartItemDtoImplCopyWithImpl(
    _$AddCartItemDtoImpl _value,
    $Res Function(_$AddCartItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? quantity = null}) {
    return _then(
      _$AddCartItemDtoImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddCartItemDtoImpl implements _AddCartItemDto {
  const _$AddCartItemDtoImpl({required this.productId, required this.quantity});

  factory _$AddCartItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddCartItemDtoImplFromJson(json);

  @override
  final String productId;
  @override
  final int quantity;

  @override
  String toString() {
    return 'AddCartItemDto(productId: $productId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCartItemDtoImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, quantity);

  /// Create a copy of AddCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCartItemDtoImplCopyWith<_$AddCartItemDtoImpl> get copyWith =>
      __$$AddCartItemDtoImplCopyWithImpl<_$AddCartItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddCartItemDtoImplToJson(this);
  }
}

abstract class _AddCartItemDto implements AddCartItemDto {
  const factory _AddCartItemDto({
    required final String productId,
    required final int quantity,
  }) = _$AddCartItemDtoImpl;

  factory _AddCartItemDto.fromJson(Map<String, dynamic> json) =
      _$AddCartItemDtoImpl.fromJson;

  @override
  String get productId;
  @override
  int get quantity;

  /// Create a copy of AddCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCartItemDtoImplCopyWith<_$AddCartItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateCartItemDto _$UpdateCartItemDtoFromJson(Map<String, dynamic> json) {
  return _UpdateCartItemDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateCartItemDto {
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this UpdateCartItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCartItemDtoCopyWith<UpdateCartItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCartItemDtoCopyWith<$Res> {
  factory $UpdateCartItemDtoCopyWith(
    UpdateCartItemDto value,
    $Res Function(UpdateCartItemDto) then,
  ) = _$UpdateCartItemDtoCopyWithImpl<$Res, UpdateCartItemDto>;
  @useResult
  $Res call({int quantity});
}

/// @nodoc
class _$UpdateCartItemDtoCopyWithImpl<$Res, $Val extends UpdateCartItemDto>
    implements $UpdateCartItemDtoCopyWith<$Res> {
  _$UpdateCartItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quantity = null}) {
    return _then(
      _value.copyWith(
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateCartItemDtoImplCopyWith<$Res>
    implements $UpdateCartItemDtoCopyWith<$Res> {
  factory _$$UpdateCartItemDtoImplCopyWith(
    _$UpdateCartItemDtoImpl value,
    $Res Function(_$UpdateCartItemDtoImpl) then,
  ) = __$$UpdateCartItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int quantity});
}

/// @nodoc
class __$$UpdateCartItemDtoImplCopyWithImpl<$Res>
    extends _$UpdateCartItemDtoCopyWithImpl<$Res, _$UpdateCartItemDtoImpl>
    implements _$$UpdateCartItemDtoImplCopyWith<$Res> {
  __$$UpdateCartItemDtoImplCopyWithImpl(
    _$UpdateCartItemDtoImpl _value,
    $Res Function(_$UpdateCartItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quantity = null}) {
    return _then(
      _$UpdateCartItemDtoImpl(
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCartItemDtoImpl implements _UpdateCartItemDto {
  const _$UpdateCartItemDtoImpl({required this.quantity});

  factory _$UpdateCartItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCartItemDtoImplFromJson(json);

  @override
  final int quantity;

  @override
  String toString() {
    return 'UpdateCartItemDto(quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCartItemDtoImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity);

  /// Create a copy of UpdateCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCartItemDtoImplCopyWith<_$UpdateCartItemDtoImpl> get copyWith =>
      __$$UpdateCartItemDtoImplCopyWithImpl<_$UpdateCartItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCartItemDtoImplToJson(this);
  }
}

abstract class _UpdateCartItemDto implements UpdateCartItemDto {
  const factory _UpdateCartItemDto({required final int quantity}) =
      _$UpdateCartItemDtoImpl;

  factory _UpdateCartItemDto.fromJson(Map<String, dynamic> json) =
      _$UpdateCartItemDtoImpl.fromJson;

  @override
  int get quantity;

  /// Create a copy of UpdateCartItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCartItemDtoImplCopyWith<_$UpdateCartItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GuestCartLineDto _$GuestCartLineDtoFromJson(Map<String, dynamic> json) {
  return _GuestCartLineDto.fromJson(json);
}

/// @nodoc
mixin _$GuestCartLineDto {
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this GuestCartLineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuestCartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestCartLineDtoCopyWith<GuestCartLineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestCartLineDtoCopyWith<$Res> {
  factory $GuestCartLineDtoCopyWith(
    GuestCartLineDto value,
    $Res Function(GuestCartLineDto) then,
  ) = _$GuestCartLineDtoCopyWithImpl<$Res, GuestCartLineDto>;
  @useResult
  $Res call({String productId, int quantity});
}

/// @nodoc
class _$GuestCartLineDtoCopyWithImpl<$Res, $Val extends GuestCartLineDto>
    implements $GuestCartLineDtoCopyWith<$Res> {
  _$GuestCartLineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuestCartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? quantity = null}) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GuestCartLineDtoImplCopyWith<$Res>
    implements $GuestCartLineDtoCopyWith<$Res> {
  factory _$$GuestCartLineDtoImplCopyWith(
    _$GuestCartLineDtoImpl value,
    $Res Function(_$GuestCartLineDtoImpl) then,
  ) = __$$GuestCartLineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productId, int quantity});
}

/// @nodoc
class __$$GuestCartLineDtoImplCopyWithImpl<$Res>
    extends _$GuestCartLineDtoCopyWithImpl<$Res, _$GuestCartLineDtoImpl>
    implements _$$GuestCartLineDtoImplCopyWith<$Res> {
  __$$GuestCartLineDtoImplCopyWithImpl(
    _$GuestCartLineDtoImpl _value,
    $Res Function(_$GuestCartLineDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuestCartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? quantity = null}) {
    return _then(
      _$GuestCartLineDtoImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GuestCartLineDtoImpl implements _GuestCartLineDto {
  const _$GuestCartLineDtoImpl({
    required this.productId,
    required this.quantity,
  });

  factory _$GuestCartLineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuestCartLineDtoImplFromJson(json);

  @override
  final String productId;
  @override
  final int quantity;

  @override
  String toString() {
    return 'GuestCartLineDto(productId: $productId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestCartLineDtoImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, quantity);

  /// Create a copy of GuestCartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestCartLineDtoImplCopyWith<_$GuestCartLineDtoImpl> get copyWith =>
      __$$GuestCartLineDtoImplCopyWithImpl<_$GuestCartLineDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GuestCartLineDtoImplToJson(this);
  }
}

abstract class _GuestCartLineDto implements GuestCartLineDto {
  const factory _GuestCartLineDto({
    required final String productId,
    required final int quantity,
  }) = _$GuestCartLineDtoImpl;

  factory _GuestCartLineDto.fromJson(Map<String, dynamic> json) =
      _$GuestCartLineDtoImpl.fromJson;

  @override
  String get productId;
  @override
  int get quantity;

  /// Create a copy of GuestCartLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestCartLineDtoImplCopyWith<_$GuestCartLineDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreviewGuestCartDto _$PreviewGuestCartDtoFromJson(Map<String, dynamic> json) {
  return _PreviewGuestCartDto.fromJson(json);
}

/// @nodoc
mixin _$PreviewGuestCartDto {
  List<GuestCartLineDto> get items => throw _privateConstructorUsedError;

  /// Serializes this PreviewGuestCartDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreviewGuestCartDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreviewGuestCartDtoCopyWith<PreviewGuestCartDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreviewGuestCartDtoCopyWith<$Res> {
  factory $PreviewGuestCartDtoCopyWith(
    PreviewGuestCartDto value,
    $Res Function(PreviewGuestCartDto) then,
  ) = _$PreviewGuestCartDtoCopyWithImpl<$Res, PreviewGuestCartDto>;
  @useResult
  $Res call({List<GuestCartLineDto> items});
}

/// @nodoc
class _$PreviewGuestCartDtoCopyWithImpl<$Res, $Val extends PreviewGuestCartDto>
    implements $PreviewGuestCartDtoCopyWith<$Res> {
  _$PreviewGuestCartDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreviewGuestCartDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<GuestCartLineDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PreviewGuestCartDtoImplCopyWith<$Res>
    implements $PreviewGuestCartDtoCopyWith<$Res> {
  factory _$$PreviewGuestCartDtoImplCopyWith(
    _$PreviewGuestCartDtoImpl value,
    $Res Function(_$PreviewGuestCartDtoImpl) then,
  ) = __$$PreviewGuestCartDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GuestCartLineDto> items});
}

/// @nodoc
class __$$PreviewGuestCartDtoImplCopyWithImpl<$Res>
    extends _$PreviewGuestCartDtoCopyWithImpl<$Res, _$PreviewGuestCartDtoImpl>
    implements _$$PreviewGuestCartDtoImplCopyWith<$Res> {
  __$$PreviewGuestCartDtoImplCopyWithImpl(
    _$PreviewGuestCartDtoImpl _value,
    $Res Function(_$PreviewGuestCartDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreviewGuestCartDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$PreviewGuestCartDtoImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<GuestCartLineDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreviewGuestCartDtoImpl implements _PreviewGuestCartDto {
  const _$PreviewGuestCartDtoImpl({required final List<GuestCartLineDto> items})
    : _items = items;

  factory _$PreviewGuestCartDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreviewGuestCartDtoImplFromJson(json);

  final List<GuestCartLineDto> _items;
  @override
  List<GuestCartLineDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PreviewGuestCartDto(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreviewGuestCartDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of PreviewGuestCartDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreviewGuestCartDtoImplCopyWith<_$PreviewGuestCartDtoImpl> get copyWith =>
      __$$PreviewGuestCartDtoImplCopyWithImpl<_$PreviewGuestCartDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PreviewGuestCartDtoImplToJson(this);
  }
}

abstract class _PreviewGuestCartDto implements PreviewGuestCartDto {
  const factory _PreviewGuestCartDto({
    required final List<GuestCartLineDto> items,
  }) = _$PreviewGuestCartDtoImpl;

  factory _PreviewGuestCartDto.fromJson(Map<String, dynamic> json) =
      _$PreviewGuestCartDtoImpl.fromJson;

  @override
  List<GuestCartLineDto> get items;

  /// Create a copy of PreviewGuestCartDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreviewGuestCartDtoImplCopyWith<_$PreviewGuestCartDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
