// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderCustomerDto _$OrderCustomerDtoFromJson(Map<String, dynamic> json) {
  return _OrderCustomerDto.fromJson(json);
}

/// @nodoc
mixin _$OrderCustomerDto {
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this OrderCustomerDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCustomerDtoCopyWith<OrderCustomerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCustomerDtoCopyWith<$Res> {
  factory $OrderCustomerDtoCopyWith(
    OrderCustomerDto value,
    $Res Function(OrderCustomerDto) then,
  ) = _$OrderCustomerDtoCopyWithImpl<$Res, OrderCustomerDto>;
  @useResult
  $Res call({String fullName, String email, String? phone});
}

/// @nodoc
class _$OrderCustomerDtoCopyWithImpl<$Res, $Val extends OrderCustomerDto>
    implements $OrderCustomerDtoCopyWith<$Res> {
  _$OrderCustomerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? phone = freezed,
  }) {
    return _then(
      _value.copyWith(
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderCustomerDtoImplCopyWith<$Res>
    implements $OrderCustomerDtoCopyWith<$Res> {
  factory _$$OrderCustomerDtoImplCopyWith(
    _$OrderCustomerDtoImpl value,
    $Res Function(_$OrderCustomerDtoImpl) then,
  ) = __$$OrderCustomerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fullName, String email, String? phone});
}

/// @nodoc
class __$$OrderCustomerDtoImplCopyWithImpl<$Res>
    extends _$OrderCustomerDtoCopyWithImpl<$Res, _$OrderCustomerDtoImpl>
    implements _$$OrderCustomerDtoImplCopyWith<$Res> {
  __$$OrderCustomerDtoImplCopyWithImpl(
    _$OrderCustomerDtoImpl _value,
    $Res Function(_$OrderCustomerDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? phone = freezed,
  }) {
    return _then(
      _$OrderCustomerDtoImpl(
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderCustomerDtoImpl implements _OrderCustomerDto {
  const _$OrderCustomerDtoImpl({
    required this.fullName,
    required this.email,
    this.phone,
  });

  factory _$OrderCustomerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderCustomerDtoImplFromJson(json);

  @override
  final String fullName;
  @override
  final String email;
  @override
  final String? phone;

  @override
  String toString() {
    return 'OrderCustomerDto(fullName: $fullName, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCustomerDtoImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, email, phone);

  /// Create a copy of OrderCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCustomerDtoImplCopyWith<_$OrderCustomerDtoImpl> get copyWith =>
      __$$OrderCustomerDtoImplCopyWithImpl<_$OrderCustomerDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderCustomerDtoImplToJson(this);
  }
}

abstract class _OrderCustomerDto implements OrderCustomerDto {
  const factory _OrderCustomerDto({
    required final String fullName,
    required final String email,
    final String? phone,
  }) = _$OrderCustomerDtoImpl;

  factory _OrderCustomerDto.fromJson(Map<String, dynamic> json) =
      _$OrderCustomerDtoImpl.fromJson;

  @override
  String get fullName;
  @override
  String get email;
  @override
  String? get phone;

  /// Create a copy of OrderCustomerDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCustomerDtoImplCopyWith<_$OrderCustomerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemDto _$OrderItemDtoFromJson(Map<String, dynamic> json) {
  return _OrderItemDto.fromJson(json);
}

/// @nodoc
mixin _$OrderItemDto {
  String get productId => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get brandName => throw _privateConstructorUsedError;
  String get imagePublicId => throw _privateConstructorUsedError;
  MoneyDto get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  MoneyDto get lineTotal => throw _privateConstructorUsedError;

  /// Serializes this OrderItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemDtoCopyWith<OrderItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemDtoCopyWith<$Res> {
  factory $OrderItemDtoCopyWith(
    OrderItemDto value,
    $Res Function(OrderItemDto) then,
  ) = _$OrderItemDtoCopyWithImpl<$Res, OrderItemDto>;
  @useResult
  $Res call({
    String productId,
    String sku,
    String slug,
    String name,
    String brandName,
    String imagePublicId,
    MoneyDto unitPrice,
    int quantity,
    MoneyDto lineTotal,
  });

  $MoneyDtoCopyWith<$Res> get unitPrice;
  $MoneyDtoCopyWith<$Res> get lineTotal;
}

/// @nodoc
class _$OrderItemDtoCopyWithImpl<$Res, $Val extends OrderItemDto>
    implements $OrderItemDtoCopyWith<$Res> {
  _$OrderItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? slug = null,
    Object? name = null,
    Object? brandName = null,
    Object? imagePublicId = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? lineTotal = null,
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
            brandName: null == brandName
                ? _value.brandName
                : brandName // ignore: cast_nullable_to_non_nullable
                      as String,
            imagePublicId: null == imagePublicId
                ? _value.imagePublicId
                : imagePublicId // ignore: cast_nullable_to_non_nullable
                      as String,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            lineTotal: null == lineTotal
                ? _value.lineTotal
                : lineTotal // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get unitPrice {
    return $MoneyDtoCopyWith<$Res>(_value.unitPrice, (value) {
      return _then(_value.copyWith(unitPrice: value) as $Val);
    });
  }

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get lineTotal {
    return $MoneyDtoCopyWith<$Res>(_value.lineTotal, (value) {
      return _then(_value.copyWith(lineTotal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemDtoImplCopyWith<$Res>
    implements $OrderItemDtoCopyWith<$Res> {
  factory _$$OrderItemDtoImplCopyWith(
    _$OrderItemDtoImpl value,
    $Res Function(_$OrderItemDtoImpl) then,
  ) = __$$OrderItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String sku,
    String slug,
    String name,
    String brandName,
    String imagePublicId,
    MoneyDto unitPrice,
    int quantity,
    MoneyDto lineTotal,
  });

  @override
  $MoneyDtoCopyWith<$Res> get unitPrice;
  @override
  $MoneyDtoCopyWith<$Res> get lineTotal;
}

/// @nodoc
class __$$OrderItemDtoImplCopyWithImpl<$Res>
    extends _$OrderItemDtoCopyWithImpl<$Res, _$OrderItemDtoImpl>
    implements _$$OrderItemDtoImplCopyWith<$Res> {
  __$$OrderItemDtoImplCopyWithImpl(
    _$OrderItemDtoImpl _value,
    $Res Function(_$OrderItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? sku = null,
    Object? slug = null,
    Object? name = null,
    Object? brandName = null,
    Object? imagePublicId = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _$OrderItemDtoImpl(
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
        brandName: null == brandName
            ? _value.brandName
            : brandName // ignore: cast_nullable_to_non_nullable
                  as String,
        imagePublicId: null == imagePublicId
            ? _value.imagePublicId
            : imagePublicId // ignore: cast_nullable_to_non_nullable
                  as String,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        lineTotal: null == lineTotal
            ? _value.lineTotal
            : lineTotal // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemDtoImpl implements _OrderItemDto {
  const _$OrderItemDtoImpl({
    required this.productId,
    required this.sku,
    required this.slug,
    required this.name,
    required this.brandName,
    required this.imagePublicId,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
  });

  factory _$OrderItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemDtoImplFromJson(json);

  @override
  final String productId;
  @override
  final String sku;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String brandName;
  @override
  final String imagePublicId;
  @override
  final MoneyDto unitPrice;
  @override
  final int quantity;
  @override
  final MoneyDto lineTotal;

  @override
  String toString() {
    return 'OrderItemDto(productId: $productId, sku: $sku, slug: $slug, name: $name, brandName: $brandName, imagePublicId: $imagePublicId, unitPrice: $unitPrice, quantity: $quantity, lineTotal: $lineTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemDtoImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.imagePublicId, imagePublicId) ||
                other.imagePublicId == imagePublicId) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    sku,
    slug,
    name,
    brandName,
    imagePublicId,
    unitPrice,
    quantity,
    lineTotal,
  );

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemDtoImplCopyWith<_$OrderItemDtoImpl> get copyWith =>
      __$$OrderItemDtoImplCopyWithImpl<_$OrderItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemDtoImplToJson(this);
  }
}

abstract class _OrderItemDto implements OrderItemDto {
  const factory _OrderItemDto({
    required final String productId,
    required final String sku,
    required final String slug,
    required final String name,
    required final String brandName,
    required final String imagePublicId,
    required final MoneyDto unitPrice,
    required final int quantity,
    required final MoneyDto lineTotal,
  }) = _$OrderItemDtoImpl;

  factory _OrderItemDto.fromJson(Map<String, dynamic> json) =
      _$OrderItemDtoImpl.fromJson;

  @override
  String get productId;
  @override
  String get sku;
  @override
  String get slug;
  @override
  String get name;
  @override
  String get brandName;
  @override
  String get imagePublicId;
  @override
  MoneyDto get unitPrice;
  @override
  int get quantity;
  @override
  MoneyDto get lineTotal;

  /// Create a copy of OrderItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemDtoImplCopyWith<_$OrderItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderPaymentVerificationDto _$OrderPaymentVerificationDtoFromJson(
  Map<String, dynamic> json,
) {
  return _OrderPaymentVerificationDto.fromJson(json);
}

/// @nodoc
mixin _$OrderPaymentVerificationDto {
  String get transferSender => throw _privateConstructorUsedError;
  DateTime get submittedAt => throw _privateConstructorUsedError;
  DateTime? get decidedAt => throw _privateConstructorUsedError;
  String? get decisionNote => throw _privateConstructorUsedError;

  /// Serializes this OrderPaymentVerificationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPaymentVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentVerificationDtoCopyWith<OrderPaymentVerificationDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentVerificationDtoCopyWith<$Res> {
  factory $OrderPaymentVerificationDtoCopyWith(
    OrderPaymentVerificationDto value,
    $Res Function(OrderPaymentVerificationDto) then,
  ) =
      _$OrderPaymentVerificationDtoCopyWithImpl<
        $Res,
        OrderPaymentVerificationDto
      >;
  @useResult
  $Res call({
    String transferSender,
    DateTime submittedAt,
    DateTime? decidedAt,
    String? decisionNote,
  });
}

/// @nodoc
class _$OrderPaymentVerificationDtoCopyWithImpl<
  $Res,
  $Val extends OrderPaymentVerificationDto
>
    implements $OrderPaymentVerificationDtoCopyWith<$Res> {
  _$OrderPaymentVerificationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPaymentVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferSender = null,
    Object? submittedAt = null,
    Object? decidedAt = freezed,
    Object? decisionNote = freezed,
  }) {
    return _then(
      _value.copyWith(
            transferSender: null == transferSender
                ? _value.transferSender
                : transferSender // ignore: cast_nullable_to_non_nullable
                      as String,
            submittedAt: null == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            decidedAt: freezed == decidedAt
                ? _value.decidedAt
                : decidedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            decisionNote: freezed == decisionNote
                ? _value.decisionNote
                : decisionNote // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderPaymentVerificationDtoImplCopyWith<$Res>
    implements $OrderPaymentVerificationDtoCopyWith<$Res> {
  factory _$$OrderPaymentVerificationDtoImplCopyWith(
    _$OrderPaymentVerificationDtoImpl value,
    $Res Function(_$OrderPaymentVerificationDtoImpl) then,
  ) = __$$OrderPaymentVerificationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transferSender,
    DateTime submittedAt,
    DateTime? decidedAt,
    String? decisionNote,
  });
}

/// @nodoc
class __$$OrderPaymentVerificationDtoImplCopyWithImpl<$Res>
    extends
        _$OrderPaymentVerificationDtoCopyWithImpl<
          $Res,
          _$OrderPaymentVerificationDtoImpl
        >
    implements _$$OrderPaymentVerificationDtoImplCopyWith<$Res> {
  __$$OrderPaymentVerificationDtoImplCopyWithImpl(
    _$OrderPaymentVerificationDtoImpl _value,
    $Res Function(_$OrderPaymentVerificationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderPaymentVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferSender = null,
    Object? submittedAt = null,
    Object? decidedAt = freezed,
    Object? decisionNote = freezed,
  }) {
    return _then(
      _$OrderPaymentVerificationDtoImpl(
        transferSender: null == transferSender
            ? _value.transferSender
            : transferSender // ignore: cast_nullable_to_non_nullable
                  as String,
        submittedAt: null == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        decidedAt: freezed == decidedAt
            ? _value.decidedAt
            : decidedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        decisionNote: freezed == decisionNote
            ? _value.decisionNote
            : decisionNote // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderPaymentVerificationDtoImpl
    implements _OrderPaymentVerificationDto {
  const _$OrderPaymentVerificationDtoImpl({
    required this.transferSender,
    required this.submittedAt,
    this.decidedAt,
    this.decisionNote,
  });

  factory _$OrderPaymentVerificationDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$OrderPaymentVerificationDtoImplFromJson(json);

  @override
  final String transferSender;
  @override
  final DateTime submittedAt;
  @override
  final DateTime? decidedAt;
  @override
  final String? decisionNote;

  @override
  String toString() {
    return 'OrderPaymentVerificationDto(transferSender: $transferSender, submittedAt: $submittedAt, decidedAt: $decidedAt, decisionNote: $decisionNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentVerificationDtoImpl &&
            (identical(other.transferSender, transferSender) ||
                other.transferSender == transferSender) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.decidedAt, decidedAt) ||
                other.decidedAt == decidedAt) &&
            (identical(other.decisionNote, decisionNote) ||
                other.decisionNote == decisionNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    transferSender,
    submittedAt,
    decidedAt,
    decisionNote,
  );

  /// Create a copy of OrderPaymentVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentVerificationDtoImplCopyWith<_$OrderPaymentVerificationDtoImpl>
  get copyWith =>
      __$$OrderPaymentVerificationDtoImplCopyWithImpl<
        _$OrderPaymentVerificationDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPaymentVerificationDtoImplToJson(this);
  }
}

abstract class _OrderPaymentVerificationDto
    implements OrderPaymentVerificationDto {
  const factory _OrderPaymentVerificationDto({
    required final String transferSender,
    required final DateTime submittedAt,
    final DateTime? decidedAt,
    final String? decisionNote,
  }) = _$OrderPaymentVerificationDtoImpl;

  factory _OrderPaymentVerificationDto.fromJson(Map<String, dynamic> json) =
      _$OrderPaymentVerificationDtoImpl.fromJson;

  @override
  String get transferSender;
  @override
  DateTime get submittedAt;
  @override
  DateTime? get decidedAt;
  @override
  String? get decisionNote;

  /// Create a copy of OrderPaymentVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentVerificationDtoImplCopyWith<_$OrderPaymentVerificationDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderPaymentDto _$OrderPaymentDtoFromJson(Map<String, dynamic> json) {
  return _OrderPaymentDto.fromJson(json);
}

/// @nodoc
mixin _$OrderPaymentDto {
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  PaymentMethod get method => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: PaymentStatus.unknown)
  PaymentStatus get status => throw _privateConstructorUsedError;
  DateTime? get collectedAt => throw _privateConstructorUsedError;
  OrderPaymentVerificationDto? get verification =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderPaymentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentDtoCopyWith<OrderPaymentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentDtoCopyWith<$Res> {
  factory $OrderPaymentDtoCopyWith(
    OrderPaymentDto value,
    $Res Function(OrderPaymentDto) then,
  ) = _$OrderPaymentDtoCopyWithImpl<$Res, OrderPaymentDto>;
  @useResult
  $Res call({
    @JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod method,
    @JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus status,
    DateTime? collectedAt,
    OrderPaymentVerificationDto? verification,
  });

  $OrderPaymentVerificationDtoCopyWith<$Res>? get verification;
}

/// @nodoc
class _$OrderPaymentDtoCopyWithImpl<$Res, $Val extends OrderPaymentDto>
    implements $OrderPaymentDtoCopyWith<$Res> {
  _$OrderPaymentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? status = null,
    Object? collectedAt = freezed,
    Object? verification = freezed,
  }) {
    return _then(
      _value.copyWith(
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus,
            collectedAt: freezed == collectedAt
                ? _value.collectedAt
                : collectedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            verification: freezed == verification
                ? _value.verification
                : verification // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentVerificationDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPaymentVerificationDtoCopyWith<$Res>? get verification {
    if (_value.verification == null) {
      return null;
    }

    return $OrderPaymentVerificationDtoCopyWith<$Res>(_value.verification!, (
      value,
    ) {
      return _then(_value.copyWith(verification: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderPaymentDtoImplCopyWith<$Res>
    implements $OrderPaymentDtoCopyWith<$Res> {
  factory _$$OrderPaymentDtoImplCopyWith(
    _$OrderPaymentDtoImpl value,
    $Res Function(_$OrderPaymentDtoImpl) then,
  ) = __$$OrderPaymentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod method,
    @JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus status,
    DateTime? collectedAt,
    OrderPaymentVerificationDto? verification,
  });

  @override
  $OrderPaymentVerificationDtoCopyWith<$Res>? get verification;
}

/// @nodoc
class __$$OrderPaymentDtoImplCopyWithImpl<$Res>
    extends _$OrderPaymentDtoCopyWithImpl<$Res, _$OrderPaymentDtoImpl>
    implements _$$OrderPaymentDtoImplCopyWith<$Res> {
  __$$OrderPaymentDtoImplCopyWithImpl(
    _$OrderPaymentDtoImpl _value,
    $Res Function(_$OrderPaymentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? status = null,
    Object? collectedAt = freezed,
    Object? verification = freezed,
  }) {
    return _then(
      _$OrderPaymentDtoImpl(
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus,
        collectedAt: freezed == collectedAt
            ? _value.collectedAt
            : collectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        verification: freezed == verification
            ? _value.verification
            : verification // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentVerificationDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderPaymentDtoImpl implements _OrderPaymentDto {
  const _$OrderPaymentDtoImpl({
    @JsonKey(unknownEnumValue: PaymentMethod.unknown) required this.method,
    @JsonKey(unknownEnumValue: PaymentStatus.unknown) required this.status,
    this.collectedAt,
    this.verification,
  });

  factory _$OrderPaymentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPaymentDtoImplFromJson(json);

  @override
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  final PaymentMethod method;
  @override
  @JsonKey(unknownEnumValue: PaymentStatus.unknown)
  final PaymentStatus status;
  @override
  final DateTime? collectedAt;
  @override
  final OrderPaymentVerificationDto? verification;

  @override
  String toString() {
    return 'OrderPaymentDto(method: $method, status: $status, collectedAt: $collectedAt, verification: $verification)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentDtoImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.collectedAt, collectedAt) ||
                other.collectedAt == collectedAt) &&
            (identical(other.verification, verification) ||
                other.verification == verification));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, method, status, collectedAt, verification);

  /// Create a copy of OrderPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentDtoImplCopyWith<_$OrderPaymentDtoImpl> get copyWith =>
      __$$OrderPaymentDtoImplCopyWithImpl<_$OrderPaymentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPaymentDtoImplToJson(this);
  }
}

abstract class _OrderPaymentDto implements OrderPaymentDto {
  const factory _OrderPaymentDto({
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    required final PaymentMethod method,
    @JsonKey(unknownEnumValue: PaymentStatus.unknown)
    required final PaymentStatus status,
    final DateTime? collectedAt,
    final OrderPaymentVerificationDto? verification,
  }) = _$OrderPaymentDtoImpl;

  factory _OrderPaymentDto.fromJson(Map<String, dynamic> json) =
      _$OrderPaymentDtoImpl.fromJson;

  @override
  @JsonKey(unknownEnumValue: PaymentMethod.unknown)
  PaymentMethod get method;
  @override
  @JsonKey(unknownEnumValue: PaymentStatus.unknown)
  PaymentStatus get status;
  @override
  DateTime? get collectedAt;
  @override
  OrderPaymentVerificationDto? get verification;

  /// Create a copy of OrderPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentDtoImplCopyWith<_$OrderPaymentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderCancellationDto _$OrderCancellationDtoFromJson(Map<String, dynamic> json) {
  return _OrderCancellationDto.fromJson(json);
}

/// @nodoc
mixin _$OrderCancellationDto {
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get by => throw _privateConstructorUsedError;
  DateTime get at => throw _privateConstructorUsedError;

  /// Serializes this OrderCancellationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderCancellationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCancellationDtoCopyWith<OrderCancellationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCancellationDtoCopyWith<$Res> {
  factory $OrderCancellationDtoCopyWith(
    OrderCancellationDto value,
    $Res Function(OrderCancellationDto) then,
  ) = _$OrderCancellationDtoCopyWithImpl<$Res, OrderCancellationDto>;
  @useResult
  $Res call({
    String reason,
    @JsonKey(unknownEnumValue: Role.unknown) Role by,
    DateTime at,
  });
}

/// @nodoc
class _$OrderCancellationDtoCopyWithImpl<
  $Res,
  $Val extends OrderCancellationDto
>
    implements $OrderCancellationDtoCopyWith<$Res> {
  _$OrderCancellationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCancellationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null, Object? by = null, Object? at = null}) {
    return _then(
      _value.copyWith(
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            by: null == by
                ? _value.by
                : by // ignore: cast_nullable_to_non_nullable
                      as Role,
            at: null == at
                ? _value.at
                : at // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderCancellationDtoImplCopyWith<$Res>
    implements $OrderCancellationDtoCopyWith<$Res> {
  factory _$$OrderCancellationDtoImplCopyWith(
    _$OrderCancellationDtoImpl value,
    $Res Function(_$OrderCancellationDtoImpl) then,
  ) = __$$OrderCancellationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String reason,
    @JsonKey(unknownEnumValue: Role.unknown) Role by,
    DateTime at,
  });
}

/// @nodoc
class __$$OrderCancellationDtoImplCopyWithImpl<$Res>
    extends _$OrderCancellationDtoCopyWithImpl<$Res, _$OrderCancellationDtoImpl>
    implements _$$OrderCancellationDtoImplCopyWith<$Res> {
  __$$OrderCancellationDtoImplCopyWithImpl(
    _$OrderCancellationDtoImpl _value,
    $Res Function(_$OrderCancellationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCancellationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null, Object? by = null, Object? at = null}) {
    return _then(
      _$OrderCancellationDtoImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        by: null == by
            ? _value.by
            : by // ignore: cast_nullable_to_non_nullable
                  as Role,
        at: null == at
            ? _value.at
            : at // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderCancellationDtoImpl implements _OrderCancellationDto {
  const _$OrderCancellationDtoImpl({
    required this.reason,
    @JsonKey(unknownEnumValue: Role.unknown) required this.by,
    required this.at,
  });

  factory _$OrderCancellationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderCancellationDtoImplFromJson(json);

  @override
  final String reason;
  @override
  @JsonKey(unknownEnumValue: Role.unknown)
  final Role by;
  @override
  final DateTime at;

  @override
  String toString() {
    return 'OrderCancellationDto(reason: $reason, by: $by, at: $at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCancellationDtoImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.by, by) || other.by == by) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reason, by, at);

  /// Create a copy of OrderCancellationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCancellationDtoImplCopyWith<_$OrderCancellationDtoImpl>
  get copyWith =>
      __$$OrderCancellationDtoImplCopyWithImpl<_$OrderCancellationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderCancellationDtoImplToJson(this);
  }
}

abstract class _OrderCancellationDto implements OrderCancellationDto {
  const factory _OrderCancellationDto({
    required final String reason,
    @JsonKey(unknownEnumValue: Role.unknown) required final Role by,
    required final DateTime at,
  }) = _$OrderCancellationDtoImpl;

  factory _OrderCancellationDto.fromJson(Map<String, dynamic> json) =
      _$OrderCancellationDtoImpl.fromJson;

  @override
  String get reason;
  @override
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get by;
  @override
  DateTime get at;

  /// Create a copy of OrderCancellationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCancellationDtoImplCopyWith<_$OrderCancellationDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderShipmentDto _$OrderShipmentDtoFromJson(Map<String, dynamic> json) {
  return _OrderShipmentDto.fromJson(json);
}

/// @nodoc
mixin _$OrderShipmentDto {
  String get carrier => throw _privateConstructorUsedError;
  String get trackingNumber => throw _privateConstructorUsedError;
  DateTime get shippedAt => throw _privateConstructorUsedError;
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  int get deliveryAttempts => throw _privateConstructorUsedError;

  /// Serializes this OrderShipmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderShipmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderShipmentDtoCopyWith<OrderShipmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderShipmentDtoCopyWith<$Res> {
  factory $OrderShipmentDtoCopyWith(
    OrderShipmentDto value,
    $Res Function(OrderShipmentDto) then,
  ) = _$OrderShipmentDtoCopyWithImpl<$Res, OrderShipmentDto>;
  @useResult
  $Res call({
    String carrier,
    String trackingNumber,
    DateTime shippedAt,
    DateTime? deliveredAt,
    int deliveryAttempts,
  });
}

/// @nodoc
class _$OrderShipmentDtoCopyWithImpl<$Res, $Val extends OrderShipmentDto>
    implements $OrderShipmentDtoCopyWith<$Res> {
  _$OrderShipmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderShipmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carrier = null,
    Object? trackingNumber = null,
    Object? shippedAt = null,
    Object? deliveredAt = freezed,
    Object? deliveryAttempts = null,
  }) {
    return _then(
      _value.copyWith(
            carrier: null == carrier
                ? _value.carrier
                : carrier // ignore: cast_nullable_to_non_nullable
                      as String,
            trackingNumber: null == trackingNumber
                ? _value.trackingNumber
                : trackingNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            shippedAt: null == shippedAt
                ? _value.shippedAt
                : shippedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deliveredAt: freezed == deliveredAt
                ? _value.deliveredAt
                : deliveredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveryAttempts: null == deliveryAttempts
                ? _value.deliveryAttempts
                : deliveryAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderShipmentDtoImplCopyWith<$Res>
    implements $OrderShipmentDtoCopyWith<$Res> {
  factory _$$OrderShipmentDtoImplCopyWith(
    _$OrderShipmentDtoImpl value,
    $Res Function(_$OrderShipmentDtoImpl) then,
  ) = __$$OrderShipmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String carrier,
    String trackingNumber,
    DateTime shippedAt,
    DateTime? deliveredAt,
    int deliveryAttempts,
  });
}

/// @nodoc
class __$$OrderShipmentDtoImplCopyWithImpl<$Res>
    extends _$OrderShipmentDtoCopyWithImpl<$Res, _$OrderShipmentDtoImpl>
    implements _$$OrderShipmentDtoImplCopyWith<$Res> {
  __$$OrderShipmentDtoImplCopyWithImpl(
    _$OrderShipmentDtoImpl _value,
    $Res Function(_$OrderShipmentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderShipmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carrier = null,
    Object? trackingNumber = null,
    Object? shippedAt = null,
    Object? deliveredAt = freezed,
    Object? deliveryAttempts = null,
  }) {
    return _then(
      _$OrderShipmentDtoImpl(
        carrier: null == carrier
            ? _value.carrier
            : carrier // ignore: cast_nullable_to_non_nullable
                  as String,
        trackingNumber: null == trackingNumber
            ? _value.trackingNumber
            : trackingNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        shippedAt: null == shippedAt
            ? _value.shippedAt
            : shippedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deliveredAt: freezed == deliveredAt
            ? _value.deliveredAt
            : deliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveryAttempts: null == deliveryAttempts
            ? _value.deliveryAttempts
            : deliveryAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderShipmentDtoImpl implements _OrderShipmentDto {
  const _$OrderShipmentDtoImpl({
    required this.carrier,
    required this.trackingNumber,
    required this.shippedAt,
    this.deliveredAt,
    required this.deliveryAttempts,
  });

  factory _$OrderShipmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderShipmentDtoImplFromJson(json);

  @override
  final String carrier;
  @override
  final String trackingNumber;
  @override
  final DateTime shippedAt;
  @override
  final DateTime? deliveredAt;
  @override
  final int deliveryAttempts;

  @override
  String toString() {
    return 'OrderShipmentDto(carrier: $carrier, trackingNumber: $trackingNumber, shippedAt: $shippedAt, deliveredAt: $deliveredAt, deliveryAttempts: $deliveryAttempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderShipmentDtoImpl &&
            (identical(other.carrier, carrier) || other.carrier == carrier) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.deliveryAttempts, deliveryAttempts) ||
                other.deliveryAttempts == deliveryAttempts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    carrier,
    trackingNumber,
    shippedAt,
    deliveredAt,
    deliveryAttempts,
  );

  /// Create a copy of OrderShipmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderShipmentDtoImplCopyWith<_$OrderShipmentDtoImpl> get copyWith =>
      __$$OrderShipmentDtoImplCopyWithImpl<_$OrderShipmentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderShipmentDtoImplToJson(this);
  }
}

abstract class _OrderShipmentDto implements OrderShipmentDto {
  const factory _OrderShipmentDto({
    required final String carrier,
    required final String trackingNumber,
    required final DateTime shippedAt,
    final DateTime? deliveredAt,
    required final int deliveryAttempts,
  }) = _$OrderShipmentDtoImpl;

  factory _OrderShipmentDto.fromJson(Map<String, dynamic> json) =
      _$OrderShipmentDtoImpl.fromJson;

  @override
  String get carrier;
  @override
  String get trackingNumber;
  @override
  DateTime get shippedAt;
  @override
  DateTime? get deliveredAt;
  @override
  int get deliveryAttempts;

  /// Create a copy of OrderShipmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderShipmentDtoImplCopyWith<_$OrderShipmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderShippingAddressDto _$OrderShippingAddressDtoFromJson(
  Map<String, dynamic> json,
) {
  return _OrderShippingAddressDto.fromJson(json);
}

/// @nodoc
mixin _$OrderShippingAddressDto {
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get street => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get governorate => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;

  /// Serializes this OrderShippingAddressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderShippingAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderShippingAddressDtoCopyWith<OrderShippingAddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderShippingAddressDtoCopyWith<$Res> {
  factory $OrderShippingAddressDtoCopyWith(
    OrderShippingAddressDto value,
    $Res Function(OrderShippingAddressDto) then,
  ) = _$OrderShippingAddressDtoCopyWithImpl<$Res, OrderShippingAddressDto>;
  @useResult
  $Res call({
    String fullName,
    String phone,
    String street,
    String city,
    String governorate,
    String postalCode,
  });
}

/// @nodoc
class _$OrderShippingAddressDtoCopyWithImpl<
  $Res,
  $Val extends OrderShippingAddressDto
>
    implements $OrderShippingAddressDtoCopyWith<$Res> {
  _$OrderShippingAddressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderShippingAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = null,
  }) {
    return _then(
      _value.copyWith(
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            street: null == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            governorate: null == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String,
            postalCode: null == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderShippingAddressDtoImplCopyWith<$Res>
    implements $OrderShippingAddressDtoCopyWith<$Res> {
  factory _$$OrderShippingAddressDtoImplCopyWith(
    _$OrderShippingAddressDtoImpl value,
    $Res Function(_$OrderShippingAddressDtoImpl) then,
  ) = __$$OrderShippingAddressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String fullName,
    String phone,
    String street,
    String city,
    String governorate,
    String postalCode,
  });
}

/// @nodoc
class __$$OrderShippingAddressDtoImplCopyWithImpl<$Res>
    extends
        _$OrderShippingAddressDtoCopyWithImpl<
          $Res,
          _$OrderShippingAddressDtoImpl
        >
    implements _$$OrderShippingAddressDtoImplCopyWith<$Res> {
  __$$OrderShippingAddressDtoImplCopyWithImpl(
    _$OrderShippingAddressDtoImpl _value,
    $Res Function(_$OrderShippingAddressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderShippingAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = null,
  }) {
    return _then(
      _$OrderShippingAddressDtoImpl(
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        street: null == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        governorate: null == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String,
        postalCode: null == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderShippingAddressDtoImpl implements _OrderShippingAddressDto {
  const _$OrderShippingAddressDtoImpl({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.governorate,
    required this.postalCode,
  });

  factory _$OrderShippingAddressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderShippingAddressDtoImplFromJson(json);

  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String street;
  @override
  final String city;
  @override
  final String governorate;
  @override
  final String postalCode;

  @override
  String toString() {
    return 'OrderShippingAddressDto(fullName: $fullName, phone: $phone, street: $street, city: $city, governorate: $governorate, postalCode: $postalCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderShippingAddressDtoImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    phone,
    street,
    city,
    governorate,
    postalCode,
  );

  /// Create a copy of OrderShippingAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderShippingAddressDtoImplCopyWith<_$OrderShippingAddressDtoImpl>
  get copyWith =>
      __$$OrderShippingAddressDtoImplCopyWithImpl<
        _$OrderShippingAddressDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderShippingAddressDtoImplToJson(this);
  }
}

abstract class _OrderShippingAddressDto implements OrderShippingAddressDto {
  const factory _OrderShippingAddressDto({
    required final String fullName,
    required final String phone,
    required final String street,
    required final String city,
    required final String governorate,
    required final String postalCode,
  }) = _$OrderShippingAddressDtoImpl;

  factory _OrderShippingAddressDto.fromJson(Map<String, dynamic> json) =
      _$OrderShippingAddressDtoImpl.fromJson;

  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get street;
  @override
  String get city;
  @override
  String get governorate;
  @override
  String get postalCode;

  /// Create a copy of OrderShippingAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderShippingAddressDtoImplCopyWith<_$OrderShippingAddressDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderHistoryActorDto _$OrderHistoryActorDtoFromJson(Map<String, dynamic> json) {
  return _OrderHistoryActorDto.fromJson(json);
}

/// @nodoc
mixin _$OrderHistoryActorDto {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get role => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this OrderHistoryActorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderHistoryActorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderHistoryActorDtoCopyWith<OrderHistoryActorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderHistoryActorDtoCopyWith<$Res> {
  factory $OrderHistoryActorDtoCopyWith(
    OrderHistoryActorDto value,
    $Res Function(OrderHistoryActorDto) then,
  ) = _$OrderHistoryActorDtoCopyWithImpl<$Res, OrderHistoryActorDto>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(unknownEnumValue: Role.unknown) Role role,
    String name,
  });
}

/// @nodoc
class _$OrderHistoryActorDtoCopyWithImpl<
  $Res,
  $Val extends OrderHistoryActorDto
>
    implements $OrderHistoryActorDtoCopyWith<$Res> {
  _$OrderHistoryActorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderHistoryActorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? role = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as Role,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderHistoryActorDtoImplCopyWith<$Res>
    implements $OrderHistoryActorDtoCopyWith<$Res> {
  factory _$$OrderHistoryActorDtoImplCopyWith(
    _$OrderHistoryActorDtoImpl value,
    $Res Function(_$OrderHistoryActorDtoImpl) then,
  ) = __$$OrderHistoryActorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(unknownEnumValue: Role.unknown) Role role,
    String name,
  });
}

/// @nodoc
class __$$OrderHistoryActorDtoImplCopyWithImpl<$Res>
    extends _$OrderHistoryActorDtoCopyWithImpl<$Res, _$OrderHistoryActorDtoImpl>
    implements _$$OrderHistoryActorDtoImplCopyWith<$Res> {
  __$$OrderHistoryActorDtoImplCopyWithImpl(
    _$OrderHistoryActorDtoImpl _value,
    $Res Function(_$OrderHistoryActorDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderHistoryActorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? role = null, Object? name = null}) {
    return _then(
      _$OrderHistoryActorDtoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as Role,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderHistoryActorDtoImpl implements _OrderHistoryActorDto {
  const _$OrderHistoryActorDtoImpl({
    this.id,
    @JsonKey(unknownEnumValue: Role.unknown) required this.role,
    required this.name,
  });

  factory _$OrderHistoryActorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderHistoryActorDtoImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(unknownEnumValue: Role.unknown)
  final Role role;
  @override
  final String name;

  @override
  String toString() {
    return 'OrderHistoryActorDto(id: $id, role: $role, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderHistoryActorDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, role, name);

  /// Create a copy of OrderHistoryActorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderHistoryActorDtoImplCopyWith<_$OrderHistoryActorDtoImpl>
  get copyWith =>
      __$$OrderHistoryActorDtoImplCopyWithImpl<_$OrderHistoryActorDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderHistoryActorDtoImplToJson(this);
  }
}

abstract class _OrderHistoryActorDto implements OrderHistoryActorDto {
  const factory _OrderHistoryActorDto({
    final String? id,
    @JsonKey(unknownEnumValue: Role.unknown) required final Role role,
    required final String name,
  }) = _$OrderHistoryActorDtoImpl;

  factory _OrderHistoryActorDto.fromJson(Map<String, dynamic> json) =
      _$OrderHistoryActorDtoImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get role;
  @override
  String get name;

  /// Create a copy of OrderHistoryActorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderHistoryActorDtoImplCopyWith<_$OrderHistoryActorDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderStatusHistoryEntryDto _$OrderStatusHistoryEntryDtoFromJson(
  Map<String, dynamic> json,
) {
  return _OrderStatusHistoryEntryDto.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusHistoryEntryDto {
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get from => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get to => throw _privateConstructorUsedError;
  OrderHistoryActorDto get actor => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  DateTime get at => throw _privateConstructorUsedError;

  /// Serializes this OrderStatusHistoryEntryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusHistoryEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusHistoryEntryDtoCopyWith<OrderStatusHistoryEntryDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusHistoryEntryDtoCopyWith<$Res> {
  factory $OrderStatusHistoryEntryDtoCopyWith(
    OrderStatusHistoryEntryDto value,
    $Res Function(OrderStatusHistoryEntryDto) then,
  ) =
      _$OrderStatusHistoryEntryDtoCopyWithImpl<
        $Res,
        OrderStatusHistoryEntryDto
      >;
  @useResult
  $Res call({
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus from,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus to,
    OrderHistoryActorDto actor,
    String note,
    DateTime at,
  });

  $OrderHistoryActorDtoCopyWith<$Res> get actor;
}

/// @nodoc
class _$OrderStatusHistoryEntryDtoCopyWithImpl<
  $Res,
  $Val extends OrderStatusHistoryEntryDto
>
    implements $OrderStatusHistoryEntryDtoCopyWith<$Res> {
  _$OrderStatusHistoryEntryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusHistoryEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? actor = null,
    Object? note = null,
    Object? at = null,
  }) {
    return _then(
      _value.copyWith(
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            actor: null == actor
                ? _value.actor
                : actor // ignore: cast_nullable_to_non_nullable
                      as OrderHistoryActorDto,
            note: null == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String,
            at: null == at
                ? _value.at
                : at // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderStatusHistoryEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderHistoryActorDtoCopyWith<$Res> get actor {
    return $OrderHistoryActorDtoCopyWith<$Res>(_value.actor, (value) {
      return _then(_value.copyWith(actor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderStatusHistoryEntryDtoImplCopyWith<$Res>
    implements $OrderStatusHistoryEntryDtoCopyWith<$Res> {
  factory _$$OrderStatusHistoryEntryDtoImplCopyWith(
    _$OrderStatusHistoryEntryDtoImpl value,
    $Res Function(_$OrderStatusHistoryEntryDtoImpl) then,
  ) = __$$OrderStatusHistoryEntryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus from,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus to,
    OrderHistoryActorDto actor,
    String note,
    DateTime at,
  });

  @override
  $OrderHistoryActorDtoCopyWith<$Res> get actor;
}

/// @nodoc
class __$$OrderStatusHistoryEntryDtoImplCopyWithImpl<$Res>
    extends
        _$OrderStatusHistoryEntryDtoCopyWithImpl<
          $Res,
          _$OrderStatusHistoryEntryDtoImpl
        >
    implements _$$OrderStatusHistoryEntryDtoImplCopyWith<$Res> {
  __$$OrderStatusHistoryEntryDtoImplCopyWithImpl(
    _$OrderStatusHistoryEntryDtoImpl _value,
    $Res Function(_$OrderStatusHistoryEntryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderStatusHistoryEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? actor = null,
    Object? note = null,
    Object? at = null,
  }) {
    return _then(
      _$OrderStatusHistoryEntryDtoImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        actor: null == actor
            ? _value.actor
            : actor // ignore: cast_nullable_to_non_nullable
                  as OrderHistoryActorDto,
        note: null == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
        at: null == at
            ? _value.at
            : at // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusHistoryEntryDtoImpl implements _OrderStatusHistoryEntryDto {
  const _$OrderStatusHistoryEntryDtoImpl({
    @JsonKey(unknownEnumValue: OrderStatus.unknown) required this.from,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) required this.to,
    required this.actor,
    required this.note,
    required this.at,
  });

  factory _$OrderStatusHistoryEntryDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$OrderStatusHistoryEntryDtoImplFromJson(json);

  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  final OrderStatus from;
  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  final OrderStatus to;
  @override
  final OrderHistoryActorDto actor;
  @override
  final String note;
  @override
  final DateTime at;

  @override
  String toString() {
    return 'OrderStatusHistoryEntryDto(from: $from, to: $to, actor: $actor, note: $note, at: $at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusHistoryEntryDtoImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, from, to, actor, note, at);

  /// Create a copy of OrderStatusHistoryEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusHistoryEntryDtoImplCopyWith<_$OrderStatusHistoryEntryDtoImpl>
  get copyWith =>
      __$$OrderStatusHistoryEntryDtoImplCopyWithImpl<
        _$OrderStatusHistoryEntryDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusHistoryEntryDtoImplToJson(this);
  }
}

abstract class _OrderStatusHistoryEntryDto
    implements OrderStatusHistoryEntryDto {
  const factory _OrderStatusHistoryEntryDto({
    @JsonKey(unknownEnumValue: OrderStatus.unknown)
    required final OrderStatus from,
    @JsonKey(unknownEnumValue: OrderStatus.unknown)
    required final OrderStatus to,
    required final OrderHistoryActorDto actor,
    required final String note,
    required final DateTime at,
  }) = _$OrderStatusHistoryEntryDtoImpl;

  factory _OrderStatusHistoryEntryDto.fromJson(Map<String, dynamic> json) =
      _$OrderStatusHistoryEntryDtoImpl.fromJson;

  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get from;
  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get to;
  @override
  OrderHistoryActorDto get actor;
  @override
  String get note;
  @override
  DateTime get at;

  /// Create a copy of OrderStatusHistoryEntryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusHistoryEntryDtoImplCopyWith<_$OrderStatusHistoryEntryDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) {
  return _OrderDto.fromJson(json);
}

/// @nodoc
mixin _$OrderDto {
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get status => throw _privateConstructorUsedError;
  OrderCustomerDto get customer => throw _privateConstructorUsedError;
  List<OrderItemDto> get items => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PricingBreakdownDto get pricing => throw _privateConstructorUsedError;
  OrderPaymentDto? get payment => throw _privateConstructorUsedError;
  OrderShippingAddressDto get shippingAddress =>
      throw _privateConstructorUsedError;
  String get customerNote => throw _privateConstructorUsedError;
  OrderCancellationDto? get cancellation => throw _privateConstructorUsedError;
  OrderShipmentDto? get shipment => throw _privateConstructorUsedError;
  DateTime get placedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDtoCopyWith<OrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDtoCopyWith<$Res> {
  factory $OrderDtoCopyWith(OrderDto value, $Res Function(OrderDto) then) =
      _$OrderDtoCopyWithImpl<$Res, OrderDto>;
  @useResult
  $Res call({
    String id,
    String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus status,
    OrderCustomerDto customer,
    List<OrderItemDto> items,
    String currency,
    PricingBreakdownDto pricing,
    OrderPaymentDto? payment,
    OrderShippingAddressDto shippingAddress,
    String customerNote,
    OrderCancellationDto? cancellation,
    OrderShipmentDto? shipment,
    DateTime placedAt,
  });

  $OrderCustomerDtoCopyWith<$Res> get customer;
  $PricingBreakdownDtoCopyWith<$Res> get pricing;
  $OrderPaymentDtoCopyWith<$Res>? get payment;
  $OrderShippingAddressDtoCopyWith<$Res> get shippingAddress;
  $OrderCancellationDtoCopyWith<$Res>? get cancellation;
  $OrderShipmentDtoCopyWith<$Res>? get shipment;
}

/// @nodoc
class _$OrderDtoCopyWithImpl<$Res, $Val extends OrderDto>
    implements $OrderDtoCopyWith<$Res> {
  _$OrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? customer = null,
    Object? items = null,
    Object? currency = null,
    Object? pricing = null,
    Object? payment = freezed,
    Object? shippingAddress = null,
    Object? customerNote = null,
    Object? cancellation = freezed,
    Object? shipment = freezed,
    Object? placedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            customer: null == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as OrderCustomerDto,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItemDto>,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            pricing: null == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as PricingBreakdownDto,
            payment: freezed == payment
                ? _value.payment
                : payment // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentDto?,
            shippingAddress: null == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                      as OrderShippingAddressDto,
            customerNote: null == customerNote
                ? _value.customerNote
                : customerNote // ignore: cast_nullable_to_non_nullable
                      as String,
            cancellation: freezed == cancellation
                ? _value.cancellation
                : cancellation // ignore: cast_nullable_to_non_nullable
                      as OrderCancellationDto?,
            shipment: freezed == shipment
                ? _value.shipment
                : shipment // ignore: cast_nullable_to_non_nullable
                      as OrderShipmentDto?,
            placedAt: null == placedAt
                ? _value.placedAt
                : placedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCustomerDtoCopyWith<$Res> get customer {
    return $OrderCustomerDtoCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PricingBreakdownDtoCopyWith<$Res> get pricing {
    return $PricingBreakdownDtoCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPaymentDtoCopyWith<$Res>? get payment {
    if (_value.payment == null) {
      return null;
    }

    return $OrderPaymentDtoCopyWith<$Res>(_value.payment!, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderShippingAddressDtoCopyWith<$Res> get shippingAddress {
    return $OrderShippingAddressDtoCopyWith<$Res>(_value.shippingAddress, (
      value,
    ) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCancellationDtoCopyWith<$Res>? get cancellation {
    if (_value.cancellation == null) {
      return null;
    }

    return $OrderCancellationDtoCopyWith<$Res>(_value.cancellation!, (value) {
      return _then(_value.copyWith(cancellation: value) as $Val);
    });
  }

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderShipmentDtoCopyWith<$Res>? get shipment {
    if (_value.shipment == null) {
      return null;
    }

    return $OrderShipmentDtoCopyWith<$Res>(_value.shipment!, (value) {
      return _then(_value.copyWith(shipment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderDtoImplCopyWith<$Res>
    implements $OrderDtoCopyWith<$Res> {
  factory _$$OrderDtoImplCopyWith(
    _$OrderDtoImpl value,
    $Res Function(_$OrderDtoImpl) then,
  ) = __$$OrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus status,
    OrderCustomerDto customer,
    List<OrderItemDto> items,
    String currency,
    PricingBreakdownDto pricing,
    OrderPaymentDto? payment,
    OrderShippingAddressDto shippingAddress,
    String customerNote,
    OrderCancellationDto? cancellation,
    OrderShipmentDto? shipment,
    DateTime placedAt,
  });

  @override
  $OrderCustomerDtoCopyWith<$Res> get customer;
  @override
  $PricingBreakdownDtoCopyWith<$Res> get pricing;
  @override
  $OrderPaymentDtoCopyWith<$Res>? get payment;
  @override
  $OrderShippingAddressDtoCopyWith<$Res> get shippingAddress;
  @override
  $OrderCancellationDtoCopyWith<$Res>? get cancellation;
  @override
  $OrderShipmentDtoCopyWith<$Res>? get shipment;
}

/// @nodoc
class __$$OrderDtoImplCopyWithImpl<$Res>
    extends _$OrderDtoCopyWithImpl<$Res, _$OrderDtoImpl>
    implements _$$OrderDtoImplCopyWith<$Res> {
  __$$OrderDtoImplCopyWithImpl(
    _$OrderDtoImpl _value,
    $Res Function(_$OrderDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? customer = null,
    Object? items = null,
    Object? currency = null,
    Object? pricing = null,
    Object? payment = freezed,
    Object? shippingAddress = null,
    Object? customerNote = null,
    Object? cancellation = freezed,
    Object? shipment = freezed,
    Object? placedAt = null,
  }) {
    return _then(
      _$OrderDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        customer: null == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as OrderCustomerDto,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItemDto>,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        pricing: null == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as PricingBreakdownDto,
        payment: freezed == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentDto?,
        shippingAddress: null == shippingAddress
            ? _value.shippingAddress
            : shippingAddress // ignore: cast_nullable_to_non_nullable
                  as OrderShippingAddressDto,
        customerNote: null == customerNote
            ? _value.customerNote
            : customerNote // ignore: cast_nullable_to_non_nullable
                  as String,
        cancellation: freezed == cancellation
            ? _value.cancellation
            : cancellation // ignore: cast_nullable_to_non_nullable
                  as OrderCancellationDto?,
        shipment: freezed == shipment
            ? _value.shipment
            : shipment // ignore: cast_nullable_to_non_nullable
                  as OrderShipmentDto?,
        placedAt: null == placedAt
            ? _value.placedAt
            : placedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDtoImpl implements _OrderDto {
  const _$OrderDtoImpl({
    required this.id,
    required this.orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) required this.status,
    required this.customer,
    required final List<OrderItemDto> items,
    required this.currency,
    required this.pricing,
    this.payment,
    required this.shippingAddress,
    required this.customerNote,
    this.cancellation,
    this.shipment,
    required this.placedAt,
  }) : _items = items;

  factory _$OrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String orderNumber;
  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  final OrderStatus status;
  @override
  final OrderCustomerDto customer;
  final List<OrderItemDto> _items;
  @override
  List<OrderItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String currency;
  @override
  final PricingBreakdownDto pricing;
  @override
  final OrderPaymentDto? payment;
  @override
  final OrderShippingAddressDto shippingAddress;
  @override
  final String customerNote;
  @override
  final OrderCancellationDto? cancellation;
  @override
  final OrderShipmentDto? shipment;
  @override
  final DateTime placedAt;

  @override
  String toString() {
    return 'OrderDto(id: $id, orderNumber: $orderNumber, status: $status, customer: $customer, items: $items, currency: $currency, pricing: $pricing, payment: $payment, shippingAddress: $shippingAddress, customerNote: $customerNote, cancellation: $cancellation, shipment: $shipment, placedAt: $placedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.payment, payment) || other.payment == payment) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.customerNote, customerNote) ||
                other.customerNote == customerNote) &&
            (identical(other.cancellation, cancellation) ||
                other.cancellation == cancellation) &&
            (identical(other.shipment, shipment) ||
                other.shipment == shipment) &&
            (identical(other.placedAt, placedAt) ||
                other.placedAt == placedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderNumber,
    status,
    customer,
    const DeepCollectionEquality().hash(_items),
    currency,
    pricing,
    payment,
    shippingAddress,
    customerNote,
    cancellation,
    shipment,
    placedAt,
  );

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDtoImplCopyWith<_$OrderDtoImpl> get copyWith =>
      __$$OrderDtoImplCopyWithImpl<_$OrderDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDtoImplToJson(this);
  }
}

abstract class _OrderDto implements OrderDto {
  const factory _OrderDto({
    required final String id,
    required final String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown)
    required final OrderStatus status,
    required final OrderCustomerDto customer,
    required final List<OrderItemDto> items,
    required final String currency,
    required final PricingBreakdownDto pricing,
    final OrderPaymentDto? payment,
    required final OrderShippingAddressDto shippingAddress,
    required final String customerNote,
    final OrderCancellationDto? cancellation,
    final OrderShipmentDto? shipment,
    required final DateTime placedAt,
  }) = _$OrderDtoImpl;

  factory _OrderDto.fromJson(Map<String, dynamic> json) =
      _$OrderDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get orderNumber;
  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get status;
  @override
  OrderCustomerDto get customer;
  @override
  List<OrderItemDto> get items;
  @override
  String get currency;
  @override
  PricingBreakdownDto get pricing;
  @override
  OrderPaymentDto? get payment;
  @override
  OrderShippingAddressDto get shippingAddress;
  @override
  String get customerNote;
  @override
  OrderCancellationDto? get cancellation;
  @override
  OrderShipmentDto? get shipment;
  @override
  DateTime get placedAt;

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDtoImplCopyWith<_$OrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderSummaryDto _$OrderSummaryDtoFromJson(Map<String, dynamic> json) {
  return _OrderSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$OrderSummaryDto {
  String get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get status => throw _privateConstructorUsedError;
  OrderPaymentDto? get payment => throw _privateConstructorUsedError;
  PricingBreakdownDto get pricing => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  int get totalQuantity => throw _privateConstructorUsedError;
  String get previewImagePublicId => throw _privateConstructorUsedError;
  DateTime get placedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderSummaryDtoCopyWith<OrderSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderSummaryDtoCopyWith<$Res> {
  factory $OrderSummaryDtoCopyWith(
    OrderSummaryDto value,
    $Res Function(OrderSummaryDto) then,
  ) = _$OrderSummaryDtoCopyWithImpl<$Res, OrderSummaryDto>;
  @useResult
  $Res call({
    String id,
    String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus status,
    OrderPaymentDto? payment,
    PricingBreakdownDto pricing,
    int itemCount,
    int totalQuantity,
    String previewImagePublicId,
    DateTime placedAt,
  });

  $OrderPaymentDtoCopyWith<$Res>? get payment;
  $PricingBreakdownDtoCopyWith<$Res> get pricing;
}

/// @nodoc
class _$OrderSummaryDtoCopyWithImpl<$Res, $Val extends OrderSummaryDto>
    implements $OrderSummaryDtoCopyWith<$Res> {
  _$OrderSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? payment = freezed,
    Object? pricing = null,
    Object? itemCount = null,
    Object? totalQuantity = null,
    Object? previewImagePublicId = null,
    Object? placedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            payment: freezed == payment
                ? _value.payment
                : payment // ignore: cast_nullable_to_non_nullable
                      as OrderPaymentDto?,
            pricing: null == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as PricingBreakdownDto,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuantity: null == totalQuantity
                ? _value.totalQuantity
                : totalQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            previewImagePublicId: null == previewImagePublicId
                ? _value.previewImagePublicId
                : previewImagePublicId // ignore: cast_nullable_to_non_nullable
                      as String,
            placedAt: null == placedAt
                ? _value.placedAt
                : placedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPaymentDtoCopyWith<$Res>? get payment {
    if (_value.payment == null) {
      return null;
    }

    return $OrderPaymentDtoCopyWith<$Res>(_value.payment!, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }

  /// Create a copy of OrderSummaryDto
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
abstract class _$$OrderSummaryDtoImplCopyWith<$Res>
    implements $OrderSummaryDtoCopyWith<$Res> {
  factory _$$OrderSummaryDtoImplCopyWith(
    _$OrderSummaryDtoImpl value,
    $Res Function(_$OrderSummaryDtoImpl) then,
  ) = __$$OrderSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) OrderStatus status,
    OrderPaymentDto? payment,
    PricingBreakdownDto pricing,
    int itemCount,
    int totalQuantity,
    String previewImagePublicId,
    DateTime placedAt,
  });

  @override
  $OrderPaymentDtoCopyWith<$Res>? get payment;
  @override
  $PricingBreakdownDtoCopyWith<$Res> get pricing;
}

/// @nodoc
class __$$OrderSummaryDtoImplCopyWithImpl<$Res>
    extends _$OrderSummaryDtoCopyWithImpl<$Res, _$OrderSummaryDtoImpl>
    implements _$$OrderSummaryDtoImplCopyWith<$Res> {
  __$$OrderSummaryDtoImplCopyWithImpl(
    _$OrderSummaryDtoImpl _value,
    $Res Function(_$OrderSummaryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? payment = freezed,
    Object? pricing = null,
    Object? itemCount = null,
    Object? totalQuantity = null,
    Object? previewImagePublicId = null,
    Object? placedAt = null,
  }) {
    return _then(
      _$OrderSummaryDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        payment: freezed == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                  as OrderPaymentDto?,
        pricing: null == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as PricingBreakdownDto,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuantity: null == totalQuantity
            ? _value.totalQuantity
            : totalQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        previewImagePublicId: null == previewImagePublicId
            ? _value.previewImagePublicId
            : previewImagePublicId // ignore: cast_nullable_to_non_nullable
                  as String,
        placedAt: null == placedAt
            ? _value.placedAt
            : placedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderSummaryDtoImpl implements _OrderSummaryDto {
  const _$OrderSummaryDtoImpl({
    required this.id,
    required this.orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown) required this.status,
    this.payment,
    required this.pricing,
    required this.itemCount,
    required this.totalQuantity,
    required this.previewImagePublicId,
    required this.placedAt,
  });

  factory _$OrderSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderSummaryDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String orderNumber;
  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  final OrderStatus status;
  @override
  final OrderPaymentDto? payment;
  @override
  final PricingBreakdownDto pricing;
  @override
  final int itemCount;
  @override
  final int totalQuantity;
  @override
  final String previewImagePublicId;
  @override
  final DateTime placedAt;

  @override
  String toString() {
    return 'OrderSummaryDto(id: $id, orderNumber: $orderNumber, status: $status, payment: $payment, pricing: $pricing, itemCount: $itemCount, totalQuantity: $totalQuantity, previewImagePublicId: $previewImagePublicId, placedAt: $placedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderSummaryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.payment, payment) || other.payment == payment) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.previewImagePublicId, previewImagePublicId) ||
                other.previewImagePublicId == previewImagePublicId) &&
            (identical(other.placedAt, placedAt) ||
                other.placedAt == placedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderNumber,
    status,
    payment,
    pricing,
    itemCount,
    totalQuantity,
    previewImagePublicId,
    placedAt,
  );

  /// Create a copy of OrderSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderSummaryDtoImplCopyWith<_$OrderSummaryDtoImpl> get copyWith =>
      __$$OrderSummaryDtoImplCopyWithImpl<_$OrderSummaryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderSummaryDtoImplToJson(this);
  }
}

abstract class _OrderSummaryDto implements OrderSummaryDto {
  const factory _OrderSummaryDto({
    required final String id,
    required final String orderNumber,
    @JsonKey(unknownEnumValue: OrderStatus.unknown)
    required final OrderStatus status,
    final OrderPaymentDto? payment,
    required final PricingBreakdownDto pricing,
    required final int itemCount,
    required final int totalQuantity,
    required final String previewImagePublicId,
    required final DateTime placedAt,
  }) = _$OrderSummaryDtoImpl;

  factory _OrderSummaryDto.fromJson(Map<String, dynamic> json) =
      _$OrderSummaryDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get orderNumber;
  @override
  @JsonKey(unknownEnumValue: OrderStatus.unknown)
  OrderStatus get status;
  @override
  OrderPaymentDto? get payment;
  @override
  PricingBreakdownDto get pricing;
  @override
  int get itemCount;
  @override
  int get totalQuantity;
  @override
  String get previewImagePublicId;
  @override
  DateTime get placedAt;

  /// Create a copy of OrderSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderSummaryDtoImplCopyWith<_$OrderSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CancelOrderDto _$CancelOrderDtoFromJson(Map<String, dynamic> json) {
  return _CancelOrderDto.fromJson(json);
}

/// @nodoc
mixin _$CancelOrderDto {
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this CancelOrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancelOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancelOrderDtoCopyWith<CancelOrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelOrderDtoCopyWith<$Res> {
  factory $CancelOrderDtoCopyWith(
    CancelOrderDto value,
    $Res Function(CancelOrderDto) then,
  ) = _$CancelOrderDtoCopyWithImpl<$Res, CancelOrderDto>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class _$CancelOrderDtoCopyWithImpl<$Res, $Val extends CancelOrderDto>
    implements $CancelOrderDtoCopyWith<$Res> {
  _$CancelOrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancelOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _value.copyWith(
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CancelOrderDtoImplCopyWith<$Res>
    implements $CancelOrderDtoCopyWith<$Res> {
  factory _$$CancelOrderDtoImplCopyWith(
    _$CancelOrderDtoImpl value,
    $Res Function(_$CancelOrderDtoImpl) then,
  ) = __$$CancelOrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$CancelOrderDtoImplCopyWithImpl<$Res>
    extends _$CancelOrderDtoCopyWithImpl<$Res, _$CancelOrderDtoImpl>
    implements _$$CancelOrderDtoImplCopyWith<$Res> {
  __$$CancelOrderDtoImplCopyWithImpl(
    _$CancelOrderDtoImpl _value,
    $Res Function(_$CancelOrderDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CancelOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$CancelOrderDtoImpl(
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CancelOrderDtoImpl implements _CancelOrderDto {
  const _$CancelOrderDtoImpl({required this.reason});

  factory _$CancelOrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CancelOrderDtoImplFromJson(json);

  @override
  final String reason;

  @override
  String toString() {
    return 'CancelOrderDto(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelOrderDtoImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of CancelOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelOrderDtoImplCopyWith<_$CancelOrderDtoImpl> get copyWith =>
      __$$CancelOrderDtoImplCopyWithImpl<_$CancelOrderDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CancelOrderDtoImplToJson(this);
  }
}

abstract class _CancelOrderDto implements CancelOrderDto {
  const factory _CancelOrderDto({required final String reason}) =
      _$CancelOrderDtoImpl;

  factory _CancelOrderDto.fromJson(Map<String, dynamic> json) =
      _$CancelOrderDtoImpl.fromJson;

  @override
  String get reason;

  /// Create a copy of CancelOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelOrderDtoImplCopyWith<_$CancelOrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResubmitPaymentDto _$ResubmitPaymentDtoFromJson(Map<String, dynamic> json) {
  return _ResubmitPaymentDto.fromJson(json);
}

/// @nodoc
mixin _$ResubmitPaymentDto {
  String get transferSender => throw _privateConstructorUsedError;

  /// Serializes this ResubmitPaymentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResubmitPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResubmitPaymentDtoCopyWith<ResubmitPaymentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResubmitPaymentDtoCopyWith<$Res> {
  factory $ResubmitPaymentDtoCopyWith(
    ResubmitPaymentDto value,
    $Res Function(ResubmitPaymentDto) then,
  ) = _$ResubmitPaymentDtoCopyWithImpl<$Res, ResubmitPaymentDto>;
  @useResult
  $Res call({String transferSender});
}

/// @nodoc
class _$ResubmitPaymentDtoCopyWithImpl<$Res, $Val extends ResubmitPaymentDto>
    implements $ResubmitPaymentDtoCopyWith<$Res> {
  _$ResubmitPaymentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResubmitPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transferSender = null}) {
    return _then(
      _value.copyWith(
            transferSender: null == transferSender
                ? _value.transferSender
                : transferSender // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResubmitPaymentDtoImplCopyWith<$Res>
    implements $ResubmitPaymentDtoCopyWith<$Res> {
  factory _$$ResubmitPaymentDtoImplCopyWith(
    _$ResubmitPaymentDtoImpl value,
    $Res Function(_$ResubmitPaymentDtoImpl) then,
  ) = __$$ResubmitPaymentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String transferSender});
}

/// @nodoc
class __$$ResubmitPaymentDtoImplCopyWithImpl<$Res>
    extends _$ResubmitPaymentDtoCopyWithImpl<$Res, _$ResubmitPaymentDtoImpl>
    implements _$$ResubmitPaymentDtoImplCopyWith<$Res> {
  __$$ResubmitPaymentDtoImplCopyWithImpl(
    _$ResubmitPaymentDtoImpl _value,
    $Res Function(_$ResubmitPaymentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResubmitPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transferSender = null}) {
    return _then(
      _$ResubmitPaymentDtoImpl(
        transferSender: null == transferSender
            ? _value.transferSender
            : transferSender // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResubmitPaymentDtoImpl implements _ResubmitPaymentDto {
  const _$ResubmitPaymentDtoImpl({required this.transferSender});

  factory _$ResubmitPaymentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResubmitPaymentDtoImplFromJson(json);

  @override
  final String transferSender;

  @override
  String toString() {
    return 'ResubmitPaymentDto(transferSender: $transferSender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResubmitPaymentDtoImpl &&
            (identical(other.transferSender, transferSender) ||
                other.transferSender == transferSender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, transferSender);

  /// Create a copy of ResubmitPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResubmitPaymentDtoImplCopyWith<_$ResubmitPaymentDtoImpl> get copyWith =>
      __$$ResubmitPaymentDtoImplCopyWithImpl<_$ResubmitPaymentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ResubmitPaymentDtoImplToJson(this);
  }
}

abstract class _ResubmitPaymentDto implements ResubmitPaymentDto {
  const factory _ResubmitPaymentDto({required final String transferSender}) =
      _$ResubmitPaymentDtoImpl;

  factory _ResubmitPaymentDto.fromJson(Map<String, dynamic> json) =
      _$ResubmitPaymentDtoImpl.fromJson;

  @override
  String get transferSender;

  /// Create a copy of ResubmitPaymentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResubmitPaymentDtoImplCopyWith<_$ResubmitPaymentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
