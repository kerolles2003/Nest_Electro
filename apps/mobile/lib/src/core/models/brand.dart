import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/product.dart';

part 'brand.freezed.dart';
part 'brand.g.dart';

@freezed
class BrandRefDto with _$BrandRefDto {
  const factory BrandRefDto({
    required String id,
    required String slug,
    required String name,
  }) = _BrandRefDto;

  factory BrandRefDto.fromJson(Map<String, dynamic> json) =>
      _$BrandRefDtoFromJson(json);
}

@freezed
class BrandDto with _$BrandDto {
  const factory BrandDto({
    required String id,
    required String slug,
    required String name,
    required String description,
    ProductImageDto? logo,
    required String website,
    required int productCount,
  }) = _BrandDto;

  factory BrandDto.fromJson(Map<String, dynamic> json) =>
      _$BrandDtoFromJson(json);
}
