import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/money.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class ProductImageDto with _$ProductImageDto {
  const factory ProductImageDto({
    required String publicId,
    required int version,
    required String format,
    required int width,
    required int height,
    required String alt,
  }) = _ProductImageDto;

  factory ProductImageDto.fromJson(Map<String, dynamic> json) =>
      _$ProductImageDtoFromJson(json);
}

@freezed
class ProductPricingDto with _$ProductPricingDto {
  const factory ProductPricingDto({
    required MoneyDto basePrice,
    MoneyDto? salePrice,
    // "salePrice ?? basePrice. THE price charged at checkout. Never compute
    // this client-side." (OpenAPI description)
    required MoneyDto effectivePrice,
    required int discountPercentBps,
  }) = _ProductPricingDto;

  factory ProductPricingDto.fromJson(Map<String, dynamic> json) =>
      _$ProductPricingDtoFromJson(json);
}

@freezed
class ProductRatingDto with _$ProductRatingDto {
  const factory ProductRatingDto({
    required double average,
    required int count,
  }) = _ProductRatingDto;

  factory ProductRatingDto.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingDtoFromJson(json);
}

@freezed
class ProductSpecDto with _$ProductSpecDto {
  const factory ProductSpecDto({
    required String key,
    required String label,
    required String value,
    String? unit,
    required bool filterable,
  }) = _ProductSpecDto;

  factory ProductSpecDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecDtoFromJson(json);
}

@freezed
class ProductListItemDto with _$ProductListItemDto {
  const factory ProductListItemDto({
    required String id,
    required String slug,
    required String sku,
    required String name,
    required String shortDescription,
    required CategoryRefDto category,
    // Null for most live products — always render without one.
    BrandRefDto? brand,
    required ProductPricingDto pricing,
    ProductImageDto? primaryImage,
    required ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown)
    required Availability availability,
    required bool isFeatured,
  }) = _ProductListItemDto;

  factory ProductListItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProductListItemDtoFromJson(json);
}

@freezed
class ProductDetailDto with _$ProductDetailDto {
  const factory ProductDetailDto({
    required String id,
    required String slug,
    required String sku,
    required String name,
    required String shortDescription,
    required CategoryRefDto category,
    BrandRefDto? brand,
    required ProductPricingDto pricing,
    ProductImageDto? primaryImage,
    required ProductRatingDto rating,
    @JsonKey(unknownEnumValue: Availability.unknown)
    required Availability availability,
    required bool isFeatured,
    required String description,
    required List<ProductImageDto> images,
    required List<ProductSpecDto> specs,
    required int stockOnHand,
    required int salesCount,
    required double weight,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProductDetailDto;

  factory ProductDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailDtoFromJson(json);
}

@freezed
class TermFacetDto with _$TermFacetDto {
  const factory TermFacetDto({
    required String slug,
    required String name,
    required int count,
  }) = _TermFacetDto;

  factory TermFacetDto.fromJson(Map<String, dynamic> json) =>
      _$TermFacetDtoFromJson(json);
}

@freezed
class SpecFacetValueDto with _$SpecFacetValueDto {
  const factory SpecFacetValueDto({
    required String value,
    required int count,
  }) = _SpecFacetValueDto;

  factory SpecFacetValueDto.fromJson(Map<String, dynamic> json) =>
      _$SpecFacetValueDtoFromJson(json);
}

@freezed
class SpecFacetDto with _$SpecFacetDto {
  const factory SpecFacetDto({
    required String key,
    required String label,
    required List<SpecFacetValueDto> values,
  }) = _SpecFacetDto;

  factory SpecFacetDto.fromJson(Map<String, dynamic> json) =>
      _$SpecFacetDtoFromJson(json);
}

@freezed
class PriceRangeDto with _$PriceRangeDto {
  const factory PriceRangeDto({
    required MoneyDto min,
    required MoneyDto max,
  }) = _PriceRangeDto;

  factory PriceRangeDto.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeDtoFromJson(json);
}

@freezed
class ProductFacetsDto with _$ProductFacetsDto {
  const factory ProductFacetsDto({
    required List<TermFacetDto> categories,
    required List<TermFacetDto> brands,
    PriceRangeDto? priceRange,
    required List<SpecFacetDto> specs,
  }) = _ProductFacetsDto;

  factory ProductFacetsDto.fromJson(Map<String, dynamic> json) =>
      _$ProductFacetsDtoFromJson(json);
}

@freezed
class ProductSuggestionDto with _$ProductSuggestionDto {
  const factory ProductSuggestionDto({
    required String slug,
    required String name,
    required String sku,
    ProductImageDto? primaryImage,
  }) = _ProductSuggestionDto;

  factory ProductSuggestionDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSuggestionDtoFromJson(json);
}
