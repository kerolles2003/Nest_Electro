import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

ProductListItemDto _item(String slug) {
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
    'rating': <String, dynamic>{'average': 4.0, 'count': 1},
    'availability': 'IN_STOCK',
    'isFeatured': false,
  });
}

PaginatedList<ProductListItemDto> _page(
  List<ProductListItemDto> items, {
  required int page,
  required bool hasNext,
}) {
  return PaginatedList<ProductListItemDto>(
    items: items,
    meta: PaginationMetaDto(
      page: page,
      limit: 12,
      total: 3,
      totalPages: 2,
      hasNext: hasNext,
      hasPrev: page > 1,
    ),
  );
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(const ProductQuery());
  });

  late _MockCatalogueRepository repository;
  late ProviderContainer container;
  const ProductQuery query = ProductQuery();

  setUp(() {
    repository = _MockCatalogueRepository();
    container = ProviderContainer(
      overrides: <Override>[
        catalogueRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('loads the first page on build', () async {
    when(
      () => repository.listProducts(any()),
    ).thenAnswer((_) async => _page(<ProductListItemDto>[_item('a')], page: 1, hasNext: true));

    container.read(productListProvider(query).notifier);
    expect(container.read(productListProvider(query)).isLoading, true);
    await _pump();

    final ProductListState state = container.read(productListProvider(query));
    expect(state.isLoading, false);
    expect(state.items.map((ProductListItemDto p) => p.slug), <String>['a']);
    expect(state.hasNext, true);
    expect(state.error, isNull);
  });

  test('loadMore appends the next page and stops at the last page',
      () async {
    when(() => repository.listProducts(any())).thenAnswer(
      (Invocation inv) async {
        final ProductQuery q =
            inv.positionalArguments[0] as ProductQuery;
        return q.page == 1
            ? _page(<ProductListItemDto>[_item('a')], page: 1, hasNext: true)
            : _page(<ProductListItemDto>[_item('b')], page: 2, hasNext: false);
      },
    );

    final ProductListController controller = container.read(
      productListProvider(query).notifier,
    );
    await _pump();
    await controller.loadMore();
    await _pump();

    final ProductListState state = container.read(productListProvider(query));
    expect(
      state.items.map((ProductListItemDto p) => p.slug),
      <String>['a', 'b'],
    );
    expect(state.hasNext, false);

    // A further loadMore is a no-op: the repository is not called again.
    await controller.loadMore();
    verify(() => repository.listProducts(any())).called(2);
  });

  test('first-page failure surfaces the error', () async {
    when(() => repository.listProducts(any())).thenThrow(
      const ApiException(message: 'boom', code: 'NETWORK_ERROR'),
    );
    container.read(productListProvider(query).notifier);
    await _pump();

    final ProductListState state = container.read(productListProvider(query));
    expect(state.isLoading, false);
    expect(state.items, isEmpty);
    expect(state.error, isNotNull);
    expect(state.error!.code, 'NETWORK_ERROR');
  });

  test('refresh re-fetches page 1', () async {
    when(() => repository.listProducts(any())).thenAnswer(
      (_) async => _page(<ProductListItemDto>[_item('a')], page: 1, hasNext: false),
    );
    final ProductListController controller = container.read(
      productListProvider(query).notifier,
    );
    await _pump();
    await controller.refresh();
    await _pump();
    verify(() => repository.listProducts(any())).called(2);
  });
}
