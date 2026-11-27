// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductImageDto _$ProductImageDtoFromJson(Map<String, dynamic> json) {
  return _ProductImageDto.fromJson(json);
}

/// @nodoc
mixin _$ProductImageDto {
  String get publicId => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  String get alt => throw _privateConstructorUsedError;

  /// Serializes this ProductImageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductImageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductImageDtoCopyWith<ProductImageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductImageDtoCopyWith<$Res> {
  factory $ProductImageDtoCopyWith(
    ProductImageDto value,
    $Res Function(ProductImageDto) then,
  ) = _$ProductImageDtoCopyWithImpl<$Res, ProductImageDto>;
  @useResult
  $Res call({
    String publicId,
    int version,
    String format,
    int width,
    int height,
    String alt,
  });
}

/// @nodoc
class _$ProductImageDtoCopyWithImpl<$Res, $Val extends ProductImageDto>
    implements $ProductImageDtoCopyWith<$Res> {
  _$ProductImageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductImageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicId = null,
    Object? version = null,
    Object? format = null,
    Object? width = null,
    Object? height = null,
    Object? alt = null,
  }) {
    return _then(
      _value.copyWith(
            publicId: null == publicId
                ? _value.publicId
                : publicId // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as String,
            width: null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as int,
            height: null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as int,
            alt: null == alt
                ? _value.alt
                : alt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImageDtoImplCopyWith<$Res>
    implements $ProductImageDtoCopyWith<$Res> {
  factory _$$ProductImageDtoImplCopyWith(
    _$ProductImageDtoImpl value,
    $Res Function(_$ProductImageDtoImpl) then,
  ) = __$$ProductImageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String publicId,
    int version,
    String format,
    int width,
    int height,
    String alt,
  });
}

/// @nodoc
class __$$ProductImageDtoImplCopyWithImpl<$Res>
    extends _$ProductImageDtoCopyWithImpl<$Res, _$ProductImageDtoImpl>
    implements _$$ProductImageDtoImplCopyWith<$Res> {
  __$$ProductImageDtoImplCopyWithImpl(
    _$ProductImageDtoImpl _value,
    $Res Function(_$ProductImageDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductImageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicId = null,
    Object? version = null,
    Object? format = null,
    Object? width = null,
    Object? height = null,
    Object? alt = null,
  }) {
    return _then(
      _$ProductImageDtoImpl(
        publicId: null == publicId
            ? _value.publicId
            : publicId // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as String,
        width: null == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as int,
        height: null == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as int,
        alt: null == alt
            ? _value.alt
            : alt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImageDtoImpl implements _ProductImageDto {
  const _$ProductImageDtoImpl({
    required this.publicId,
    required this.version,
    required this.format,
    required this.width,
    required this.height,
    required this.alt,
  });

  factory _$ProductImageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImageDtoImplFromJson(json);

  @override
  final String publicId;
  @override
  final int version;
  @override
  final String format;
  @override
  final int width;
  @override
  final int height;
  @override
  final String alt;

  @override
  String toString() {
    return 'ProductImageDto(publicId: $publicId, version: $version, format: $format, width: $width, height: $height, alt: $alt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImageDtoImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.alt, alt) || other.alt == alt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, publicId, version, format, width, height, alt);

  /// Create a copy of ProductImageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImageDtoImplCopyWith<_$ProductImageDtoImpl> get copyWith =>
      __$$ProductImageDtoImplCopyWithImpl<_$ProductImageDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImageDtoImplToJson(this);
  }
}

abstract class _ProductImageDto implements ProductImageDto {
  const factory _ProductImageDto({
    required final String publicId,
    required final int version,
    required final String format,
    required final int width,
    required final int height,
    required final String alt,
  }) = _$ProductImageDtoImpl;

  factory _ProductImageDto.fromJson(Map<String, dynamic> json) =
      _$ProductImageDtoImpl.fromJson;

  @override
  String get publicId;
  @override
  int get version;
  @override
  String get format;
  @override
  int get width;
  @override
  int get height;
  @override
  String get alt;

  /// Create a copy of ProductImageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImageDtoImplCopyWith<_$ProductImageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductPricingDto _$ProductPricingDtoFromJson(Map<String, dynamic> json) {
  return _ProductPricingDto.fromJson(json);
}

/// @nodoc
mixin _$ProductPricingDto {
  MoneyDto get basePrice => throw _privateConstructorUsedError;
  MoneyDto? get salePrice =>
      throw _privateConstructorUsedError; // "salePrice ?? basePrice. THE price charged at checkout. Never compute
  // this client-side." (OpenAPI description)
  MoneyDto get effectivePrice => throw _privateConstructorUsedError;
  int get discountPercentBps => throw _privateConstructorUsedError;

  /// Serializes this ProductPricingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductPricingDtoCopyWith<ProductPricingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductPricingDtoCopyWith<$Res> {
  factory $ProductPricingDtoCopyWith(
    ProductPricingDto value,
    $Res Function(ProductPricingDto) then,
  ) = _$ProductPricingDtoCopyWithImpl<$Res, ProductPricingDto>;
  @useResult
  $Res call({
    MoneyDto basePrice,
    MoneyDto? salePrice,
    MoneyDto effectivePrice,
    int discountPercentBps,
  });

  $MoneyDtoCopyWith<$Res> get basePrice;
  $MoneyDtoCopyWith<$Res>? get salePrice;
  $MoneyDtoCopyWith<$Res> get effectivePrice;
}

/// @nodoc
class _$ProductPricingDtoCopyWithImpl<$Res, $Val extends ProductPricingDto>
    implements $ProductPricingDtoCopyWith<$Res> {
  _$ProductPricingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? basePrice = null,
    Object? salePrice = freezed,
    Object? effectivePrice = null,
    Object? discountPercentBps = null,
  }) {
    return _then(
      _value.copyWith(
            basePrice: null == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            salePrice: freezed == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as MoneyDto?,
            effectivePrice: null == effectivePrice
                ? _value.effectivePrice
                : effectivePrice // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            discountPercentBps: null == discountPercentBps
                ? _value.discountPercentBps
                : discountPercentBps // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get basePrice {
    return $MoneyDtoCopyWith<$Res>(_value.basePrice, (value) {
      return _then(_value.copyWith(basePrice: value) as $Val);
    });
  }

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res>? get salePrice {
    if (_value.salePrice == null) {
      return null;
    }

    return $MoneyDtoCopyWith<$Res>(_value.salePrice!, (value) {
      return _then(_value.copyWith(salePrice: value) as $Val);
    });
  }

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get effectivePrice {
    return $MoneyDtoCopyWith<$Res>(_value.effectivePrice, (value) {
      return _then(_value.copyWith(effectivePrice: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductPricingDtoImplCopyWith<$Res>
    implements $ProductPricingDtoCopyWith<$Res> {
  factory _$$ProductPricingDtoImplCopyWith(
    _$ProductPricingDtoImpl value,
    $Res Function(_$ProductPricingDtoImpl) then,
  ) = __$$ProductPricingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MoneyDto basePrice,
    MoneyDto? salePrice,
    MoneyDto effectivePrice,
    int discountPercentBps,
  });

  @override
  $MoneyDtoCopyWith<$Res> get basePrice;
  @override
  $MoneyDtoCopyWith<$Res>? get salePrice;
  @override
  $MoneyDtoCopyWith<$Res> get effectivePrice;
}

/// @nodoc
class __$$ProductPricingDtoImplCopyWithImpl<$Res>
    extends _$ProductPricingDtoCopyWithImpl<$Res, _$ProductPricingDtoImpl>
    implements _$$ProductPricingDtoImplCopyWith<$Res> {
  __$$ProductPricingDtoImplCopyWithImpl(
    _$ProductPricingDtoImpl _value,
    $Res Function(_$ProductPricingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? basePrice = null,
    Object? salePrice = freezed,
    Object? effectivePrice = null,
    Object? discountPercentBps = null,
  }) {
    return _then(
      _$ProductPricingDtoImpl(
        basePrice: null == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        salePrice: freezed == salePrice
            ? _value.salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as MoneyDto?,
        effectivePrice: null == effectivePrice
            ? _value.effectivePrice
            : effectivePrice // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        discountPercentBps: null == discountPercentBps
            ? _value.discountPercentBps
            : discountPercentBps // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductPricingDtoImpl implements _ProductPricingDto {
  const _$ProductPricingDtoImpl({
    required this.basePrice,
    this.salePrice,
    required this.effectivePrice,
    required this.discountPercentBps,
  });

  factory _$ProductPricingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductPricingDtoImplFromJson(json);

  @override
  final MoneyDto basePrice;
  @override
  final MoneyDto? salePrice;
  // "salePrice ?? basePrice. THE price charged at checkout. Never compute
  // this client-side." (OpenAPI description)
  @override
  final MoneyDto effectivePrice;
  @override
  final int discountPercentBps;

  @override
  String toString() {
    return 'ProductPricingDto(basePrice: $basePrice, salePrice: $salePrice, effectivePrice: $effectivePrice, discountPercentBps: $discountPercentBps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductPricingDtoImpl &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.effectivePrice, effectivePrice) ||
                other.effectivePrice == effectivePrice) &&
            (identical(other.discountPercentBps, discountPercentBps) ||
                other.discountPercentBps == discountPercentBps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    basePrice,
    salePrice,
    effectivePrice,
    discountPercentBps,
  );

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductPricingDtoImplCopyWith<_$ProductPricingDtoImpl> get copyWith =>
      __$$ProductPricingDtoImplCopyWithImpl<_$ProductPricingDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductPricingDtoImplToJson(this);
  }
}

abstract class _ProductPricingDto implements ProductPricingDto {
  const factory _ProductPricingDto({
    required final MoneyDto basePrice,
    final MoneyDto? salePrice,
    required final MoneyDto effectivePrice,
    required final int discountPercentBps,
  }) = _$ProductPricingDtoImpl;

  factory _ProductPricingDto.fromJson(Map<String, dynamic> json) =
      _$ProductPricingDtoImpl.fromJson;

  @override
  MoneyDto get basePrice;
  @override
  MoneyDto? get salePrice; // "salePrice ?? basePrice. THE price charged at checkout. Never compute
  // this client-side." (OpenAPI description)
  @override
  MoneyDto get effectivePrice;
  @override
  int get discountPercentBps;

  /// Create a copy of ProductPricingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductPricingDtoImplCopyWith<_$ProductPricingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductRatingDto _$ProductRatingDtoFromJson(Map<String, dynamic> json) {
  return _ProductRatingDto.fromJson(json);
}

/// @nodoc
mixin _$ProductRatingDto {
  double get average => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this ProductRatingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductRatingDtoCopyWith<ProductRatingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductRatingDtoCopyWith<$Res> {
  factory $ProductRatingDtoCopyWith(
    ProductRatingDto value,
    $Res Function(ProductRatingDto) then,
  ) = _$ProductRatingDtoCopyWithImpl<$Res, ProductRatingDto>;
  @useResult
  $Res call({double average, int count});
}

/// @nodoc
class _$ProductRatingDtoCopyWithImpl<$Res, $Val extends ProductRatingDto>
    implements $ProductRatingDtoCopyWith<$Res> {
  _$ProductRatingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? average = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            average: null == average
                ? _value.average
                : average // ignore: cast_nullable_to_non_nullable
                      as double,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductRatingDtoImplCopyWith<$Res>
    implements $ProductRatingDtoCopyWith<$Res> {
  factory _$$ProductRatingDtoImplCopyWith(
    _$ProductRatingDtoImpl value,
    $Res Function(_$ProductRatingDtoImpl) then,
  ) = __$$ProductRatingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double average, int count});
}

/// @nodoc
class __$$ProductRatingDtoImplCopyWithImpl<$Res>
    extends _$ProductRatingDtoCopyWithImpl<$Res, _$ProductRatingDtoImpl>
    implements _$$ProductRatingDtoImplCopyWith<$Res> {
  __$$ProductRatingDtoImplCopyWithImpl(
    _$ProductRatingDtoImpl _value,
    $Res Function(_$ProductRatingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? average = null, Object? count = null}) {
    return _then(
      _$ProductRatingDtoImpl(
        average: null == average
            ? _value.average
            : average // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductRatingDtoImpl implements _ProductRatingDto {
  const _$ProductRatingDtoImpl({required this.average, required this.count});

  factory _$ProductRatingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductRatingDtoImplFromJson(json);

  @override
  final double average;
  @override
  final int count;

  @override
  String toString() {
    return 'ProductRatingDto(average: $average, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductRatingDtoImpl &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, average, count);

  /// Create a copy of ProductRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductRatingDtoImplCopyWith<_$ProductRatingDtoImpl> get copyWith =>
      __$$ProductRatingDtoImplCopyWithImpl<_$ProductRatingDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductRatingDtoImplToJson(this);
  }
}

abstract class _ProductRatingDto implements ProductRatingDto {
  const factory _ProductRatingDto({
    required final double average,
    required final int count,
  }) = _$ProductRatingDtoImpl;

  factory _ProductRatingDto.fromJson(Map<String, dynamic> json) =
      _$ProductRatingDtoImpl.fromJson;

  @override
  double get average;
  @override
  int get count;

  /// Create a copy of ProductRatingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductRatingDtoImplCopyWith<_$ProductRatingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSpecDto _$ProductSpecDtoFromJson(Map<String, dynamic> json) {
  return _ProductSpecDto.fromJson(json);
}

/// @nodoc
mixin _$ProductSpecDto {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  bool get filterable => throw _privateConstructorUsedError;

  /// Serializes this ProductSpecDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSpecDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSpecDtoCopyWith<ProductSpecDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSpecDtoCopyWith<$Res> {
  factory $ProductSpecDtoCopyWith(
    ProductSpecDto value,
    $Res Function(ProductSpecDto) then,
  ) = _$ProductSpecDtoCopyWithImpl<$Res, ProductSpecDto>;
  @useResult
  $Res call({
    String key,
    String label,
    String value,
    String? unit,
    bool filterable,
  });
}

/// @nodoc
class _$ProductSpecDtoCopyWithImpl<$Res, $Val extends ProductSpecDto>
    implements $ProductSpecDtoCopyWith<$Res> {
  _$ProductSpecDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSpecDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? value = null,
    Object? unit = freezed,
    Object? filterable = null,
  }) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            filterable: null == filterable
                ? _value.filterable
                : filterable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductSpecDtoImplCopyWith<$Res>
    implements $ProductSpecDtoCopyWith<$Res> {
  factory _$$ProductSpecDtoImplCopyWith(
    _$ProductSpecDtoImpl value,
    $Res Function(_$ProductSpecDtoImpl) then,
  ) = __$$ProductSpecDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String key,
    String label,
    String value,
    String? unit,
    bool filterable,
  });
}

/// @nodoc
class __$$ProductSpecDtoImplCopyWithImpl<$Res>
    extends _$ProductSpecDtoCopyWithImpl<$Res, _$ProductSpecDtoImpl>
    implements _$$ProductSpecDtoImplCopyWith<$Res> {
  __$$ProductSpecDtoImplCopyWithImpl(
    _$ProductSpecDtoImpl _value,
    $Res Function(_$ProductSpecDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSpecDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? value = null,
    Object? unit = freezed,
    Object? filterable = null,
  }) {
    return _then(
      _$ProductSpecDtoImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        filterable: null == filterable
            ? _value.filterable
            : filterable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSpecDtoImpl implements _ProductSpecDto {
  const _$ProductSpecDtoImpl({
    required this.key,
    required this.label,
    required this.value,
    this.unit,
    required this.filterable,
  });

  factory _$ProductSpecDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSpecDtoImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  @override
  final String value;
  @override
  final String? unit;
  @override
  final bool filterable;

  @override
  String toString() {
    return 'ProductSpecDto(key: $key, label: $label, value: $value, unit: $unit, filterable: $filterable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSpecDtoImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.filterable, filterable) ||
                other.filterable == filterable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, label, value, unit, filterable);

  /// Create a copy of ProductSpecDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSpecDtoImplCopyWith<_$ProductSpecDtoImpl> get copyWith =>
      __$$ProductSpecDtoImplCopyWithImpl<_$ProductSpecDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSpecDtoImplToJson(this);
  }
}

abstract class _ProductSpecDto implements ProductSpecDto {
  const factory _ProductSpecDto({
    required final String key,
    required final String label,
    required final String value,
    final String? unit,
    required final bool filterable,
  }) = _$ProductSpecDtoImpl;

  factory _ProductSpecDto.fromJson(Map<String, dynamic> json) =
      _$ProductSpecDtoImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  String get value;
  @override
  String? get unit;
  @override
  bool get filterable;

  /// Create a copy of ProductSpecDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSpecDtoImplCopyWith<_$ProductSpecDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductListItemDto _$ProductListItemDtoFromJson(Map<String, dynamic> json) {
  return _ProductListItemDto.fromJson(json);
}

/// @nodoc
mixin _$ProductListItemDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortDescription => throw _privateConstructorUsedError;
  CategoryRefDto get category =>
      throw _privateConstructorUsedError; // Null for most live products — always render without one.
  BrandRefDto? get brand => throw _privateConstructorUsedError;
  ProductPricingDto get pricing => throw _privateConstructorUsedError;
  ProductImageDto? get primaryImage => throw _privateConstructorUsedError;
  ProductRatingDto get rating => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: Availability.unknown)
  Availability get availability => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;

  /// Serializes this ProductListItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductListItemDtoCopyWith<ProductListItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductListItemDtoCopyWith<$Res> {
  factory $ProductListItemDtoCopyWith(
    ProductListItemDto value,
    $Res Function(ProductListItemDto) then,
  ) = _$ProductListItemDtoCopyWithImpl<$Res, ProductListItemDto>;
  @useResult
  $Res call({
    String id,
    String slug,
    String sku,
    String name,
    String shortDescription,
    CategoryRefDto category,
    BrandRefDto? brand,
    ProductPricingDto pricing,
    ProductImageDto? primaryImage,
    ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown) Availability availability,
    bool isFeatured,
  });

  $CategoryRefDtoCopyWith<$Res> get category;
  $BrandRefDtoCopyWith<$Res>? get brand;
  $ProductPricingDtoCopyWith<$Res> get pricing;
  $ProductImageDtoCopyWith<$Res>? get primaryImage;
  $ProductRatingDtoCopyWith<$Res> get rating;
}

/// @nodoc
class _$ProductListItemDtoCopyWithImpl<$Res, $Val extends ProductListItemDto>
    implements $ProductListItemDtoCopyWith<$Res> {
  _$ProductListItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? sku = null,
    Object? name = null,
    Object? shortDescription = null,
    Object? category = null,
    Object? brand = freezed,
    Object? pricing = null,
    Object? primaryImage = freezed,
    Object? rating = null,
    Object? availability = null,
    Object? isFeatured = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
            shortDescription: null == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CategoryRefDto,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as BrandRefDto?,
            pricing: null == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as ProductPricingDto,
            primaryImage: freezed == primaryImage
                ? _value.primaryImage
                : primaryImage // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as ProductRatingDto,
            availability: null == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as Availability,
            isFeatured: null == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryRefDtoCopyWith<$Res> get category {
    return $CategoryRefDtoCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandRefDtoCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $BrandRefDtoCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductPricingDtoCopyWith<$Res> get pricing {
    return $ProductPricingDtoCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get primaryImage {
    if (_value.primaryImage == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.primaryImage!, (value) {
      return _then(_value.copyWith(primaryImage: value) as $Val);
    });
  }

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductRatingDtoCopyWith<$Res> get rating {
    return $ProductRatingDtoCopyWith<$Res>(_value.rating, (value) {
      return _then(_value.copyWith(rating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductListItemDtoImplCopyWith<$Res>
    implements $ProductListItemDtoCopyWith<$Res> {
  factory _$$ProductListItemDtoImplCopyWith(
    _$ProductListItemDtoImpl value,
    $Res Function(_$ProductListItemDtoImpl) then,
  ) = __$$ProductListItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slug,
    String sku,
    String name,
    String shortDescription,
    CategoryRefDto category,
    BrandRefDto? brand,
    ProductPricingDto pricing,
    ProductImageDto? primaryImage,
    ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown) Availability availability,
    bool isFeatured,
  });

  @override
  $CategoryRefDtoCopyWith<$Res> get category;
  @override
  $BrandRefDtoCopyWith<$Res>? get brand;
  @override
  $ProductPricingDtoCopyWith<$Res> get pricing;
  @override
  $ProductImageDtoCopyWith<$Res>? get primaryImage;
  @override
  $ProductRatingDtoCopyWith<$Res> get rating;
}

/// @nodoc
class __$$ProductListItemDtoImplCopyWithImpl<$Res>
    extends _$ProductListItemDtoCopyWithImpl<$Res, _$ProductListItemDtoImpl>
    implements _$$ProductListItemDtoImplCopyWith<$Res> {
  __$$ProductListItemDtoImplCopyWithImpl(
    _$ProductListItemDtoImpl _value,
    $Res Function(_$ProductListItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? sku = null,
    Object? name = null,
    Object? shortDescription = null,
    Object? category = null,
    Object? brand = freezed,
    Object? pricing = null,
    Object? primaryImage = freezed,
    Object? rating = null,
    Object? availability = null,
    Object? isFeatured = null,
  }) {
    return _then(
      _$ProductListItemDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
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
        shortDescription: null == shortDescription
            ? _value.shortDescription
            : shortDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryRefDto,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as BrandRefDto?,
        pricing: null == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as ProductPricingDto,
        primaryImage: freezed == primaryImage
            ? _value.primaryImage
            : primaryImage // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as ProductRatingDto,
        availability: null == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as Availability,
        isFeatured: null == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductListItemDtoImpl implements _ProductListItemDto {
  const _$ProductListItemDtoImpl({
    required this.id,
    required this.slug,
    required this.sku,
    required this.name,
    required this.shortDescription,
    required this.category,
    this.brand,
    required this.pricing,
    this.primaryImage,
    required this.rating,
    @JsonKey(unknownEnumValue: Availability.unknown) required this.availability,
    required this.isFeatured,
  });

  factory _$ProductListItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductListItemDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String sku;
  @override
  final String name;
  @override
  final String shortDescription;
  @override
  final CategoryRefDto category;
  // Null for most live products — always render without one.
  @override
  final BrandRefDto? brand;
  @override
  final ProductPricingDto pricing;
  @override
  final ProductImageDto? primaryImage;
  @override
  final ProductRatingDto rating;
  @override
  @JsonKey(unknownEnumValue: Availability.unknown)
  final Availability availability;
  @override
  final bool isFeatured;

  @override
  String toString() {
    return 'ProductListItemDto(id: $id, slug: $slug, sku: $sku, name: $name, shortDescription: $shortDescription, category: $category, brand: $brand, pricing: $pricing, primaryImage: $primaryImage, rating: $rating, availability: $availability, isFeatured: $isFeatured)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductListItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.primaryImage, primaryImage) ||
                other.primaryImage == primaryImage) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    slug,
    sku,
    name,
    shortDescription,
    category,
    brand,
    pricing,
    primaryImage,
    rating,
    availability,
    isFeatured,
  );

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductListItemDtoImplCopyWith<_$ProductListItemDtoImpl> get copyWith =>
      __$$ProductListItemDtoImplCopyWithImpl<_$ProductListItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductListItemDtoImplToJson(this);
  }
}

abstract class _ProductListItemDto implements ProductListItemDto {
  const factory _ProductListItemDto({
    required final String id,
    required final String slug,
    required final String sku,
    required final String name,
    required final String shortDescription,
    required final CategoryRefDto category,
    final BrandRefDto? brand,
    required final ProductPricingDto pricing,
    final ProductImageDto? primaryImage,
    required final ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown)
    required final Availability availability,
    required final bool isFeatured,
  }) = _$ProductListItemDtoImpl;

  factory _ProductListItemDto.fromJson(Map<String, dynamic> json) =
      _$ProductListItemDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get sku;
  @override
  String get name;
  @override
  String get shortDescription;
  @override
  CategoryRefDto get category; // Null for most live products — always render without one.
  @override
  BrandRefDto? get brand;
  @override
  ProductPricingDto get pricing;
  @override
  ProductImageDto? get primaryImage;
  @override
  ProductRatingDto get rating;
  @override
  @JsonKey(unknownEnumValue: Availability.unknown)
  Availability get availability;
  @override
  bool get isFeatured;

  /// Create a copy of ProductListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductListItemDtoImplCopyWith<_$ProductListItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductDetailDto _$ProductDetailDtoFromJson(Map<String, dynamic> json) {
  return _ProductDetailDto.fromJson(json);
}

/// @nodoc
mixin _$ProductDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortDescription => throw _privateConstructorUsedError;
  CategoryRefDto get category => throw _privateConstructorUsedError;
  BrandRefDto? get brand => throw _privateConstructorUsedError;
  ProductPricingDto get pricing => throw _privateConstructorUsedError;
  ProductImageDto? get primaryImage => throw _privateConstructorUsedError;
  ProductRatingDto get rating => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: Availability.unknown)
  Availability get availability => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<ProductImageDto> get images => throw _privateConstructorUsedError;
  List<ProductSpecDto> get specs => throw _privateConstructorUsedError;
  int get stockOnHand => throw _privateConstructorUsedError;
  int get salesCount => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductDetailDtoCopyWith<ProductDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailDtoCopyWith<$Res> {
  factory $ProductDetailDtoCopyWith(
    ProductDetailDto value,
    $Res Function(ProductDetailDto) then,
  ) = _$ProductDetailDtoCopyWithImpl<$Res, ProductDetailDto>;
  @useResult
  $Res call({
    String id,
    String slug,
    String sku,
    String name,
    String shortDescription,
    CategoryRefDto category,
    BrandRefDto? brand,
    ProductPricingDto pricing,
    ProductImageDto? primaryImage,
    ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown) Availability availability,
    bool isFeatured,
    String description,
    List<ProductImageDto> images,
    List<ProductSpecDto> specs,
    int stockOnHand,
    int salesCount,
    double weight,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $CategoryRefDtoCopyWith<$Res> get category;
  $BrandRefDtoCopyWith<$Res>? get brand;
  $ProductPricingDtoCopyWith<$Res> get pricing;
  $ProductImageDtoCopyWith<$Res>? get primaryImage;
  $ProductRatingDtoCopyWith<$Res> get rating;
}

/// @nodoc
class _$ProductDetailDtoCopyWithImpl<$Res, $Val extends ProductDetailDto>
    implements $ProductDetailDtoCopyWith<$Res> {
  _$ProductDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? sku = null,
    Object? name = null,
    Object? shortDescription = null,
    Object? category = null,
    Object? brand = freezed,
    Object? pricing = null,
    Object? primaryImage = freezed,
    Object? rating = null,
    Object? availability = null,
    Object? isFeatured = null,
    Object? description = null,
    Object? images = null,
    Object? specs = null,
    Object? stockOnHand = null,
    Object? salesCount = null,
    Object? weight = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
            shortDescription: null == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CategoryRefDto,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as BrandRefDto?,
            pricing: null == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as ProductPricingDto,
            primaryImage: freezed == primaryImage
                ? _value.primaryImage
                : primaryImage // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as ProductRatingDto,
            availability: null == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as Availability,
            isFeatured: null == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<ProductImageDto>,
            specs: null == specs
                ? _value.specs
                : specs // ignore: cast_nullable_to_non_nullable
                      as List<ProductSpecDto>,
            stockOnHand: null == stockOnHand
                ? _value.stockOnHand
                : stockOnHand // ignore: cast_nullable_to_non_nullable
                      as int,
            salesCount: null == salesCount
                ? _value.salesCount
                : salesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryRefDtoCopyWith<$Res> get category {
    return $CategoryRefDtoCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandRefDtoCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $BrandRefDtoCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductPricingDtoCopyWith<$Res> get pricing {
    return $ProductPricingDtoCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get primaryImage {
    if (_value.primaryImage == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.primaryImage!, (value) {
      return _then(_value.copyWith(primaryImage: value) as $Val);
    });
  }

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductRatingDtoCopyWith<$Res> get rating {
    return $ProductRatingDtoCopyWith<$Res>(_value.rating, (value) {
      return _then(_value.copyWith(rating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductDetailDtoImplCopyWith<$Res>
    implements $ProductDetailDtoCopyWith<$Res> {
  factory _$$ProductDetailDtoImplCopyWith(
    _$ProductDetailDtoImpl value,
    $Res Function(_$ProductDetailDtoImpl) then,
  ) = __$$ProductDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slug,
    String sku,
    String name,
    String shortDescription,
    CategoryRefDto category,
    BrandRefDto? brand,
    ProductPricingDto pricing,
    ProductImageDto? primaryImage,
    ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown) Availability availability,
    bool isFeatured,
    String description,
    List<ProductImageDto> images,
    List<ProductSpecDto> specs,
    int stockOnHand,
    int salesCount,
    double weight,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $CategoryRefDtoCopyWith<$Res> get category;
  @override
  $BrandRefDtoCopyWith<$Res>? get brand;
  @override
  $ProductPricingDtoCopyWith<$Res> get pricing;
  @override
  $ProductImageDtoCopyWith<$Res>? get primaryImage;
  @override
  $ProductRatingDtoCopyWith<$Res> get rating;
}

/// @nodoc
class __$$ProductDetailDtoImplCopyWithImpl<$Res>
    extends _$ProductDetailDtoCopyWithImpl<$Res, _$ProductDetailDtoImpl>
    implements _$$ProductDetailDtoImplCopyWith<$Res> {
  __$$ProductDetailDtoImplCopyWithImpl(
    _$ProductDetailDtoImpl _value,
    $Res Function(_$ProductDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? sku = null,
    Object? name = null,
    Object? shortDescription = null,
    Object? category = null,
    Object? brand = freezed,
    Object? pricing = null,
    Object? primaryImage = freezed,
    Object? rating = null,
    Object? availability = null,
    Object? isFeatured = null,
    Object? description = null,
    Object? images = null,
    Object? specs = null,
    Object? stockOnHand = null,
    Object? salesCount = null,
    Object? weight = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ProductDetailDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
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
        shortDescription: null == shortDescription
            ? _value.shortDescription
            : shortDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryRefDto,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as BrandRefDto?,
        pricing: null == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as ProductPricingDto,
        primaryImage: freezed == primaryImage
            ? _value.primaryImage
            : primaryImage // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as ProductRatingDto,
        availability: null == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as Availability,
        isFeatured: null == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<ProductImageDto>,
        specs: null == specs
            ? _value._specs
            : specs // ignore: cast_nullable_to_non_nullable
                  as List<ProductSpecDto>,
        stockOnHand: null == stockOnHand
            ? _value.stockOnHand
            : stockOnHand // ignore: cast_nullable_to_non_nullable
                  as int,
        salesCount: null == salesCount
            ? _value.salesCount
            : salesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductDetailDtoImpl implements _ProductDetailDto {
  const _$ProductDetailDtoImpl({
    required this.id,
    required this.slug,
    required this.sku,
    required this.name,
    required this.shortDescription,
    required this.category,
    this.brand,
    required this.pricing,
    this.primaryImage,
    required this.rating,
    @JsonKey(unknownEnumValue: Availability.unknown) required this.availability,
    required this.isFeatured,
    required this.description,
    required final List<ProductImageDto> images,
    required final List<ProductSpecDto> specs,
    required this.stockOnHand,
    required this.salesCount,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  }) : _images = images,
       _specs = specs;

  factory _$ProductDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String sku;
  @override
  final String name;
  @override
  final String shortDescription;
  @override
  final CategoryRefDto category;
  @override
  final BrandRefDto? brand;
  @override
  final ProductPricingDto pricing;
  @override
  final ProductImageDto? primaryImage;
  @override
  final ProductRatingDto rating;
  @override
  @JsonKey(unknownEnumValue: Availability.unknown)
  final Availability availability;
  @override
  final bool isFeatured;
  @override
  final String description;
  final List<ProductImageDto> _images;
  @override
  List<ProductImageDto> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<ProductSpecDto> _specs;
  @override
  List<ProductSpecDto> get specs {
    if (_specs is EqualUnmodifiableListView) return _specs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specs);
  }

  @override
  final int stockOnHand;
  @override
  final int salesCount;
  @override
  final double weight;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProductDetailDto(id: $id, slug: $slug, sku: $sku, name: $name, shortDescription: $shortDescription, category: $category, brand: $brand, pricing: $pricing, primaryImage: $primaryImage, rating: $rating, availability: $availability, isFeatured: $isFeatured, description: $description, images: $images, specs: $specs, stockOnHand: $stockOnHand, salesCount: $salesCount, weight: $weight, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.primaryImage, primaryImage) ||
                other.primaryImage == primaryImage) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._specs, _specs) &&
            (identical(other.stockOnHand, stockOnHand) ||
                other.stockOnHand == stockOnHand) &&
            (identical(other.salesCount, salesCount) ||
                other.salesCount == salesCount) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    slug,
    sku,
    name,
    shortDescription,
    category,
    brand,
    pricing,
    primaryImage,
    rating,
    availability,
    isFeatured,
    description,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_specs),
    stockOnHand,
    salesCount,
    weight,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailDtoImplCopyWith<_$ProductDetailDtoImpl> get copyWith =>
      __$$ProductDetailDtoImplCopyWithImpl<_$ProductDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductDetailDtoImplToJson(this);
  }
}

abstract class _ProductDetailDto implements ProductDetailDto {
  const factory _ProductDetailDto({
    required final String id,
    required final String slug,
    required final String sku,
    required final String name,
    required final String shortDescription,
    required final CategoryRefDto category,
    final BrandRefDto? brand,
    required final ProductPricingDto pricing,
    final ProductImageDto? primaryImage,
    required final ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown)
    required final Availability availability,
    required final bool isFeatured,
    required final String description,
    required final List<ProductImageDto> images,
    required final List<ProductSpecDto> specs,
    required final int stockOnHand,
    required final int salesCount,
    required final double weight,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ProductDetailDtoImpl;

  factory _ProductDetailDto.fromJson(Map<String, dynamic> json) =
      _$ProductDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get sku;
  @override
  String get name;
  @override
  String get shortDescription;
  @override
  CategoryRefDto get category;
  @override
  BrandRefDto? get brand;
  @override
  ProductPricingDto get pricing;
  @override
  ProductImageDto? get primaryImage;
  @override
  ProductRatingDto get rating;
  @override
  @JsonKey(unknownEnumValue: Availability.unknown)
  Availability get availability;
  @override
  bool get isFeatured;
  @override
  String get description;
  @override
  List<ProductImageDto> get images;
  @override
  List<ProductSpecDto> get specs;
  @override
  int get stockOnHand;
  @override
  int get salesCount;
  @override
  double get weight;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ProductDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailDtoImplCopyWith<_$ProductDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TermFacetDto _$TermFacetDtoFromJson(Map<String, dynamic> json) {
  return _TermFacetDto.fromJson(json);
}

/// @nodoc
mixin _$TermFacetDto {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TermFacetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TermFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TermFacetDtoCopyWith<TermFacetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TermFacetDtoCopyWith<$Res> {
  factory $TermFacetDtoCopyWith(
    TermFacetDto value,
    $Res Function(TermFacetDto) then,
  ) = _$TermFacetDtoCopyWithImpl<$Res, TermFacetDto>;
  @useResult
  $Res call({String slug, String name, int count});
}

/// @nodoc
class _$TermFacetDtoCopyWithImpl<$Res, $Val extends TermFacetDto>
    implements $TermFacetDtoCopyWith<$Res> {
  _$TermFacetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TermFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? slug = null, Object? name = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TermFacetDtoImplCopyWith<$Res>
    implements $TermFacetDtoCopyWith<$Res> {
  factory _$$TermFacetDtoImplCopyWith(
    _$TermFacetDtoImpl value,
    $Res Function(_$TermFacetDtoImpl) then,
  ) = __$$TermFacetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String slug, String name, int count});
}

/// @nodoc
class __$$TermFacetDtoImplCopyWithImpl<$Res>
    extends _$TermFacetDtoCopyWithImpl<$Res, _$TermFacetDtoImpl>
    implements _$$TermFacetDtoImplCopyWith<$Res> {
  __$$TermFacetDtoImplCopyWithImpl(
    _$TermFacetDtoImpl _value,
    $Res Function(_$TermFacetDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TermFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? slug = null, Object? name = null, Object? count = null}) {
    return _then(
      _$TermFacetDtoImpl(
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TermFacetDtoImpl implements _TermFacetDto {
  const _$TermFacetDtoImpl({
    required this.slug,
    required this.name,
    required this.count,
  });

  factory _$TermFacetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TermFacetDtoImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;
  @override
  final int count;

  @override
  String toString() {
    return 'TermFacetDto(slug: $slug, name: $name, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TermFacetDtoImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, slug, name, count);

  /// Create a copy of TermFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TermFacetDtoImplCopyWith<_$TermFacetDtoImpl> get copyWith =>
      __$$TermFacetDtoImplCopyWithImpl<_$TermFacetDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TermFacetDtoImplToJson(this);
  }
}

abstract class _TermFacetDto implements TermFacetDto {
  const factory _TermFacetDto({
    required final String slug,
    required final String name,
    required final int count,
  }) = _$TermFacetDtoImpl;

  factory _TermFacetDto.fromJson(Map<String, dynamic> json) =
      _$TermFacetDtoImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  int get count;

  /// Create a copy of TermFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TermFacetDtoImplCopyWith<_$TermFacetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpecFacetValueDto _$SpecFacetValueDtoFromJson(Map<String, dynamic> json) {
  return _SpecFacetValueDto.fromJson(json);
}

/// @nodoc
mixin _$SpecFacetValueDto {
  String get value => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this SpecFacetValueDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecFacetValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecFacetValueDtoCopyWith<SpecFacetValueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecFacetValueDtoCopyWith<$Res> {
  factory $SpecFacetValueDtoCopyWith(
    SpecFacetValueDto value,
    $Res Function(SpecFacetValueDto) then,
  ) = _$SpecFacetValueDtoCopyWithImpl<$Res, SpecFacetValueDto>;
  @useResult
  $Res call({String value, int count});
}

/// @nodoc
class _$SpecFacetValueDtoCopyWithImpl<$Res, $Val extends SpecFacetValueDto>
    implements $SpecFacetValueDtoCopyWith<$Res> {
  _$SpecFacetValueDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecFacetValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpecFacetValueDtoImplCopyWith<$Res>
    implements $SpecFacetValueDtoCopyWith<$Res> {
  factory _$$SpecFacetValueDtoImplCopyWith(
    _$SpecFacetValueDtoImpl value,
    $Res Function(_$SpecFacetValueDtoImpl) then,
  ) = __$$SpecFacetValueDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, int count});
}

/// @nodoc
class __$$SpecFacetValueDtoImplCopyWithImpl<$Res>
    extends _$SpecFacetValueDtoCopyWithImpl<$Res, _$SpecFacetValueDtoImpl>
    implements _$$SpecFacetValueDtoImplCopyWith<$Res> {
  __$$SpecFacetValueDtoImplCopyWithImpl(
    _$SpecFacetValueDtoImpl _value,
    $Res Function(_$SpecFacetValueDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecFacetValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? count = null}) {
    return _then(
      _$SpecFacetValueDtoImpl(
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecFacetValueDtoImpl implements _SpecFacetValueDto {
  const _$SpecFacetValueDtoImpl({required this.value, required this.count});

  factory _$SpecFacetValueDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecFacetValueDtoImplFromJson(json);

  @override
  final String value;
  @override
  final int count;

  @override
  String toString() {
    return 'SpecFacetValueDto(value: $value, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecFacetValueDtoImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, count);

  /// Create a copy of SpecFacetValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecFacetValueDtoImplCopyWith<_$SpecFacetValueDtoImpl> get copyWith =>
      __$$SpecFacetValueDtoImplCopyWithImpl<_$SpecFacetValueDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecFacetValueDtoImplToJson(this);
  }
}

abstract class _SpecFacetValueDto implements SpecFacetValueDto {
  const factory _SpecFacetValueDto({
    required final String value,
    required final int count,
  }) = _$SpecFacetValueDtoImpl;

  factory _SpecFacetValueDto.fromJson(Map<String, dynamic> json) =
      _$SpecFacetValueDtoImpl.fromJson;

  @override
  String get value;
  @override
  int get count;

  /// Create a copy of SpecFacetValueDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecFacetValueDtoImplCopyWith<_$SpecFacetValueDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpecFacetDto _$SpecFacetDtoFromJson(Map<String, dynamic> json) {
  return _SpecFacetDto.fromJson(json);
}

/// @nodoc
mixin _$SpecFacetDto {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<SpecFacetValueDto> get values => throw _privateConstructorUsedError;

  /// Serializes this SpecFacetDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecFacetDtoCopyWith<SpecFacetDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecFacetDtoCopyWith<$Res> {
  factory $SpecFacetDtoCopyWith(
    SpecFacetDto value,
    $Res Function(SpecFacetDto) then,
  ) = _$SpecFacetDtoCopyWithImpl<$Res, SpecFacetDto>;
  @useResult
  $Res call({String key, String label, List<SpecFacetValueDto> values});
}

/// @nodoc
class _$SpecFacetDtoCopyWithImpl<$Res, $Val extends SpecFacetDto>
    implements $SpecFacetDtoCopyWith<$Res> {
  _$SpecFacetDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? label = null, Object? values = null}) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            values: null == values
                ? _value.values
                : values // ignore: cast_nullable_to_non_nullable
                      as List<SpecFacetValueDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpecFacetDtoImplCopyWith<$Res>
    implements $SpecFacetDtoCopyWith<$Res> {
  factory _$$SpecFacetDtoImplCopyWith(
    _$SpecFacetDtoImpl value,
    $Res Function(_$SpecFacetDtoImpl) then,
  ) = __$$SpecFacetDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String label, List<SpecFacetValueDto> values});
}

/// @nodoc
class __$$SpecFacetDtoImplCopyWithImpl<$Res>
    extends _$SpecFacetDtoCopyWithImpl<$Res, _$SpecFacetDtoImpl>
    implements _$$SpecFacetDtoImplCopyWith<$Res> {
  __$$SpecFacetDtoImplCopyWithImpl(
    _$SpecFacetDtoImpl _value,
    $Res Function(_$SpecFacetDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? label = null, Object? values = null}) {
    return _then(
      _$SpecFacetDtoImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        values: null == values
            ? _value._values
            : values // ignore: cast_nullable_to_non_nullable
                  as List<SpecFacetValueDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecFacetDtoImpl implements _SpecFacetDto {
  const _$SpecFacetDtoImpl({
    required this.key,
    required this.label,
    required final List<SpecFacetValueDto> values,
  }) : _values = values;

  factory _$SpecFacetDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecFacetDtoImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  final List<SpecFacetValueDto> _values;
  @override
  List<SpecFacetValueDto> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  String toString() {
    return 'SpecFacetDto(key: $key, label: $label, values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecFacetDtoImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    key,
    label,
    const DeepCollectionEquality().hash(_values),
  );

  /// Create a copy of SpecFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecFacetDtoImplCopyWith<_$SpecFacetDtoImpl> get copyWith =>
      __$$SpecFacetDtoImplCopyWithImpl<_$SpecFacetDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecFacetDtoImplToJson(this);
  }
}

abstract class _SpecFacetDto implements SpecFacetDto {
  const factory _SpecFacetDto({
    required final String key,
    required final String label,
    required final List<SpecFacetValueDto> values,
  }) = _$SpecFacetDtoImpl;

  factory _SpecFacetDto.fromJson(Map<String, dynamic> json) =
      _$SpecFacetDtoImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  List<SpecFacetValueDto> get values;

  /// Create a copy of SpecFacetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecFacetDtoImplCopyWith<_$SpecFacetDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceRangeDto _$PriceRangeDtoFromJson(Map<String, dynamic> json) {
  return _PriceRangeDto.fromJson(json);
}

/// @nodoc
mixin _$PriceRangeDto {
  MoneyDto get min => throw _privateConstructorUsedError;
  MoneyDto get max => throw _privateConstructorUsedError;

  /// Serializes this PriceRangeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceRangeDtoCopyWith<PriceRangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceRangeDtoCopyWith<$Res> {
  factory $PriceRangeDtoCopyWith(
    PriceRangeDto value,
    $Res Function(PriceRangeDto) then,
  ) = _$PriceRangeDtoCopyWithImpl<$Res, PriceRangeDto>;
  @useResult
  $Res call({MoneyDto min, MoneyDto max});

  $MoneyDtoCopyWith<$Res> get min;
  $MoneyDtoCopyWith<$Res> get max;
}

/// @nodoc
class _$PriceRangeDtoCopyWithImpl<$Res, $Val extends PriceRangeDto>
    implements $PriceRangeDtoCopyWith<$Res> {
  _$PriceRangeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? min = null, Object? max = null}) {
    return _then(
      _value.copyWith(
            min: null == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
            max: null == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as MoneyDto,
          )
          as $Val,
    );
  }

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get min {
    return $MoneyDtoCopyWith<$Res>(_value.min, (value) {
      return _then(_value.copyWith(min: value) as $Val);
    });
  }

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyDtoCopyWith<$Res> get max {
    return $MoneyDtoCopyWith<$Res>(_value.max, (value) {
      return _then(_value.copyWith(max: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PriceRangeDtoImplCopyWith<$Res>
    implements $PriceRangeDtoCopyWith<$Res> {
  factory _$$PriceRangeDtoImplCopyWith(
    _$PriceRangeDtoImpl value,
    $Res Function(_$PriceRangeDtoImpl) then,
  ) = __$$PriceRangeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MoneyDto min, MoneyDto max});

  @override
  $MoneyDtoCopyWith<$Res> get min;
  @override
  $MoneyDtoCopyWith<$Res> get max;
}

/// @nodoc
class __$$PriceRangeDtoImplCopyWithImpl<$Res>
    extends _$PriceRangeDtoCopyWithImpl<$Res, _$PriceRangeDtoImpl>
    implements _$$PriceRangeDtoImplCopyWith<$Res> {
  __$$PriceRangeDtoImplCopyWithImpl(
    _$PriceRangeDtoImpl _value,
    $Res Function(_$PriceRangeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? min = null, Object? max = null}) {
    return _then(
      _$PriceRangeDtoImpl(
        min: null == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
        max: null == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as MoneyDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceRangeDtoImpl implements _PriceRangeDto {
  const _$PriceRangeDtoImpl({required this.min, required this.max});

  factory _$PriceRangeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceRangeDtoImplFromJson(json);

  @override
  final MoneyDto min;
  @override
  final MoneyDto max;

  @override
  String toString() {
    return 'PriceRangeDto(min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceRangeDtoImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, min, max);

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceRangeDtoImplCopyWith<_$PriceRangeDtoImpl> get copyWith =>
      __$$PriceRangeDtoImplCopyWithImpl<_$PriceRangeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceRangeDtoImplToJson(this);
  }
}

abstract class _PriceRangeDto implements PriceRangeDto {
  const factory _PriceRangeDto({
    required final MoneyDto min,
    required final MoneyDto max,
  }) = _$PriceRangeDtoImpl;

  factory _PriceRangeDto.fromJson(Map<String, dynamic> json) =
      _$PriceRangeDtoImpl.fromJson;

  @override
  MoneyDto get min;
  @override
  MoneyDto get max;

  /// Create a copy of PriceRangeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceRangeDtoImplCopyWith<_$PriceRangeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductFacetsDto _$ProductFacetsDtoFromJson(Map<String, dynamic> json) {
  return _ProductFacetsDto.fromJson(json);
}

/// @nodoc
mixin _$ProductFacetsDto {
  List<TermFacetDto> get categories => throw _privateConstructorUsedError;
  List<TermFacetDto> get brands => throw _privateConstructorUsedError;
  PriceRangeDto? get priceRange => throw _privateConstructorUsedError;
  List<SpecFacetDto> get specs => throw _privateConstructorUsedError;

  /// Serializes this ProductFacetsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductFacetsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductFacetsDtoCopyWith<ProductFacetsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductFacetsDtoCopyWith<$Res> {
  factory $ProductFacetsDtoCopyWith(
    ProductFacetsDto value,
    $Res Function(ProductFacetsDto) then,
  ) = _$ProductFacetsDtoCopyWithImpl<$Res, ProductFacetsDto>;
  @useResult
  $Res call({
    List<TermFacetDto> categories,
    List<TermFacetDto> brands,
    PriceRangeDto? priceRange,
    List<SpecFacetDto> specs,
  });

  $PriceRangeDtoCopyWith<$Res>? get priceRange;
}

/// @nodoc
class _$ProductFacetsDtoCopyWithImpl<$Res, $Val extends ProductFacetsDto>
    implements $ProductFacetsDtoCopyWith<$Res> {
  _$ProductFacetsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductFacetsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? brands = null,
    Object? priceRange = freezed,
    Object? specs = null,
  }) {
    return _then(
      _value.copyWith(
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<TermFacetDto>,
            brands: null == brands
                ? _value.brands
                : brands // ignore: cast_nullable_to_non_nullable
                      as List<TermFacetDto>,
            priceRange: freezed == priceRange
                ? _value.priceRange
                : priceRange // ignore: cast_nullable_to_non_nullable
                      as PriceRangeDto?,
            specs: null == specs
                ? _value.specs
                : specs // ignore: cast_nullable_to_non_nullable
                      as List<SpecFacetDto>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductFacetsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceRangeDtoCopyWith<$Res>? get priceRange {
    if (_value.priceRange == null) {
      return null;
    }

    return $PriceRangeDtoCopyWith<$Res>(_value.priceRange!, (value) {
      return _then(_value.copyWith(priceRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductFacetsDtoImplCopyWith<$Res>
    implements $ProductFacetsDtoCopyWith<$Res> {
  factory _$$ProductFacetsDtoImplCopyWith(
    _$ProductFacetsDtoImpl value,
    $Res Function(_$ProductFacetsDtoImpl) then,
  ) = __$$ProductFacetsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<TermFacetDto> categories,
    List<TermFacetDto> brands,
    PriceRangeDto? priceRange,
    List<SpecFacetDto> specs,
  });

  @override
  $PriceRangeDtoCopyWith<$Res>? get priceRange;
}

/// @nodoc
class __$$ProductFacetsDtoImplCopyWithImpl<$Res>
    extends _$ProductFacetsDtoCopyWithImpl<$Res, _$ProductFacetsDtoImpl>
    implements _$$ProductFacetsDtoImplCopyWith<$Res> {
  __$$ProductFacetsDtoImplCopyWithImpl(
    _$ProductFacetsDtoImpl _value,
    $Res Function(_$ProductFacetsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductFacetsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? brands = null,
    Object? priceRange = freezed,
    Object? specs = null,
  }) {
    return _then(
      _$ProductFacetsDtoImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<TermFacetDto>,
        brands: null == brands
            ? _value._brands
            : brands // ignore: cast_nullable_to_non_nullable
                  as List<TermFacetDto>,
        priceRange: freezed == priceRange
            ? _value.priceRange
            : priceRange // ignore: cast_nullable_to_non_nullable
                  as PriceRangeDto?,
        specs: null == specs
            ? _value._specs
            : specs // ignore: cast_nullable_to_non_nullable
                  as List<SpecFacetDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductFacetsDtoImpl implements _ProductFacetsDto {
  const _$ProductFacetsDtoImpl({
    required final List<TermFacetDto> categories,
    required final List<TermFacetDto> brands,
    this.priceRange,
    required final List<SpecFacetDto> specs,
  }) : _categories = categories,
       _brands = brands,
       _specs = specs;

  factory _$ProductFacetsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductFacetsDtoImplFromJson(json);

  final List<TermFacetDto> _categories;
  @override
  List<TermFacetDto> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<TermFacetDto> _brands;
  @override
  List<TermFacetDto> get brands {
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_brands);
  }

  @override
  final PriceRangeDto? priceRange;
  final List<SpecFacetDto> _specs;
  @override
  List<SpecFacetDto> get specs {
    if (_specs is EqualUnmodifiableListView) return _specs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specs);
  }

  @override
  String toString() {
    return 'ProductFacetsDto(categories: $categories, brands: $brands, priceRange: $priceRange, specs: $specs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductFacetsDtoImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(other._brands, _brands) &&
            (identical(other.priceRange, priceRange) ||
                other.priceRange == priceRange) &&
            const DeepCollectionEquality().equals(other._specs, _specs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_brands),
    priceRange,
    const DeepCollectionEquality().hash(_specs),
  );

  /// Create a copy of ProductFacetsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductFacetsDtoImplCopyWith<_$ProductFacetsDtoImpl> get copyWith =>
      __$$ProductFacetsDtoImplCopyWithImpl<_$ProductFacetsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductFacetsDtoImplToJson(this);
  }
}

abstract class _ProductFacetsDto implements ProductFacetsDto {
  const factory _ProductFacetsDto({
    required final List<TermFacetDto> categories,
    required final List<TermFacetDto> brands,
    final PriceRangeDto? priceRange,
    required final List<SpecFacetDto> specs,
  }) = _$ProductFacetsDtoImpl;

  factory _ProductFacetsDto.fromJson(Map<String, dynamic> json) =
      _$ProductFacetsDtoImpl.fromJson;

  @override
  List<TermFacetDto> get categories;
  @override
  List<TermFacetDto> get brands;
  @override
  PriceRangeDto? get priceRange;
  @override
  List<SpecFacetDto> get specs;

  /// Create a copy of ProductFacetsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductFacetsDtoImplCopyWith<_$ProductFacetsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSuggestionDto _$ProductSuggestionDtoFromJson(Map<String, dynamic> json) {
  return _ProductSuggestionDto.fromJson(json);
}

/// @nodoc
mixin _$ProductSuggestionDto {
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  ProductImageDto? get primaryImage => throw _privateConstructorUsedError;

  /// Serializes this ProductSuggestionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSuggestionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSuggestionDtoCopyWith<ProductSuggestionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSuggestionDtoCopyWith<$Res> {
  factory $ProductSuggestionDtoCopyWith(
    ProductSuggestionDto value,
    $Res Function(ProductSuggestionDto) then,
  ) = _$ProductSuggestionDtoCopyWithImpl<$Res, ProductSuggestionDto>;
  @useResult
  $Res call({
    String slug,
    String name,
    String sku,
    ProductImageDto? primaryImage,
  });

  $ProductImageDtoCopyWith<$Res>? get primaryImage;
}

/// @nodoc
class _$ProductSuggestionDtoCopyWithImpl<
  $Res,
  $Val extends ProductSuggestionDto
>
    implements $ProductSuggestionDtoCopyWith<$Res> {
  _$ProductSuggestionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSuggestionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? sku = null,
    Object? primaryImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String,
            primaryImage: freezed == primaryImage
                ? _value.primaryImage
                : primaryImage // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductSuggestionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get primaryImage {
    if (_value.primaryImage == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.primaryImage!, (value) {
      return _then(_value.copyWith(primaryImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductSuggestionDtoImplCopyWith<$Res>
    implements $ProductSuggestionDtoCopyWith<$Res> {
  factory _$$ProductSuggestionDtoImplCopyWith(
    _$ProductSuggestionDtoImpl value,
    $Res Function(_$ProductSuggestionDtoImpl) then,
  ) = __$$ProductSuggestionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String slug,
    String name,
    String sku,
    ProductImageDto? primaryImage,
  });

  @override
  $ProductImageDtoCopyWith<$Res>? get primaryImage;
}

/// @nodoc
class __$$ProductSuggestionDtoImplCopyWithImpl<$Res>
    extends _$ProductSuggestionDtoCopyWithImpl<$Res, _$ProductSuggestionDtoImpl>
    implements _$$ProductSuggestionDtoImplCopyWith<$Res> {
  __$$ProductSuggestionDtoImplCopyWithImpl(
    _$ProductSuggestionDtoImpl _value,
    $Res Function(_$ProductSuggestionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSuggestionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slug = null,
    Object? name = null,
    Object? sku = null,
    Object? primaryImage = freezed,
  }) {
    return _then(
      _$ProductSuggestionDtoImpl(
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String,
        primaryImage: freezed == primaryImage
            ? _value.primaryImage
            : primaryImage // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSuggestionDtoImpl implements _ProductSuggestionDto {
  const _$ProductSuggestionDtoImpl({
    required this.slug,
    required this.name,
    required this.sku,
    this.primaryImage,
  });

  factory _$ProductSuggestionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSuggestionDtoImplFromJson(json);

  @override
  final String slug;
  @override
  final String name;
  @override
  final String sku;
  @override
  final ProductImageDto? primaryImage;

  @override
  String toString() {
    return 'ProductSuggestionDto(slug: $slug, name: $name, sku: $sku, primaryImage: $primaryImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSuggestionDtoImpl &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.primaryImage, primaryImage) ||
                other.primaryImage == primaryImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, slug, name, sku, primaryImage);

  /// Create a copy of ProductSuggestionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSuggestionDtoImplCopyWith<_$ProductSuggestionDtoImpl>
  get copyWith =>
      __$$ProductSuggestionDtoImplCopyWithImpl<_$ProductSuggestionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSuggestionDtoImplToJson(this);
  }
}

abstract class _ProductSuggestionDto implements ProductSuggestionDto {
  const factory _ProductSuggestionDto({
    required final String slug,
    required final String name,
    required final String sku,
    final ProductImageDto? primaryImage,
  }) = _$ProductSuggestionDtoImpl;

  factory _ProductSuggestionDto.fromJson(Map<String, dynamic> json) =
      _$ProductSuggestionDtoImpl.fromJson;

  @override
  String get slug;
  @override
  String get name;
  @override
  String get sku;
  @override
  ProductImageDto? get primaryImage;

  /// Create a copy of ProductSuggestionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSuggestionDtoImplCopyWith<_$ProductSuggestionDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
