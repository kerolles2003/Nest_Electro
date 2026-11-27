import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';

/// Fixtures copied from the live API (2026-11-27) to catch schema drift.
/// Note the nulls the OpenAPI does not admit: `parentId`, `brand`,
/// `salePrice`.
void main() {
  group('ProductListItemDto', () {
    test('parses a real list item with null brand and salePrice', () {
      final ProductListItemDto product = ProductListItemDto.fromJson(
        <String, dynamic>{
          'id': '6b032b258841ea96f14f8507',
          'slug': 'precision-screwdriver-set-64',
          'sku': 'SCREWDRIVER-64',
          'name': 'Precision Screwdriver Set — 64 in 1',
          'shortDescription': 'S2 steel precision bits.',
          'category': <String, dynamic>{
            'id': '6b032afafdc02e51391b7172',
            'slug': 'tools',
            'name': 'Tools & Equipment',
          },
          'brand': null,
          'pricing': <String, dynamic>{
            'basePrice': <String, dynamic>{
              'amount': 38000,
              'currency': 'EGP',
              'formatted': '380.00 EGP',
            },
            'salePrice': null,
            'effectivePrice': <String, dynamic>{
              'amount': 38000,
              'currency': 'EGP',
              'formatted': '380.00 EGP',
            },
            'discountPercentBps': 0,
          },
          'primaryImage': <String, dynamic>{
            'publicId': 'nest/products/6b032b258841ea96f14f8507/O9yyN8HOlI6Rfp1X',
            'version': 1795369735,
            'format': 'png',
            'width': 1600,
            'height': 1600,
            'alt': 'Precision Screwdriver Set — 64 in 1',
          },
          'rating': <String, dynamic>{'average': 0, 'count': 0},
          'availability': 'IN_STOCK',
          'isFeatured': false,
        },
      );

      expect(product.slug, 'precision-screwdriver-set-64');
      expect(product.brand, isNull);
      expect(product.pricing.salePrice, isNull);
      expect(product.pricing.effectivePrice.amount, 38000);
      expect(product.pricing.effectivePrice.asPounds, 380.0);
      expect(product.availability, Availability.inStock);
      expect(product.primaryImage?.version, 1795369735);
    });

    test('unknown availability degrades to unknown instead of crashing', () {
      final ProductListItemDto product = ProductListItemDto.fromJson(
        <String, dynamic>{
          'id': 'x',
          'slug': 'x',
          'sku': 'x',
          'name': 'x',
          'shortDescription': 'x',
          'category': <String, dynamic>{
            'id': 'c',
            'slug': 'c',
            'name': 'c',
          },
          'brand': null,
          'pricing': <String, dynamic>{
            'basePrice': <String, dynamic>{
              'amount': 100,
              'currency': 'EGP',
              'formatted': '1.00 EGP',
            },
            'salePrice': null,
            'effectivePrice': <String, dynamic>{
              'amount': 100,
              'currency': 'EGP',
              'formatted': '1.00 EGP',
            },
            'discountPercentBps': 0,
          },
          'primaryImage': null,
          'rating': <String, dynamic>{'average': 0, 'count': 0},
          'availability': 'BACKORDERED',
          'isFeatured': false,
        },
      );

      expect(product.availability, Availability.unknown);
    });
  });

  group('CategoryDto', () {
    test('parses a root category with null parentId', () {
      final CategoryDto category = CategoryDto.fromJson(
        <String, dynamic>{
          'id': '6b032af9fdc02e51391b7168',
          'slug': 'microcontrollers',
          'name': 'Microcontrollers',
          'description': 'Boards and modules.',
          'parentId': null,
          'depth': 0,
          'image': null,
          'productCount': 17,
          'sortOrder': 1,
        },
      );

      expect(category.parentId, isNull);
      expect(category.image, isNull);
      expect(category.depth, 0);
    });
  });

  group('PaginatedList', () {
    test('parses a product list page with meta and facets', () {
      final PaginatedList<ProductListItemDto> page =
          PaginatedList<ProductListItemDto>.fromJson(
        <String, dynamic>{
          'data': <dynamic>[],
          'meta': <String, dynamic>{
            'page': 1,
            'limit': 24,
            'total': 60,
            'totalPages': 3,
            'hasNext': true,
            'hasPrev': false,
          },
          'facets': <String, dynamic>{
            'categories': <dynamic>[],
            'brands': <dynamic>[],
            'priceRange': <String, dynamic>{
              'min': <String, dynamic>{
                'amount': 9500,
                'currency': 'EGP',
                'formatted': '95.00 EGP',
              },
              'max': <String, dynamic>{
                'amount': 250000,
                'currency': 'EGP',
                'formatted': '2,500.00 EGP',
              },
            },
            'specs': <dynamic>[],
          },
        },
        (Object? json) =>
            ProductListItemDto.fromJson(json as Map<String, dynamic>),
      );

      expect(page.items, isEmpty);
      expect(page.meta.total, 60);
      expect(page.meta.hasNext, isTrue);
      expect(page.facets?.priceRange?.min.amount, 9500);
    });
  });
}
