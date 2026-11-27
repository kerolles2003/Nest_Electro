import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/product.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class CategoryRefDto with _$CategoryRefDto {
  const factory CategoryRefDto({
    required String id,
    required String slug,
    required String name,
  }) = _CategoryRefDto;

  factory CategoryRefDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryRefDtoFromJson(json);
}

@freezed
class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required String id,
    required String slug,
    required String name,
    required String description,
    // Live API returns null for root categories despite the spec marking
    // this required (D-13).
    String? parentId,
    required int depth,
    ProductImageDto? image,
    required int productCount,
    required int sortOrder,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}

@freezed
class CategoryDetailDto with _$CategoryDetailDto {
  const factory CategoryDetailDto({
    required String id,
    required String slug,
    required String name,
    required String description,
    String? parentId,
    required int depth,
    ProductImageDto? image,
    required int productCount,
    required int sortOrder,
    required List<CategoryDto> breadcrumb,
  }) = _CategoryDetailDto;

  factory CategoryDetailDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailDtoFromJson(json);
}

@freezed
class CategoryTreeNodeDto with _$CategoryTreeNodeDto {
  const factory CategoryTreeNodeDto({
    required String id,
    required String slug,
    required String name,
    String? description,
    String? parentId,
    required int depth,
    ProductImageDto? image,
    required int productCount,
    required int sortOrder,
    required List<CategoryTreeNodeDto> children,
  }) = _CategoryTreeNodeDto;

  factory CategoryTreeNodeDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryTreeNodeDtoFromJson(json);
}
