import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_list_screen.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

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
      limit: 12,
      total: items.length,
      totalPages: 1,
      hasNext: false,
      hasPrev: false,
    ),
  );
}

Future<void> _pumpScreen(
  WidgetTester tester,
  _MockCatalogueRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        // The catalogue providers read this; the controller under test
        // is the real one.
        catalogueRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const ProductListScreen(query: ProductQuery()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerFallbackValue(const ProductQuery());
  });

  testWidgets('shows products once loaded', (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.listProducts(any())).thenAnswer(
      (_) async => _page(<ProductListItemDto>[
        _item('a', 'Screwdriver Set'),
        _item('b', 'ESP32 Board'),
      ]),
    );

    await _pumpScreen(tester, repository);

    expect(find.text('Screwdriver Set'), findsOneWidget);
    expect(find.text('ESP32 Board'), findsOneWidget);
    expect(find.text('2 products'), findsOneWidget);
  });

  testWidgets('shows the empty state when the list is empty',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(
      () => repository.listProducts(any()),
    ).thenAnswer((_) async => _page(<ProductListItemDto>[]));

    await _pumpScreen(tester, repository);

    expect(find.text('No products found'), findsOneWidget);
    expect(find.text('Try a different search or clear the filters.'),
        findsOneWidget);
  });

  testWidgets('shows the error state with a retry that reloads',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.listProducts(any())).thenThrow(
      const ApiException(code: 'NETWORK_ERROR', message: 'boom'),
    );

    await _pumpScreen(tester, repository);
    expect(find.text("Couldn't load products"), findsOneWidget);

    when(() => repository.listProducts(any())).thenAnswer(
      (_) async => _page(<ProductListItemDto>[_item('a', 'Screwdriver Set')]),
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Screwdriver Set'), findsOneWidget);
    verify(() => repository.listProducts(any())).called(2);
  });
}
