import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/account/data/wishlist_repository.dart';
import 'package:nest_electro/src/features/account/presentation/wishlist_controller.dart';

/// Wishlist. LOCAL-ONLY: the API has no wishlist endpoint (G1), so items
/// live in SharedPreferences on this device with a price snapshot from
/// save time. The banner says so; tapping an item opens the live product
/// detail.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final WishlistState state = ref.watch(wishlistControllerProvider);
    return Scaffold(
      key: const Key('wishlist-screen'),
      appBar: AppBar(title: Text(l10n.wishlistTitle)),
      body: Builder(
        builder: (BuildContext context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(wishlistControllerProvider.notifier).reload(),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.wishlistLocalOnly,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (state.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l10n.wishlistEmpty,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...state.items.map(
                    (WishlistItem item) => ListTile(
                      leading: item.imagePublicId.isEmpty
                          ? const Icon(Icons.image_not_supported)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: ApiConfig.imageUrl(item.imagePublicId),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                ),
                                errorWidget: (_, _, _) => const Icon(
                                  Icons.image_not_supported,
                                ),
                              ),
                            ),
                      title: Text(item.name),
                      subtitle: Text(item.priceFormatted),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: l10n.removeItem,
                        onPressed: () => ref
                            .read(wishlistControllerProvider.notifier)
                            .remove(item.productId),
                      ),
                      onTap: () => context.push('/products/${item.slug}'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
