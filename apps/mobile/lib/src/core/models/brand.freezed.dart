// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BrandRefDto _$BrandRefDtoFromJson(Map<String, dynamic> json) {
  return _BrandRefDto.fromJson(json);
}

/// @nodoc
mixin _$BrandRefDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this BrandRefDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrandRefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandRefDtoCopyWith<BrandRefDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandRefDtoCopyWith<$Res> {
  factory $BrandRefDtoCopyWith(
    BrandRefDto value,
    $Res Function(BrandRefDto) then,
  ) = _$BrandRefDtoCopyWithImpl<$Res, BrandRefDto>;
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class _$BrandRefDtoCopyWithImpl<$Res, $Val extends BrandRefDto>
    implements $BrandRefDtoCopyWith<$Res> {
  _$BrandRefDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrandRefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? slug = null, Object? name = null}) {
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
abstract class _$$BrandRefDtoImplCopyWith<$Res>
    implements $BrandRefDtoCopyWith<$Res> {
  factory _$$BrandRefDtoImplCopyWith(
    _$BrandRefDtoImpl value,
    $Res Function(_$BrandRefDtoImpl) then,
  ) = __$$BrandRefDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class __$$BrandRefDtoImplCopyWithImpl<$Res>
    extends _$BrandRefDtoCopyWithImpl<$Res, _$BrandRefDtoImpl>
    implements _$$BrandRefDtoImplCopyWith<$Res> {
  __$$BrandRefDtoImplCopyWithImpl(
    _$BrandRefDtoImpl _value,
    $Res Function(_$BrandRefDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BrandRefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? slug = null, Object? name = null}) {
    return _then(
      _$BrandRefDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$BrandRefDtoImpl implements _BrandRefDto {
  const _$BrandRefDtoImpl({
    required this.id,
    required this.slug,
    required this.name,
  });

  factory _$BrandRefDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandRefDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'BrandRefDto(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandRefDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  /// Create a copy of BrandRefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandRefDtoImplCopyWith<_$BrandRefDtoImpl> get copyWith =>
      __$$BrandRefDtoImplCopyWithImpl<_$BrandRefDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandRefDtoImplToJson(this);
  }
}

abstract class _BrandRefDto implements BrandRefDto {
  const factory _BrandRefDto({
    required final String id,
    required final String slug,
    required final String name,
  }) = _$BrandRefDtoImpl;

  factory _BrandRefDto.fromJson(Map<String, dynamic> json) =
      _$BrandRefDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;

  /// Create a copy of BrandRefDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandRefDtoImplCopyWith<_$BrandRefDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BrandDto _$BrandDtoFromJson(Map<String, dynamic> json) {
  return _BrandDto.fromJson(json);
}

/// @nodoc
mixin _$BrandDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ProductImageDto? get logo => throw _privateConstructorUsedError;
  String get website => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;

  /// Serializes this BrandDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrandDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandDtoCopyWith<BrandDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandDtoCopyWith<$Res> {
  factory $BrandDtoCopyWith(BrandDto value, $Res Function(BrandDto) then) =
      _$BrandDtoCopyWithImpl<$Res, BrandDto>;
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String description,
    ProductImageDto? logo,
    String website,
    int productCount,
  });

  $ProductImageDtoCopyWith<$Res>? get logo;
}

/// @nodoc
class _$BrandDtoCopyWithImpl<$Res, $Val extends BrandDto>
    implements $BrandDtoCopyWith<$Res> {
  _$BrandDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrandDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = null,
    Object? logo = freezed,
    Object? website = null,
    Object? productCount = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            logo: freezed == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
            website: null == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String,
            productCount: null == productCount
                ? _value.productCount
                : productCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of BrandDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get logo {
    if (_value.logo == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.logo!, (value) {
      return _then(_value.copyWith(logo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BrandDtoImplCopyWith<$Res>
    implements $BrandDtoCopyWith<$Res> {
  factory _$$BrandDtoImplCopyWith(
    _$BrandDtoImpl value,
    $Res Function(_$BrandDtoImpl) then,
  ) = __$$BrandDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String description,
    ProductImageDto? logo,
    String website,
    int productCount,
  });

  @override
  $ProductImageDtoCopyWith<$Res>? get logo;
}

/// @nodoc
class __$$BrandDtoImplCopyWithImpl<$Res>
    extends _$BrandDtoCopyWithImpl<$Res, _$BrandDtoImpl>
    implements _$$BrandDtoImplCopyWith<$Res> {
  __$$BrandDtoImplCopyWithImpl(
    _$BrandDtoImpl _value,
    $Res Function(_$BrandDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BrandDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = null,
    Object? logo = freezed,
    Object? website = null,
    Object? productCount = null,
  }) {
    return _then(
      _$BrandDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        logo: freezed == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
        website: null == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String,
        productCount: null == productCount
            ? _value.productCount
            : productCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BrandDtoImpl implements _BrandDto {
  const _$BrandDtoImpl({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    this.logo,
    required this.website,
    required this.productCount,
  });

  factory _$BrandDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String description;
  @override
  final ProductImageDto? logo;
  @override
  final String website;
  @override
  final int productCount;

  @override
  String toString() {
    return 'BrandDto(id: $id, slug: $slug, name: $name, description: $description, logo: $logo, website: $website, productCount: $productCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    slug,
    name,
    description,
    logo,
    website,
    productCount,
  );

  /// Create a copy of BrandDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandDtoImplCopyWith<_$BrandDtoImpl> get copyWith =>
      __$$BrandDtoImplCopyWithImpl<_$BrandDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandDtoImplToJson(this);
  }
}

abstract class _BrandDto implements BrandDto {
  const factory _BrandDto({
    required final String id,
    required final String slug,
    required final String name,
    required final String description,
    final ProductImageDto? logo,
    required final String website,
    required final int productCount,
  }) = _$BrandDtoImpl;

  factory _BrandDto.fromJson(Map<String, dynamic> json) =
      _$BrandDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  String get description;
  @override
  ProductImageDto? get logo;
  @override
  String get website;
  @override
  int get productCount;

  /// Create a copy of BrandDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandDtoImplCopyWith<_$BrandDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
