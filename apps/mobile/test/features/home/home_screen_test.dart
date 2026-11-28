import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/home/presentation/home_screen.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

CategoryDto _category(String slug, String name) {
  return CategoryDto.fromJson(<String, dynamic>{
    'id': 'c-$slug',
    'slug': slug,
    'name': name,
    'description': '$name category.',
    'parentId': null,
    'depth': 0,
    'image': null,
    'productCount': 5,
    'sortOrder': 1,
  });
}

BrandDto _brand(String slug, String name) {
  return BrandDto.fromJson(<String, dynamic>{
    'id': 'b-$slug',
    'slug': slug,
    'name': name,
    'description': '$name brand.',
    'logo': null,
    'website': 'https://example.com',
    'productCount': 3,
  });
}

ProductListItemDto _item(String slug, String name) {
  return ProductListItemDto.fromJson(<String, dynamic>{
    'id': 'id-$slug',
    'slug': slug,
    'sku': 'SKU-$slug',
    'name': name,
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
  });
}

PaginatedList<ProductListItemDto> _page(List<ProductListItemDto> items) {
  return PaginatedList<ProductListItemDto>(
    items: items,
    meta: PaginationMetaDto(
      page: 1,
      limit: 10,
      total: items.length,
      totalPages: 1,
      hasNext: false,
      hasPrev: false,
    ),
  );
}

Future<void> _pumpHome(
  WidgetTester tester,
  _MockCatalogueRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        catalogueRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const HomeScreen(),
      ),
    ),
  );
  // Manual pumps: the hero carousel's 8-second auto-advance timer never
  // settles under pumpAndSettle (D-19).
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(() {
    registerFallbackValue(const ProductQuery());
  });

  testWidgets('renders categories, featured, arrivals and brands',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.listCategories()).thenAnswer(
      (_) async => <CategoryDto>[
        _category('tools', 'Tools & Equipment'),
        _category('microcontrollers', 'Microcontrollers'),
      ],
    );
    when(() => repository.listBrands()).thenAnswer(
      (_) async => <BrandDto>[_brand('espressif', 'Espressif')],
    );
    when(() => repository.listProducts(any())).thenAnswer(
      (_) async => _page(<ProductListItemDto>[
        _item('esp32-board', 'ESP32 Dev Board'),
      ]),
    );

    await _pumpHome(tester, repository);

    expect(find.text('Nest Electro'), findsOneWidget);
    expect(find.text('Shop by category'), findsOneWidget);
    expect(find.text('Tools & Equipment'), findsOneWidget);
    expect(find.text('Microcontrollers'), findsOneWidget);
    expect(find.text('Featured products'), findsOneWidget);
    expect(find.text('New arrivals'), findsOneWidget);
    expect(find.text('ESP32 Dev Board'), findsWidgets);
    expect(find.text('Our brands'), findsOneWidget);
    expect(find.text('Espressif'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('featured rail error shows a retry that reloads',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.listCategories()).thenAnswer(
      (_) async => <CategoryDto>[_category('tools', 'Tools & Equipment')],
    );
    when(() => repository.listBrands()).thenAnswer(
      (_) async => <BrandDto>[],
    );
    int featuredCalls = 0;
    when(() => repository.listProducts(any())).thenAnswer((_) async {
      featuredCalls++;
      if (featuredCalls <= 2) {
        // Both rails call listProducts; fail the first two calls so the
        // featured rail errors, then succeed on the retry.
        throw const ApiException(code: 'NETWORK_ERROR', message: 'down');
      }
      return _page(<ProductListItemDto>[
        _item('esp32-board', 'ESP32 Dev Board'),
      ]);
    });

    await _pumpHome(tester, repository);

    expect(find.text('Retry'), findsWidgets);
    // The rail sits below the fold on the test viewport.
    await tester.ensureVisible(find.text('Retry').first);
    await tester.pump();
    await tester.tap(find.text('Retry').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('ESP32 Dev Board'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
