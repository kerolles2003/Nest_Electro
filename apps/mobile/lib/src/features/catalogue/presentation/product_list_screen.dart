import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/widgets/product_card.dart';

/// Product listing: search results, a category, a brand, or the full
/// catalogue. The [ProductQuery] comes from the route (the router converts
/// URL params — prices in EGP, like the web — to piastres); changing a
/// filter or the sort navigates to a new URL, which rebuilds this screen
/// with a new query and a fresh list.
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({
    required this.query,
    this.title,
    this.header,
    super.key,
  });

  final ProductQuery query;

  /// AppBar title override (category/brand name). Defaults to the search
  /// term or "Products".
  final String? title;

  /// Optional header shown above the result count (category/brand
  /// description).
  final Widget? header;

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant ProductListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final ProductListState state = ref.read(productListProvider(widget.query));
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 400 &&
        state.hasNext &&
        !state.isLoadingMore &&
        !state.isLoading) {
      ref.read(productListProvider(widget.query).notifier).loadMore();
    }
  }

  /// Navigates to the same listing with [query] applied. URL params mirror
  /// the web listing: prices in EGP, `in_stock`/`featured` as flags.
  void _applyQuery(ProductQuery query) {
    final Map<String, String> params = <String, String>{
      if (query.q != null && query.q!.isNotEmpty) 'q': query.q!,
      if (query.category != null && query.category!.isNotEmpty)
        'category': query.category!,
      if (query.brand != null && query.brand!.isNotEmpty) 'brand': query.brand!,
      if (query.minPrice != null)
        'min_price': (query.minPrice! ~/ 100).toString(),
      if (query.maxPrice != null)
        'max_price': (query.maxPrice! ~/ 100).toString(),
      if (query.inStock) 'in_stock': 'true',
      if (query.featured) 'featured': 'true',
      'sort': query.sort.value,
    };
    final String qs = Uri(queryParameters: params).query;
    context.go('/products${qs.isEmpty ? '' : '?$qs'}');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProductListState state = ref.watch(productListProvider(widget.query));
    final ProductQuery query = widget.query;

    return Scaffold(
      key: const Key('product-list-screen'),
      appBar: AppBar(
        title: Text(widget.title ?? query.q ?? l10n.productsTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.searchTitle,
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l10n.filterTitle,
            onPressed: () async {
              final ProductQuery? next =
                  await showModalBottomSheet<ProductQuery>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        _FilterSheet(query: query, facets: state.facets),
                  );
              if (next != null && mounted) {
                _applyQuery(next);
              }
            },
          ),
          PopupMenuButton<ProductSort>(
            icon: const Icon(Icons.sort),
            tooltip: l10n.sortLabel,
            initialValue: query.sort,
            onSelected: (ProductSort sort) {
              _applyQuery(query.copyWith(sort: sort, page: 1));
            },
            itemBuilder: (_) => ProductSort.values
                .map(
                  (ProductSort s) => PopupMenuItem<ProductSort>(
                    value: s,
                    child: Text(_sortLabel(l10n, s)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, ProductListState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                l10n.errorLoadProducts,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref
                    .read(productListProvider(widget.query).notifier)
                    .refresh(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }
    if (state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.search_off_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                l10n.emptyProducts,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.emptyProductsHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final int total = state.meta?.total ?? state.items.length;
    return Column(
      children: <Widget>[
        if (widget.header != null) widget.header!,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: <Widget>[
              Text(
                l10n.productsCount(total),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (widget.query.category != null ||
                  widget.query.brand != null ||
                  widget.query.minPrice != null ||
                  widget.query.maxPrice != null ||
                  widget.query.inStock ||
                  widget.query.featured)
                TextButton(
                  onPressed: () => _applyQuery(
                    widget.query.copyWith(
                      category: null,
                      brand: null,
                      minPrice: null,
                      maxPrice: null,
                      inStock: false,
                      featured: false,
                      page: 1,
                    ),
                  ),
                  child: Text(l10n.filterClear),
                ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(productListProvider(widget.query).notifier).refresh(),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                // Card height: square image + ~120px of text.
                mainAxisExtent: 292,
              ),
              itemCount:
                  state.items.length +
                  (state.hasNext || state.isLoadingMore ? 1 : 0),
              itemBuilder: (_, int index) {
                if (index >= state.items.length) {
                  return Center(
                    child: state.isLoadingMore
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () => ref
                                .read(
                                  productListProvider(widget.query).notifier,
                                )
                                .loadMore(),
                            child: Text(l10n.loadMore),
                          ),
                  );
                }
                final ProductListItemDto product = state.items[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/products/${product.slug}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  static String _sortLabel(AppLocalizations l10n, ProductSort sort) {
    return switch (sort) {
      ProductSort.relevance => l10n.sortRelevance,
      ProductSort.newest => l10n.sortNewest,
      ProductSort.priceAsc => l10n.sortPriceAsc,
      ProductSort.priceDesc => l10n.sortPriceDesc,
      ProductSort.rating => l10n.sortRating,
      ProductSort.nameAsc => l10n.sortNameAsc,
    };
  }
}

/// Filter sheet. Category/brand options come from the current response's
/// facets (they reflect the filtered set, like the web sidebar); price
/// bounds come from `facets.priceRange`. Prices are entered in EGP and
/// converted to piastres on apply.
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.query, required this.facets});

  final ProductQuery query;
  final ProductFacetsDto? facets;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _category = widget.query.category;
  late String? _brand = widget.query.brand;
  late bool _inStock = widget.query.inStock;
  late final TextEditingController _minController = TextEditingController(
    text: widget.query.minPrice == null
        ? ''
        : (widget.query.minPrice! ~/ 100).toString(),
  );
  late final TextEditingController _maxController = TextEditingController(
    text: widget.query.maxPrice == null
        ? ''
        : (widget.query.maxPrice! ~/ 100).toString(),
  );

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  int? _parsePrice(TextEditingController controller) {
    final String text = controller.text.trim();
    if (text.isEmpty) return null;
    final int? egp = int.tryParse(text);
    if (egp == null || egp < 0) return null;
    return egp * 100;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProductFacetsDto? facets = widget.facets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    l10n.filterTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(
                      widget.query.copyWith(
                        category: null,
                        brand: null,
                        minPrice: null,
                        maxPrice: null,
                        inStock: false,
                        featured: false,
                        page: 1,
                      ),
                    ),
                    child: Text(l10n.filterClear),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.filterCategory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  ChoiceChip(
                    label: Text(l10n.filterAll),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                  ...(facets?.categories ?? const <TermFacetDto>[]).map(
                    (TermFacetDto c) => ChoiceChip(
                      label: Text('${c.name} (${c.count})'),
                      selected: _category == c.slug,
                      onSelected: (_) => setState(() => _category = c.slug),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.filterBrand,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  ChoiceChip(
                    label: Text(l10n.filterAll),
                    selected: _brand == null,
                    onSelected: (_) => setState(() => _brand = null),
                  ),
                  ...(facets?.brands ?? const <TermFacetDto>[]).map(
                    (TermFacetDto b) => ChoiceChip(
                      label: Text('${b.name} (${b.count})'),
                      selected: _brand == b.slug,
                      onSelected: (_) => setState(() => _brand = b.slug),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.filterPrice,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.filterMinPrice,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.filterMaxPrice,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              if (facets?.priceRange != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${facets!.priceRange!.min.formatted} – ${facets.priceRange!.max.formatted}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(l10n.filterInStockOnly),
                value: _inStock,
                onChanged: (bool v) => setState(() => _inStock = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    widget.query.copyWith(
                      category: _category,
                      brand: _brand,
                      minPrice: _parsePrice(_minController),
                      maxPrice: _parsePrice(_maxController),
                      inStock: _inStock,
                      page: 1,
                    ),
                  ),
                  child: Text(l10n.filterApply),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
