import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';

/// Read-only catalogue surface: products, categories, brands.
///
/// Thin over [ApiClient] — no caching, no state; the Riverpod providers in
/// `catalogue_providers.dart` own freshness. All methods throw
/// [ApiException] on failure (see `api_client.dart`).
class CatalogueRepository {
  CatalogueRepository({required ApiClient client}) : _client = client;

  final ApiClient _client;

  /// `GET /products` — paginated list with facets (categories, brands,
  /// price range, specs) for the filter UI.
  Future<PaginatedList<ProductListItemDto>> listProducts(
    ProductQuery query,
  ) {
    return _client.getPage<ProductListItemDto>(
      '/products',
      queryParameters: query.toQueryParameters(),
      fromJson: (Object? json) =>
          ProductListItemDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /products/{slug}`.
  Future<ProductDetailDto> getProduct(String slug) {
    return _client.getData<ProductDetailDto>(
      '/products/$slug',
      fromJson: (Object? json) =>
          ProductDetailDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /products/{slug}/related` — plain `{ data: [...] }` list.
  Future<List<ProductListItemDto>> getRelated(String slug) {
    return _client.getData<List<ProductListItemDto>>(
      '/products/$slug/related',
      fromJson: (Object? json) => (json as List<dynamic>)
          .map(
            (Object? e) =>
                ProductListItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// `GET /products/suggest?q=` — name/SKU suggestions for the search box.
  Future<List<ProductSuggestionDto>> suggest(String q) {
    return _client.getData<List<ProductSuggestionDto>>(
      '/products/suggest',
      queryParameters: <String, dynamic>{'q': q},
      fromJson: (Object? json) => (json as List<dynamic>)
          .map(
            (Object? e) =>
                ProductSuggestionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// `GET /categories` — flat list (15 categories). The tree is built
  /// client-side from `parentId`/`depth`; `/categories/tree` carries the
  /// same fields plus a `children` array our models intentionally do not
  /// parse.
  Future<List<CategoryDto>> listCategories() {
    return _client.getData<List<CategoryDto>>(
      '/categories',
      fromJson: (Object? json) => (json as List<dynamic>)
          .map(
            (Object? e) => CategoryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// `GET /categories/{slug}` — detail incl. breadcrumb.
  Future<CategoryDetailDto> getCategory(String slug) {
    return _client.getData<CategoryDetailDto>(
      '/categories/$slug',
      fromJson: (Object? json) =>
          CategoryDetailDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// `GET /brands`.
  Future<List<BrandDto>> listBrands() {
    return _client.getData<List<BrandDto>>(
      '/brands',
      fromJson: (Object? json) => (json as List<dynamic>)
          .map((Object? e) => BrandDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// `GET /brands/{slug}`.
  Future<BrandDto> getBrand(String slug) {
    return _client.getData<BrandDto>(
      '/brands/$slug',
      fromJson: (Object? json) =>
          BrandDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
