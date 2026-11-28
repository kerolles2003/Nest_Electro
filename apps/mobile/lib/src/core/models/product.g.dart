// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImageDtoImpl _$$ProductImageDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductImageDtoImpl(
  publicId: json['publicId'] as String,
  version: (json['version'] as num).toInt(),
  format: json['format'] as String,
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  alt: json['alt'] as String,
);

Map<String, dynamic> _$$ProductImageDtoImplToJson(
  _$ProductImageDtoImpl instance,
) => <String, dynamic>{
  'publicId': instance.publicId,
  'version': instance.version,
  'format': instance.format,
  'width': instance.width,
  'height': instance.height,
  'alt': instance.alt,
};

_$ProductPricingDtoImpl _$$ProductPricingDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductPricingDtoImpl(
  basePrice: MoneyDto.fromJson(json['basePrice'] as Map<String, dynamic>),
  salePrice: json['salePrice'] == null
      ? null
      : MoneyDto.fromJson(json['salePrice'] as Map<String, dynamic>),
  effectivePrice: MoneyDto.fromJson(
    json['effectivePrice'] as Map<String, dynamic>,
  ),
  discountPercentBps: (json['discountPercentBps'] as num).toInt(),
);

Map<String, dynamic> _$$ProductPricingDtoImplToJson(
  _$ProductPricingDtoImpl instance,
) => <String, dynamic>{
  'basePrice': instance.basePrice,
  'salePrice': instance.salePrice,
  'effectivePrice': instance.effectivePrice,
  'discountPercentBps': instance.discountPercentBps,
};

_$ProductRatingDtoImpl _$$ProductRatingDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductRatingDtoImpl(
  average: (json['average'] as num).toDouble(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$ProductRatingDtoImplToJson(
  _$ProductRatingDtoImpl instance,
) => <String, dynamic>{'average': instance.average, 'count': instance.count};

_$ProductSpecDtoImpl _$$ProductSpecDtoImplFromJson(Map<String, dynamic> json) =>
    _$ProductSpecDtoImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      unit: json['unit'] as String?,
      filterable: json['filterable'] as bool,
    );

Map<String, dynamic> _$$ProductSpecDtoImplToJson(
  _$ProductSpecDtoImpl instance,
) => <String, dynamic>{
  'key': instance.key,
  'label': instance.label,
  'value': instance.value,
  'unit': instance.unit,
  'filterable': instance.filterable,
};

_$ProductListItemDtoImpl _$$ProductListItemDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductListItemDtoImpl(
  id: json['id'] as String,
  slug: json['slug'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  shortDescription: json['shortDescription'] as String,
  category: CategoryRefDto.fromJson(json['category'] as Map<String, dynamic>),
  brand: json['brand'] == null
      ? null
      : BrandRefDto.fromJson(json['brand'] as Map<String, dynamic>),
  pricing: ProductPricingDto.fromJson(json['pricing'] as Map<String, dynamic>),
  primaryImage: json['primaryImage'] == null
      ? null
      : ProductImageDto.fromJson(json['primaryImage'] as Map<String, dynamic>),
  rating: ProductRatingDto.fromJson(json['rating'] as Map<String, dynamic>),
  availability: $enumDecode(
    _$AvailabilityEnumMap,
    json['availability'],
    unknownValue: Availability.unknown,
  ),
  isFeatured: json['isFeatured'] as bool,
);

Map<String, dynamic> _$$ProductListItemDtoImplToJson(
  _$ProductListItemDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'sku': instance.sku,
  'name': instance.name,
  'shortDescription': instance.shortDescription,
  'category': instance.category,
  'brand': instance.brand,
  'pricing': instance.pricing,
  'primaryImage': instance.primaryImage,
  'rating': instance.rating,
  'availability': _$AvailabilityEnumMap[instance.availability]!,
  'isFeatured': instance.isFeatured,
};

const _$AvailabilityEnumMap = {
  Availability.inStock: 'IN_STOCK',
  Availability.lowStock: 'LOW_STOCK',
  Availability.outOfStock: 'OUT_OF_STOCK',
  Availability.unknown: 'unknown',
};

_$ProductDetailDtoImpl _$$ProductDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductDetailDtoImpl(
  id: json['id'] as String,
  slug: json['slug'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  shortDescription: json['shortDescription'] as String,
  category: CategoryRefDto.fromJson(json['category'] as Map<String, dynamic>),
  brand: json['brand'] == null
      ? null
      : BrandRefDto.fromJson(json['brand'] as Map<String, dynamic>),
  pricing: ProductPricingDto.fromJson(json['pricing'] as Map<String, dynamic>),
  primaryImage: json['primaryImage'] == null
      ? null
      : ProductImageDto.fromJson(json['primaryImage'] as Map<String, dynamic>),
  rating: ProductRatingDto.fromJson(json['rating'] as Map<String, dynamic>),
  availability: $enumDecode(
    _$AvailabilityEnumMap,
    json['availability'],
    unknownValue: Availability.unknown,
  ),
  isFeatured: json['isFeatured'] as bool,
  description: json['description'] as String,
  images: (json['images'] as List<dynamic>)
      .map((e) => ProductImageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  specs: (json['specs'] as List<dynamic>)
      .map((e) => ProductSpecDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  stockOnHand: (json['stockOnHand'] as num).toInt(),
  salesCount: (json['salesCount'] as num).toInt(),
  weight: (json['weight'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ProductDetailDtoImplToJson(
  _$ProductDetailDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'sku': instance.sku,
  'name': instance.name,
  'shortDescription': instance.shortDescription,
  'category': instance.category,
  'brand': instance.brand,
  'pricing': instance.pricing,
  'primaryImage': instance.primaryImage,
  'rating': instance.rating,
  'availability': _$AvailabilityEnumMap[instance.availability]!,
  'isFeatured': instance.isFeatured,
  'description': instance.description,
  'images': instance.images,
  'specs': instance.specs,
  'stockOnHand': instance.stockOnHand,
  'salesCount': instance.salesCount,
  'weight': instance.weight,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$TermFacetDtoImpl _$$TermFacetDtoImplFromJson(Map<String, dynamic> json) =>
    _$TermFacetDtoImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$TermFacetDtoImplToJson(_$TermFacetDtoImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'count': instance.count,
    };

_$SpecFacetValueDtoImpl _$$SpecFacetValueDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SpecFacetValueDtoImpl(
  value: json['value'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$SpecFacetValueDtoImplToJson(
  _$SpecFacetValueDtoImpl instance,
) => <String, dynamic>{'value': instance.value, 'count': instance.count};

_$SpecFacetDtoImpl _$$SpecFacetDtoImplFromJson(Map<String, dynamic> json) =>
    _$SpecFacetDtoImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => SpecFacetValueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SpecFacetDtoImplToJson(_$SpecFacetDtoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'values': instance.values,
    };

_$PriceRangeDtoImpl _$$PriceRangeDtoImplFromJson(Map<String, dynamic> json) =>
    _$PriceRangeDtoImpl(
      min: MoneyDto.fromJson(json['min'] as Map<String, dynamic>),
      max: MoneyDto.fromJson(json['max'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PriceRangeDtoImplToJson(_$PriceRangeDtoImpl instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

_$ProductFacetsDtoImpl _$$ProductFacetsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductFacetsDtoImpl(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => TermFacetDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  brands: (json['brands'] as List<dynamic>)
      .map((e) => TermFacetDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  priceRange: json['priceRange'] == null
      ? null
      : PriceRangeDto.fromJson(json['priceRange'] as Map<String, dynamic>),
  specs: (json['specs'] as List<dynamic>)
      .map((e) => SpecFacetDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ProductFacetsDtoImplToJson(
  _$ProductFacetsDtoImpl instance,
) => <String, dynamic>{
  'categories': instance.categories,
  'brands': instance.brands,
  'priceRange': instance.priceRange,
  'specs': instance.specs,
};

_$ProductSuggestionDtoImpl _$$ProductSuggestionDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ProductSuggestionDtoImpl(
  slug: json['slug'] as String,
  name: json['name'] as String,
  sku: json['sku'] as String,
  primaryImage: json['primaryImage'] == null
      ? null
      : ProductImageDto.fromJson(json['primaryImage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ProductSuggestionDtoImplToJson(
  _$ProductSuggestionDtoImpl instance,
) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
  'sku': instance.sku,
  'primaryImage': instance.primaryImage,
};
