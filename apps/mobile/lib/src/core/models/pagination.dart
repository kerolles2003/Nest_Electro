import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/product.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed
class PaginationMetaDto with _$PaginationMetaDto {
  const factory PaginationMetaDto({
    required int page,
    required int limit,
    required int total,
    required int totalPages,
    required bool hasNext,
    required bool hasPrev,
  }) = _PaginationMetaDto;

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaDtoFromJson(json);
}

/// A paginated list response: `{ data: [...], meta: {...}, facets?: {...} }`.
/// `facets` is only populated by the product list endpoint; it is `null` for
/// every other paginated response.
class PaginatedList<T> {
  const PaginatedList({
    required this.items,
    required this.meta,
    this.facets,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedList<T>(
      items: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      meta: PaginationMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
      facets: json['facets'] == null
          ? null
          : ProductFacetsDto.fromJson(json['facets'] as Map<String, dynamic>),
    );
  }

  final List<T> items;
  final PaginationMetaDto meta;
  final ProductFacetsDto? facets;
}
