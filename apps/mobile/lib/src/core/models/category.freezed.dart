// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryRefDto _$CategoryRefDtoFromJson(Map<String, dynamic> json) {
  return _CategoryRefDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryRefDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this CategoryRefDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryRefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryRefDtoCopyWith<CategoryRefDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryRefDtoCopyWith<$Res> {
  factory $CategoryRefDtoCopyWith(
    CategoryRefDto value,
    $Res Function(CategoryRefDto) then,
  ) = _$CategoryRefDtoCopyWithImpl<$Res, CategoryRefDto>;
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class _$CategoryRefDtoCopyWithImpl<$Res, $Val extends CategoryRefDto>
    implements $CategoryRefDtoCopyWith<$Res> {
  _$CategoryRefDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryRefDto
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
abstract class _$$CategoryRefDtoImplCopyWith<$Res>
    implements $CategoryRefDtoCopyWith<$Res> {
  factory _$$CategoryRefDtoImplCopyWith(
    _$CategoryRefDtoImpl value,
    $Res Function(_$CategoryRefDtoImpl) then,
  ) = __$$CategoryRefDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class __$$CategoryRefDtoImplCopyWithImpl<$Res>
    extends _$CategoryRefDtoCopyWithImpl<$Res, _$CategoryRefDtoImpl>
    implements _$$CategoryRefDtoImplCopyWith<$Res> {
  __$$CategoryRefDtoImplCopyWithImpl(
    _$CategoryRefDtoImpl _value,
    $Res Function(_$CategoryRefDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryRefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? slug = null, Object? name = null}) {
    return _then(
      _$CategoryRefDtoImpl(
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
class _$CategoryRefDtoImpl implements _CategoryRefDto {
  const _$CategoryRefDtoImpl({
    required this.id,
    required this.slug,
    required this.name,
  });

  factory _$CategoryRefDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryRefDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'CategoryRefDto(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryRefDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  /// Create a copy of CategoryRefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryRefDtoImplCopyWith<_$CategoryRefDtoImpl> get copyWith =>
      __$$CategoryRefDtoImplCopyWithImpl<_$CategoryRefDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryRefDtoImplToJson(this);
  }
}

abstract class _CategoryRefDto implements CategoryRefDto {
  const factory _CategoryRefDto({
    required final String id,
    required final String slug,
    required final String name,
  }) = _$CategoryRefDtoImpl;

  factory _CategoryRefDto.fromJson(Map<String, dynamic> json) =
      _$CategoryRefDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;

  /// Create a copy of CategoryRefDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryRefDtoImplCopyWith<_$CategoryRefDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) {
  return _CategoryDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description =>
      throw _privateConstructorUsedError; // Live API returns null for root categories despite the spec marking
  // this required (D-13).
  String? get parentId => throw _privateConstructorUsedError;
  int get depth => throw _privateConstructorUsedError;
  ProductImageDto? get image => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CategoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDtoCopyWith<CategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDtoCopyWith<$Res> {
  factory $CategoryDtoCopyWith(
    CategoryDto value,
    $Res Function(CategoryDto) then,
  ) = _$CategoryDtoCopyWithImpl<$Res, CategoryDto>;
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String description,
    String? parentId,
    int depth,
    ProductImageDto? image,
    int productCount,
    int sortOrder,
  });

  $ProductImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class _$CategoryDtoCopyWithImpl<$Res, $Val extends CategoryDto>
    implements $CategoryDtoCopyWith<$Res> {
  _$CategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = null,
    Object? parentId = freezed,
    Object? depth = null,
    Object? image = freezed,
    Object? productCount = null,
    Object? sortOrder = null,
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
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            depth: null == depth
                ? _value.depth
                : depth // ignore: cast_nullable_to_non_nullable
                      as int,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
            productCount: null == productCount
                ? _value.productCount
                : productCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryDtoImplCopyWith<$Res>
    implements $CategoryDtoCopyWith<$Res> {
  factory _$$CategoryDtoImplCopyWith(
    _$CategoryDtoImpl value,
    $Res Function(_$CategoryDtoImpl) then,
  ) = __$$CategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String description,
    String? parentId,
    int depth,
    ProductImageDto? image,
    int productCount,
    int sortOrder,
  });

  @override
  $ProductImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class __$$CategoryDtoImplCopyWithImpl<$Res>
    extends _$CategoryDtoCopyWithImpl<$Res, _$CategoryDtoImpl>
    implements _$$CategoryDtoImplCopyWith<$Res> {
  __$$CategoryDtoImplCopyWithImpl(
    _$CategoryDtoImpl _value,
    $Res Function(_$CategoryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = null,
    Object? parentId = freezed,
    Object? depth = null,
    Object? image = freezed,
    Object? productCount = null,
    Object? sortOrder = null,
  }) {
    return _then(
      _$CategoryDtoImpl(
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
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        depth: null == depth
            ? _value.depth
            : depth // ignore: cast_nullable_to_non_nullable
                  as int,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
        productCount: null == productCount
            ? _value.productCount
            : productCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDtoImpl implements _CategoryDto {
  const _$CategoryDtoImpl({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    this.parentId,
    required this.depth,
    this.image,
    required this.productCount,
    required this.sortOrder,
  });

  factory _$CategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String description;
  // Live API returns null for root categories despite the spec marking
  // this required (D-13).
  @override
  final String? parentId;
  @override
  final int depth;
  @override
  final ProductImageDto? image;
  @override
  final int productCount;
  @override
  final int sortOrder;

  @override
  String toString() {
    return 'CategoryDto(id: $id, slug: $slug, name: $name, description: $description, parentId: $parentId, depth: $depth, image: $image, productCount: $productCount, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    slug,
    name,
    description,
    parentId,
    depth,
    image,
    productCount,
    sortOrder,
  );

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDtoImplCopyWith<_$CategoryDtoImpl> get copyWith =>
      __$$CategoryDtoImplCopyWithImpl<_$CategoryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDtoImplToJson(this);
  }
}

abstract class _CategoryDto implements CategoryDto {
  const factory _CategoryDto({
    required final String id,
    required final String slug,
    required final String name,
    required final String description,
    final String? parentId,
    required final int depth,
    final ProductImageDto? image,
    required final int productCount,
    required final int sortOrder,
  }) = _$CategoryDtoImpl;

  factory _CategoryDto.fromJson(Map<String, dynamic> json) =
      _$CategoryDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  String get description; // Live API returns null for root categories despite the spec marking
  // this required (D-13).
  @override
  String? get parentId;
  @override
  int get depth;
  @override
  ProductImageDto? get image;
  @override
  int get productCount;
  @override
  int get sortOrder;

  /// Create a copy of CategoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDtoImplCopyWith<_$CategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryDetailDto _$CategoryDetailDtoFromJson(Map<String, dynamic> json) {
  return _CategoryDetailDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  int get depth => throw _privateConstructorUsedError;
  ProductImageDto? get image => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  List<CategoryDto> get breadcrumb => throw _privateConstructorUsedError;

  /// Serializes this CategoryDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDetailDtoCopyWith<CategoryDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDetailDtoCopyWith<$Res> {
  factory $CategoryDetailDtoCopyWith(
    CategoryDetailDto value,
    $Res Function(CategoryDetailDto) then,
  ) = _$CategoryDetailDtoCopyWithImpl<$Res, CategoryDetailDto>;
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String description,
    String? parentId,
    int depth,
    ProductImageDto? image,
    int productCount,
    int sortOrder,
    List<CategoryDto> breadcrumb,
  });

  $ProductImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class _$CategoryDetailDtoCopyWithImpl<$Res, $Val extends CategoryDetailDto>
    implements $CategoryDetailDtoCopyWith<$Res> {
  _$CategoryDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = null,
    Object? parentId = freezed,
    Object? depth = null,
    Object? image = freezed,
    Object? productCount = null,
    Object? sortOrder = null,
    Object? breadcrumb = null,
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
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            depth: null == depth
                ? _value.depth
                : depth // ignore: cast_nullable_to_non_nullable
                      as int,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
            productCount: null == productCount
                ? _value.productCount
                : productCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            breadcrumb: null == breadcrumb
                ? _value.breadcrumb
                : breadcrumb // ignore: cast_nullable_to_non_nullable
                      as List<CategoryDto>,
          )
          as $Val,
    );
  }

  /// Create a copy of CategoryDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryDetailDtoImplCopyWith<$Res>
    implements $CategoryDetailDtoCopyWith<$Res> {
  factory _$$CategoryDetailDtoImplCopyWith(
    _$CategoryDetailDtoImpl value,
    $Res Function(_$CategoryDetailDtoImpl) then,
  ) = __$$CategoryDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String description,
    String? parentId,
    int depth,
    ProductImageDto? image,
    int productCount,
    int sortOrder,
    List<CategoryDto> breadcrumb,
  });

  @override
  $ProductImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class __$$CategoryDetailDtoImplCopyWithImpl<$Res>
    extends _$CategoryDetailDtoCopyWithImpl<$Res, _$CategoryDetailDtoImpl>
    implements _$$CategoryDetailDtoImplCopyWith<$Res> {
  __$$CategoryDetailDtoImplCopyWithImpl(
    _$CategoryDetailDtoImpl _value,
    $Res Function(_$CategoryDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = null,
    Object? parentId = freezed,
    Object? depth = null,
    Object? image = freezed,
    Object? productCount = null,
    Object? sortOrder = null,
    Object? breadcrumb = null,
  }) {
    return _then(
      _$CategoryDetailDtoImpl(
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
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        depth: null == depth
            ? _value.depth
            : depth // ignore: cast_nullable_to_non_nullable
                  as int,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
        productCount: null == productCount
            ? _value.productCount
            : productCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        breadcrumb: null == breadcrumb
            ? _value._breadcrumb
            : breadcrumb // ignore: cast_nullable_to_non_nullable
                  as List<CategoryDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDetailDtoImpl implements _CategoryDetailDto {
  const _$CategoryDetailDtoImpl({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    this.parentId,
    required this.depth,
    this.image,
    required this.productCount,
    required this.sortOrder,
    required final List<CategoryDto> breadcrumb,
  }) : _breadcrumb = breadcrumb;

  factory _$CategoryDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? parentId;
  @override
  final int depth;
  @override
  final ProductImageDto? image;
  @override
  final int productCount;
  @override
  final int sortOrder;
  final List<CategoryDto> _breadcrumb;
  @override
  List<CategoryDto> get breadcrumb {
    if (_breadcrumb is EqualUnmodifiableListView) return _breadcrumb;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breadcrumb);
  }

  @override
  String toString() {
    return 'CategoryDetailDto(id: $id, slug: $slug, name: $name, description: $description, parentId: $parentId, depth: $depth, image: $image, productCount: $productCount, sortOrder: $sortOrder, breadcrumb: $breadcrumb)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(
              other._breadcrumb,
              _breadcrumb,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    slug,
    name,
    description,
    parentId,
    depth,
    image,
    productCount,
    sortOrder,
    const DeepCollectionEquality().hash(_breadcrumb),
  );

  /// Create a copy of CategoryDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDetailDtoImplCopyWith<_$CategoryDetailDtoImpl> get copyWith =>
      __$$CategoryDetailDtoImplCopyWithImpl<_$CategoryDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDetailDtoImplToJson(this);
  }
}

abstract class _CategoryDetailDto implements CategoryDetailDto {
  const factory _CategoryDetailDto({
    required final String id,
    required final String slug,
    required final String name,
    required final String description,
    final String? parentId,
    required final int depth,
    final ProductImageDto? image,
    required final int productCount,
    required final int sortOrder,
    required final List<CategoryDto> breadcrumb,
  }) = _$CategoryDetailDtoImpl;

  factory _CategoryDetailDto.fromJson(Map<String, dynamic> json) =
      _$CategoryDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get parentId;
  @override
  int get depth;
  @override
  ProductImageDto? get image;
  @override
  int get productCount;
  @override
  int get sortOrder;
  @override
  List<CategoryDto> get breadcrumb;

  /// Create a copy of CategoryDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDetailDtoImplCopyWith<_$CategoryDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryTreeNodeDto _$CategoryTreeNodeDtoFromJson(Map<String, dynamic> json) {
  return _CategoryTreeNodeDto.fromJson(json);
}

/// @nodoc
mixin _$CategoryTreeNodeDto {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  int get depth => throw _privateConstructorUsedError;
  ProductImageDto? get image => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  List<CategoryTreeNodeDto> get children => throw _privateConstructorUsedError;

  /// Serializes this CategoryTreeNodeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryTreeNodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryTreeNodeDtoCopyWith<CategoryTreeNodeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryTreeNodeDtoCopyWith<$Res> {
  factory $CategoryTreeNodeDtoCopyWith(
    CategoryTreeNodeDto value,
    $Res Function(CategoryTreeNodeDto) then,
  ) = _$CategoryTreeNodeDtoCopyWithImpl<$Res, CategoryTreeNodeDto>;
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String? description,
    String? parentId,
    int depth,
    ProductImageDto? image,
    int productCount,
    int sortOrder,
    List<CategoryTreeNodeDto> children,
  });

  $ProductImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class _$CategoryTreeNodeDtoCopyWithImpl<$Res, $Val extends CategoryTreeNodeDto>
    implements $CategoryTreeNodeDtoCopyWith<$Res> {
  _$CategoryTreeNodeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryTreeNodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = freezed,
    Object? parentId = freezed,
    Object? depth = null,
    Object? image = freezed,
    Object? productCount = null,
    Object? sortOrder = null,
    Object? children = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            depth: null == depth
                ? _value.depth
                : depth // ignore: cast_nullable_to_non_nullable
                      as int,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as ProductImageDto?,
            productCount: null == productCount
                ? _value.productCount
                : productCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<CategoryTreeNodeDto>,
          )
          as $Val,
    );
  }

  /// Create a copy of CategoryTreeNodeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductImageDtoCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $ProductImageDtoCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryTreeNodeDtoImplCopyWith<$Res>
    implements $CategoryTreeNodeDtoCopyWith<$Res> {
  factory _$$CategoryTreeNodeDtoImplCopyWith(
    _$CategoryTreeNodeDtoImpl value,
    $Res Function(_$CategoryTreeNodeDtoImpl) then,
  ) = __$$CategoryTreeNodeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String slug,
    String name,
    String? description,
    String? parentId,
    int depth,
    ProductImageDto? image,
    int productCount,
    int sortOrder,
    List<CategoryTreeNodeDto> children,
  });

  @override
  $ProductImageDtoCopyWith<$Res>? get image;
}

/// @nodoc
class __$$CategoryTreeNodeDtoImplCopyWithImpl<$Res>
    extends _$CategoryTreeNodeDtoCopyWithImpl<$Res, _$CategoryTreeNodeDtoImpl>
    implements _$$CategoryTreeNodeDtoImplCopyWith<$Res> {
  __$$CategoryTreeNodeDtoImplCopyWithImpl(
    _$CategoryTreeNodeDtoImpl _value,
    $Res Function(_$CategoryTreeNodeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryTreeNodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
    Object? description = freezed,
    Object? parentId = freezed,
    Object? depth = null,
    Object? image = freezed,
    Object? productCount = null,
    Object? sortOrder = null,
    Object? children = null,
  }) {
    return _then(
      _$CategoryTreeNodeDtoImpl(
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        depth: null == depth
            ? _value.depth
            : depth // ignore: cast_nullable_to_non_nullable
                  as int,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as ProductImageDto?,
        productCount: null == productCount
            ? _value.productCount
            : productCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<CategoryTreeNodeDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryTreeNodeDtoImpl implements _CategoryTreeNodeDto {
  const _$CategoryTreeNodeDtoImpl({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.parentId,
    required this.depth,
    this.image,
    required this.productCount,
    required this.sortOrder,
    required final List<CategoryTreeNodeDto> children,
  }) : _children = children;

  factory _$CategoryTreeNodeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryTreeNodeDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? parentId;
  @override
  final int depth;
  @override
  final ProductImageDto? image;
  @override
  final int productCount;
  @override
  final int sortOrder;
  final List<CategoryTreeNodeDto> _children;
  @override
  List<CategoryTreeNodeDto> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'CategoryTreeNodeDto(id: $id, slug: $slug, name: $name, description: $description, parentId: $parentId, depth: $depth, image: $image, productCount: $productCount, sortOrder: $sortOrder, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryTreeNodeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    slug,
    name,
    description,
    parentId,
    depth,
    image,
    productCount,
    sortOrder,
    const DeepCollectionEquality().hash(_children),
  );

  /// Create a copy of CategoryTreeNodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryTreeNodeDtoImplCopyWith<_$CategoryTreeNodeDtoImpl> get copyWith =>
      __$$CategoryTreeNodeDtoImplCopyWithImpl<_$CategoryTreeNodeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryTreeNodeDtoImplToJson(this);
  }
}

abstract class _CategoryTreeNodeDto implements CategoryTreeNodeDto {
  const factory _CategoryTreeNodeDto({
    required final String id,
    required final String slug,
    required final String name,
    final String? description,
    final String? parentId,
    required final int depth,
    final ProductImageDto? image,
    required final int productCount,
    required final int sortOrder,
    required final List<CategoryTreeNodeDto> children,
  }) = _$CategoryTreeNodeDtoImpl;

  factory _CategoryTreeNodeDto.fromJson(Map<String, dynamic> json) =
      _$CategoryTreeNodeDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get parentId;
  @override
  int get depth;
  @override
  ProductImageDto? get image;
  @override
  int get productCount;
  @override
  int get sortOrder;
  @override
  List<CategoryTreeNodeDto> get children;

  /// Create a copy of CategoryTreeNodeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryTreeNodeDtoImplCopyWith<_$CategoryTreeNodeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
