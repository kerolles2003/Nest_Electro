import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';

/// Fake client: records the path + query parameters and returns canned
/// data, so the test proves the repository asks the API for the right
/// thing (the JSON mapping itself is covered by product_parse_test).
class _FakeApiClient extends Fake implements ApiClient {
  String? lastPath;
  Map<String, dynamic>? lastQueryParameters;
  PaginatedList<ProductListItemDto>? pageToReturn;
  dynamic dataToReturn;

  @override
  Future<PaginatedList<T>> getPage<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;
    return pageToReturn as PaginatedList<T>;
  }

  @override
  Future<T> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) fromJson,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;
    return dataToReturn as T;
  }
}

ProductListItemDto _listItem(String slug) {
  return ProductListItemDto.fromJson(<String, dynamic>{
    'id': 'id-$slug',
    'slug': slug,
    'sku': 'SKU-$slug',
    'name': 'Product $slug',
    'shortDescription': 'Short.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'tools',
      'name': 'Tools & Equipment',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'salePrice': null,
      'effectivePrice': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'discountPercentBps': 0,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.5, 'count': 3},
    'availability': 'IN_STOCK',
    'isFeatured': false,
  });
}

void main() {
  late _FakeApiClient client;
  late CatalogueRepository repository;

  setUp(() {
    client = _FakeApiClient();
    repository = CatalogueRepository(client: client);
  });

  group('ProductQuery.toQueryParameters', () {
    test('defaults send page/limit/sort only', () {
      expect(
        const ProductQuery().toQueryParameters(),
        <String, dynamic>{'page': 1, 'limit': 12, 'sort': 'newest'},
      );
    });

    test('filters are included, nulls omitted', () {
      final Map<String, dynamic> params = const ProductQuery(
        q: 'esp32',
        category: 'microcontrollers',
        brand: 'espressif',
        minPrice: 10000,
        maxPrice: 50000,
        inStock: true,
        featured: true,
        sort: ProductSort.priceAsc,
      ).toQueryParameters();
      expect(params['q'], 'esp32');
      expect(params['category'], 'microcontrollers');
      expect(params['brand'], 'espressif');
      expect(params['minPrice'], 10000);
      expect(params['maxPrice'], 50000);
      expect(params['inStock'], true);
      expect(params['featured'], true);
      expect(params['sort'], 'price_asc');
    });
  });

  group('CatalogueRepository', () {
    test('listProducts calls GET /products with the query params', () async {
      client.pageToReturn = PaginatedList<ProductListItemDto>(
        items: <ProductListItemDto>[_listItem('a')],
        meta: const PaginationMetaDto(
          page: 1,
          limit: 12,
          total: 1,
          totalPages: 1,
          hasNext: false,
          hasPrev: false,
        ),
      );
      final PaginatedList<ProductListItemDto> page =
          await repository.listProducts(
        const ProductQuery(category: 'tools', sort: ProductSort.rating),
      );
      expect(client.lastPath, '/products');
      expect(client.lastQueryParameters?['category'], 'tools');
      expect(client.lastQueryParameters?['sort'], 'rating');
      expect(page.items.single.slug, 'a');
    });

    test('getProduct calls GET /products/{slug}', () async {
      client.dataToReturn = ProductDetailDto.fromJson(<String, dynamic>{
        'id': 'id-a',
        'slug': 'a',
        'sku': 'SKU-a',
        'name': 'Product a',
        'shortDescription': 'Short.',
        'category': <String, dynamic>{
          'id': 'c1',
          'slug': 'tools',
          'name': 'Tools & Equipment',
        },
        'brand': null,
        'pricing': <String, dynamic>{
          'basePrice': <String, dynamic>{
            'amount': 10000,
            'currency': 'EGP',
            'formatted': '100.00 EGP',
          },
          'salePrice': null,
          'effectivePrice': <String, dynamic>{
            'amount': 10000,
            'currency': 'EGP',
            'formatted': '100.00 EGP',
          },
          'discountPercentBps': 0,
        },
        'primaryImage': null,
        'rating': <String, dynamic>{'average': 4.0, 'count': 1},
        'availability': 'IN_STOCK',
        'isFeatured': false,
        'description': 'Full.',
        'images': <dynamic>[],
        'specs': <dynamic>[],
        'stockOnHand': 5,
        'salesCount': 0,
        'weight': 0.1,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'updatedAt': '2026-01-01T00:00:00.000Z',
      });
      final ProductDetailDto detail = await repository.getProduct('a');
      expect(client.lastPath, '/products/a');
      expect(detail.slug, 'a');
    });

    test('getRelated calls GET /products/{slug}/related', () async {
      client.dataToReturn = <ProductListItemDto>[_listItem('b')];
      final List<ProductListItemDto> related = await repository.getRelated(
        'a',
      );
      expect(client.lastPath, '/products/a/related');
      expect(related.single.slug, 'b');
    });

    test('suggest calls GET /products/suggest?q=', () async {
      client.dataToReturn = <ProductSuggestionDto>[];
      await repository.suggest('esp');
      expect(client.lastPath, '/products/suggest');
      expect(client.lastQueryParameters?['q'], 'esp');
    });

    test('listCategories calls GET /categories', () async {
      client.dataToReturn = <CategoryDto>[];
      await repository.listCategories();
      expect(client.lastPath, '/categories');
    });

    test('getCategory calls GET /categories/{slug}', () async {
      client.dataToReturn = CategoryDetailDto.fromJson(<String, dynamic>{
        'id': 'c1',
        'slug': 'tools',
        'name': 'Tools & Equipment',
        'description': '',
        'parentId': null,
        'depth': 0,
        'image': null,
        'productCount': 5,
        'sortOrder': 1,
        'breadcrumb': <dynamic>[],
      });
      final CategoryDetailDto detail = await repository.getCategory('tools');
      expect(client.lastPath, '/categories/tools');
      expect(detail.slug, 'tools');
    });

    test('listBrands calls GET /brands, getBrand calls /brands/{slug}',
        () async {
      client.dataToReturn = <BrandDto>[];
      await repository.listBrands();
      expect(client.lastPath, '/brands');
      client.dataToReturn = BrandDto.fromJson(<String, dynamic>{
        'id': 'b1',
        'slug': 'arduino',
        'name': 'Arduino',
        'description': '',
        'logo': null,
        'website': 'https://arduino.cc',
        'productCount': 4,
      });
      await repository.getBrand('arduino');
      expect(client.lastPath, '/brands/arduino');
    });
  });
}
