import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';

final catalogueRepositoryProvider = Provider<CatalogueRepository>((ref) {
  return CatalogueRepository(client: ref.watch(apiClientProvider));
});

/// Flat category list (15 categories). Roots are `parentId == null`;
/// children group under their parent — the tree is built client-side.
final categoriesProvider = FutureProvider<List<CategoryDto>>((ref) {
  return ref.watch(catalogueRepositoryProvider).listCategories();
});

final brandsProvider = FutureProvider<List<BrandDto>>((ref) {
  return ref.watch(catalogueRepositoryProvider).listBrands();
});

final categoryDetailProvider =
    FutureProvider.family<CategoryDetailDto, String>((ref, slug) {
  return ref.watch(catalogueRepositoryProvider).getCategory(slug);
});

final brandDetailProvider = FutureProvider.family<BrandDto, String>((
  ref,
  slug,
) {
  return ref.watch(catalogueRepositoryProvider).getBrand(slug);
});

final productDetailProvider =
    FutureProvider.family<ProductDetailDto, String>((ref, slug) {
  return ref.watch(catalogueRepositoryProvider).getProduct(slug);
});

final relatedProductsProvider =
    FutureProvider.family<List<ProductListItemDto>, String>((ref, slug) {
  return ref.watch(catalogueRepositoryProvider).getRelated(slug);
});

/// Home rails. Featured is a filter (`featured=true`, ordered by newest),
/// not a sort — the API has no featured sort (storefront listing page).
final featuredProductsProvider =
    FutureProvider<PaginatedList<ProductListItemDto>>((ref) {
      return ref.watch(catalogueRepositoryProvider).listProducts(
        const ProductQuery(featured: true, sort: ProductSort.newest, limit: 10),
      );
    });

final newArrivalsProvider =
    FutureProvider<PaginatedList<ProductListItemDto>>((ref) {
      return ref.watch(catalogueRepositoryProvider).listProducts(
        const ProductQuery(sort: ProductSort.newest, limit: 10),
      );
    });

/// Search suggestions. Empty queries short-circuit to `[]` without a
/// network call (the storefront's search page does the same).
final suggestionsProvider =
    FutureProvider.autoDispose.family<List<ProductSuggestionDto>, String>((
      ref,
      query,
    ) async {
      if (query.trim().isEmpty) {
        return const <ProductSuggestionDto>[];
      }
      return ref.watch(catalogueRepositoryProvider).suggest(query.trim());
    });

/// State of one paginated product list (one [ProductQuery]).
class ProductListState {
  const ProductListState({
    this.items = const <ProductListItemDto>[],
    this.meta,
    this.facets,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.error,
  });

  final List<ProductListItemDto> items;
  final PaginationMetaDto? meta;
  final ProductFacetsDto? facets;
  final bool isLoading;
  final bool isLoadingMore;
  final ApiException? error;

  bool get hasNext => meta?.hasNext ?? false;

  ProductListState copyWith({
    List<ProductListItemDto>? items,
    PaginationMetaDto? meta,
    ProductFacetsDto? facets,
    bool? isLoading,
    bool? isLoadingMore,
    ApiException? error,
    bool clearError = false,
  }) {
    return ProductListState(
      items: items ?? this.items,
      meta: meta ?? this.meta,
      facets: facets ?? this.facets,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Paginated product list for one [ProductQuery]: first page on build,
/// `loadMore()` appends the next page, `refresh()` re-fetches page 1.
///
/// The query itself is immutable — changing a filter means watching a
/// different provider instance with a new query (the screen rebuilds with
/// a new [ProductQuery] and the old instance is disposed).
class ProductListController
    extends FamilyNotifier<ProductListState, ProductQuery> {
  @override
  ProductListState build(ProductQuery query) {
    _query = query;
    Future.microtask(_loadFirstPage);
    return const ProductListState();
  }

  late final ProductQuery _query;

  CatalogueRepository get _repo => ref.read(catalogueRepositoryProvider);

  Future<void> _loadFirstPage() async {
    try {
      final PaginatedList<ProductListItemDto> page = await _repo
          .listProducts(_query);
      state = state.copyWith(
        items: page.items,
        meta: page.meta,
        facets: page.facets,
        isLoading: false,
        clearError: true,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Appends the next page. No-op when already loading or on the last page.
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasNext) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    try {
      final PaginatedList<ProductListItemDto> page = await _repo
          .listProducts(_query.copyWith(page: (state.meta?.page ?? 1) + 1));
      state = state.copyWith(
        items: <ProductListItemDto>[...state.items, ...page.items],
        meta: page.meta,
        facets: page.facets ?? state.facets,
        isLoadingMore: false,
        clearError: true,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  /// Re-fetches page 1 (error retry, pull-to-refresh in Phase 7).
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadFirstPage();
  }
}

final productListProvider =
    NotifierProvider.family<
      ProductListController,
      ProductListState,
      ProductQuery
    >(ProductListController.new);
