import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/cart/presentation/widgets/cart_button.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/widgets/product_rail.dart';

/// Home: hero carousel, trust bar, category grid, featured + new-arrival
/// rails, brands strip — the storefront's `app/page.tsx` sections, in the
/// same order. Category tiles use the storefront's local artwork
/// (`assets/images/categories/<slug>.png`); the API returns `image: null`
/// for every category, so there is nothing to fetch.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<List<CategoryDto>> categories = ref.watch(
      categoriesProvider,
    );
    final AsyncValue<List<BrandDto>> brands = ref.watch(brandsProvider);
    final AsyncValue<PaginatedList<ProductListItemDto>> featured = ref.watch(
      featuredProductsProvider,
    );
    final AsyncValue<PaginatedList<ProductListItemDto>> arrivals = ref.watch(
      newArrivalsProvider,
    );

    return Scaffold(
      key: const Key('home-screen'),
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.searchTitle,
            onPressed: () => context.push('/search'),
          ),
          const CartButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _HeroBanner(),
              const _TrustBar(),
              categories.when(
                data: (List<CategoryDto> all) {
                  final List<CategoryDto> roots = all
                      .where((CategoryDto c) => c.parentId == null)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SectionHeader(
                        title: l10n.homeCategories,
                        onSeeAll: () => context.push('/categories'),
                      ),
                      _CategoryGrid(categories: roots),
                    ],
                  );
                },
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => ref.invalidate(categoriesProvider),
                    child: Text(l10n.retry),
                  ),
                ),
              ),
              ProductRail(
                title: l10n.homeFeatured,
                products: featured.whenData((page) => page.items),
                onProductTap: (product) =>
                    context.push('/products/${product.slug}'),
                onSeeAll: () => context.go('/products?featured=true'),
                onRetry: () => ref.invalidate(featuredProductsProvider),
              ),
              ProductRail(
                title: l10n.homeNewArrivals,
                products: arrivals.whenData((page) => page.items),
                onProductTap: (product) =>
                    context.push('/products/${product.slug}'),
                onSeeAll: () => context.go('/products?sort=newest'),
                onRetry: () => ref.invalidate(newArrivalsProvider),
              ),
              SectionHeader(
                title: l10n.homeBrands,
                onSeeAll: () => context.push('/products'),
              ),
              brands.when(
                data: (List<BrandDto> list) => SizedBox(
                  height: 96,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, int index) {
                      final BrandDto brand = list[index];
                      return _BrandTile(brand: brand);
                    },
                  ),
                ),
                loading: () => const SizedBox(
                  height: 96,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => ref.invalidate(brandsProvider),
                    child: Text(l10n.retry),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Re-fetches every home rail. A failed rail surfaces through the
  /// screen's error state, so refresh errors are swallowed here.
  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait(<Future<void>>[
      _guard(ref.refresh(categoriesProvider.future)),
      _guard(ref.refresh(featuredProductsProvider.future)),
      _guard(ref.refresh(newArrivalsProvider.future)),
      _guard(ref.refresh(brandsProvider.future)),
    ]);
  }

  Future<void> _guard(Future<Object?> future) async {
    try {
      await future;
    } catch (_) {
      // The screen's error state shows the failure.
    }
  }
}

/// Three-slide hero, mirroring the storefront's `HeroBanner` slides
/// (same copy, same artwork, same 8-second auto-advance).
class _HeroBanner extends StatefulWidget {
  const _HeroBanner();

  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  static const List<({String image, String target})> _slides =
      <({String image, String target})>[
        (image: 'assets/images/banners/1.webp', target: '/products'),
        (image: 'assets/images/banners/2.webp', target: '/products?q=esp32'),
        (image: 'assets/images/banners/3.webp', target: '/products'),
      ];

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      final int next = (_index + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<({String kicker, String title, String subtitle, String cta})>
    copy = <({String kicker, String title, String subtitle, String cta})>[
      (
        kicker: l10n.heroSlide1Kicker,
        title: l10n.heroSlide1Title,
        subtitle: l10n.heroSlide1Subtitle,
        cta: l10n.heroSlide1Cta,
      ),
      (
        kicker: l10n.heroSlide2Kicker,
        title: l10n.heroSlide2Title,
        subtitle: l10n.heroSlide2Subtitle,
        cta: l10n.heroSlide2Cta,
      ),
      (
        kicker: l10n.heroSlide3Kicker,
        title: l10n.heroSlide3Title,
        subtitle: l10n.heroSlide3Subtitle,
        cta: l10n.heroSlide3Cta,
      ),
    ];

    return SizedBox(
      height: 300,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (int i) {
              setState(() => _index = i);
              _restartTimer();
            },
            itemBuilder: (_, int i) {
              final slide = _slides[i];
              final text = copy[i];
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(slide.image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.72),
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          text.kicker,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          text.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          text.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.push(slide.target),
                          child: Text(text.cta),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _slides.length,
                (int i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The storefront's four trust items, same copy.
class _TrustBar extends StatelessWidget {
  const _TrustBar();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<({IconData icon, String title, String sub})> items =
        <({IconData icon, String title, String sub})>[
          (
            icon: Icons.local_shipping_outlined,
            title: l10n.trustCairoStock,
            sub: l10n.trustCairoStockSub,
          ),
          (
            icon: Icons.verified_outlined,
            title: l10n.trustVerifiedParts,
            sub: l10n.trustVerifiedPartsSub,
          ),
          (
            icon: Icons.payments_outlined,
            title: l10n.trustCod,
            sub: l10n.trustCodSub,
          ),
          (
            icon: Icons.headset_mic_outlined,
            title: l10n.trustSupport,
            sub: l10n.trustSupportSub,
          ),
        ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: Column(
                  children: <Widget>[
                    Icon(
                      item.icon,
                      size: 22,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.sub,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<CategoryDto> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: categories.length,
      itemBuilder: (_, int index) {
        final CategoryDto category = categories[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('/categories/${category.slug}'),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/images/categories/${category.slug}.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.category_outlined,
                      size: 36,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${category.productCount}',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({required this.brand});

  final BrandDto brand;

  @override
  Widget build(BuildContext context) {
    final ProductImageDto? logo = brand.logo;
    return InkWell(
      onTap: () => context.push('/brands/${brand.slug}'),
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 84,
        child: Column(
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: logo != null
                  ? CachedNetworkImage(
                      imageUrl: ApiConfig.imageUrl(
                        logo.publicId,
                        version: logo.version,
                      ),
                      fit: BoxFit.contain,
                      placeholder: (_, _) => Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (_, _, _) => _BrandInitial(brand: brand),
                    )
                  : _BrandInitial(brand: brand),
            ),
            const SizedBox(height: 6),
            Text(
              brand.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandInitial extends StatelessWidget {
  const _BrandInitial({required this.brand});

  final BrandDto brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(
        brand.name.isNotEmpty ? brand.name[0].toUpperCase() : '?',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
