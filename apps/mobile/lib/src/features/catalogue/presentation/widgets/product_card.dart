import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/presentation/widgets/availability_chip.dart';

/// Product tile used by the home rails, the listing grid and related
/// products. Prices use `MoneyDto.formatted` — the API's authoritative
/// rendering (never recompute from `amount` here).
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onTap,
    this.width,
    super.key,
  });

  final ProductListItemDto product;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ProductPricingDto pricing = product.pricing;
    final bool onSale = pricing.salePrice != null;
    final int discountPercent =
        onSale ? pricing.discountPercentBps ~/ 100 : 0;

    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expanded, not a fixed aspect ratio: the card's height is
              // set by its parent (grid extent / rail height) and the
              // image takes whatever is left after the text block. A
              // square AspectRatio overflowed on wide screens, where the
              // cell is wider than it is tall.
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _ProductImage(image: product.primaryImage),
                    if (product.availability != Availability.inStock)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: AvailabilityChip(
                          availability: product.availability,
                        ),
                      ),
                    if (onSale)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.detailOff(discountPercent),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onError,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (product.brand != null)
                      Text(
                        product.brand!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.average.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.ratingCount(product.rating.count),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            pricing.effectivePrice.formatted,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (onSale) ...<Widget>[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              pricing.basePrice.formatted,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square product image with a grey placeholder and an icon fallback.
/// `ApiConfig.imageUrl` derives the URL from the API base URL (local
/// media-delivery shape) — the same derivation as the storefront's
/// `lib/images.ts`.
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.image});

  final ProductImageDto? image;

  @override
  Widget build(BuildContext context) {
    final ProductImageDto? image = this.image;
    if (image == null) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: ApiConfig.imageUrl(image.publicId, version: image.version),
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (_, _, _) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
