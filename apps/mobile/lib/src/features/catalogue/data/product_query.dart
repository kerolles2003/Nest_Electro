import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_query.freezed.dart';

/// Sort orders the API accepts on `GET /products`
/// (OpenAPI `ProductSort`, frozen in the storefront's SEARCH-MODEL.md).
enum ProductSort {
  relevance,
  newest,
  priceAsc,
  priceDesc,
  rating,
  nameAsc;

  /// The wire value sent as `sort=`.
  String get value => switch (this) {
        ProductSort.relevance => 'relevance',
        ProductSort.newest => 'newest',
        ProductSort.priceAsc => 'price_asc',
        ProductSort.priceDesc => 'price_desc',
        ProductSort.rating => 'rating',
        ProductSort.nameAsc => 'name_asc',
      };
}

/// One product-listing request.
///
/// Prices are integer piastres (the API's minor units) — the same units
/// `MoneyDto.amount` uses. The storefront puts major units (EGP) in the URL
/// and multiplies by 100 before calling the API; this app does the same
/// conversion at the router boundary, so this class only ever holds
/// piastres.
@freezed
class ProductQuery with _$ProductQuery {
  const factory ProductQuery({
    @Default(1) int page,
    @Default(12) int limit,
    String? q,
    String? category,
    String? brand,
    int? minPrice,
    int? maxPrice,
    @Default(false) bool inStock,
    @Default(false) bool featured,
    String? spec,
    @Default(ProductSort.newest) ProductSort sort,
  }) = _ProductQuery;

  const ProductQuery._();

  /// Query parameters for `GET /products`. Null/empty/false values are
  /// omitted so the request only carries what the user actually asked for.
  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      if (q != null && q!.isNotEmpty) 'q': q,
      if (category != null && category!.isNotEmpty) 'category': category,
      if (brand != null && brand!.isNotEmpty) 'brand': brand,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (inStock) 'inStock': true,
      if (featured) 'featured': true,
      if (spec != null && spec!.isNotEmpty) 'spec': spec,
      'sort': sort.value,
    };
  }
}
