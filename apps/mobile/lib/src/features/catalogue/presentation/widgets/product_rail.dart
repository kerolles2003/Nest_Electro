import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/presentation/widgets/product_card.dart';

/// Section title row with an optional "See all" action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.onSeeAll, super.key});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: Text(l10n.homeSeeAll)),
        ],
      ),
    );
  }
}

/// Horizontal rail of product cards, driven by an [AsyncValue].
/// Loading shows grey placeholder cards; an error shows a one-line retry
/// row (the rail is never the whole screen, so it never takes over it).
class ProductRail extends StatelessWidget {
  const ProductRail({
    required this.title,
    required this.products,
    required this.onProductTap,
    this.onSeeAll,
    this.onRetry,
    super.key,
  });

  final String title;
  final AsyncValue<List<ProductListItemDto>> products;
  final void Function(ProductListItemDto product) onProductTap;
  final VoidCallback? onSeeAll;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: title, onSeeAll: onSeeAll),
        SizedBox(
          height: 272,
          child: products.when(
            data: (List<ProductListItemDto> items) {
              if (items.isEmpty) {
                return Center(child: Text(l10n.emptyProducts));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, int index) {
                  final ProductListItemDto product = items[index];
                  return ProductCard(
                    product: product,
                    width: 168,
                    onTap: () => onProductTap(product),
                  );
                },
              );
            },
            loading: () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, _) => Container(
                width: 168,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            error: (_, _) => Center(
              child: TextButton(
                onPressed: onRetry,
                child: Text(l10n.retry),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
