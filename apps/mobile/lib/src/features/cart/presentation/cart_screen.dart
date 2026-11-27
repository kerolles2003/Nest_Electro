import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/cart.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_controller.dart';

/// The cart. Guests see their local basket priced by `POST /cart/preview`;
/// signed-in users see the server cart. The two render identically — the
/// controller hides the difference. A signed-in user with an unmoved guest
/// basket gets a banner to move it into the account (never automatic).
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CartState state = ref.watch(cartControllerProvider);
    final bool loggedIn = ref.watch(authControllerProvider).isAuthenticated;

    return Scaffold(
      key: const Key('cart-screen'),
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        actions: <Widget>[
          if ((state.cart?.items.isNotEmpty ?? false))
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.cartClear,
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: _buildBody(context, ref, state, loggedIn),
      bottomNavigationBar: _buildBottomBar(context, ref, state, loggedIn),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.cartClear),
        content: Text(l10n.cartEmptyHint),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.cartClear),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(cartControllerProvider.notifier).clear();
    }
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CartState state,
    bool loggedIn,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.cart == null) {
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
                onPressed: () =>
                    ref.read(cartControllerProvider.notifier).refresh(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }
    final CartDto? cart = state.cart;
    if (cart == null || cart.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.shopping_cart_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                l10n.cartEmpty,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.cartEmptyHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/products'),
                child: Text(l10n.browseProducts),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: <Widget>[
        if (loggedIn && state.guestLines.isNotEmpty)
          _GuestBanner(linesCount: state.guestLines.length),
        if (cart.hasBlockingIssues)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _WarningCard(text: l10n.cartBlockingIssues),
          ),
        ...cart.items.map(
          (CartLineDto line) => _CartLineTile(line: line),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                l10n.cartItemCount(cart.totalQuantity),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                cart.itemsSubtotal.formatted,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    CartState state,
    bool loggedIn,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CartDto? cart = state.cart;
    if (cart == null || cart.items.isEmpty) {
      return null;
    }
    final bool blocked = cart.hasBlockingIssues || state.isBusy;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  l10n.cartSubtotal,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  cart.itemsSubtotal.formatted,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: blocked
                    ? null
                    : () {
                        if (loggedIn) {
                          context.push('/checkout');
                        } else {
                          context.push('/login?redirect=/checkout');
                        }
                      },
                child: Text(
                  loggedIn ? l10n.cartCheckout : l10n.cartLoginToCheckout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestBanner extends ConsumerWidget {
  const _GuestBanner({required this.linesCount});

  final int linesCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CartState state = ref.watch(cartControllerProvider);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            const Icon(Icons.info_outline),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.cartGuestBanner(linesCount))),
            TextButton(
              onPressed: state.isBusy
                  ? null
                  : () async {
                      final bool ok = await ref
                          .read(cartControllerProvider.notifier)
                          .moveGuestLinesToAccount();
                      if (ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.cartMovedToAccount)),
                        );
                      }
                    },
              child: Text(l10n.cartMoveToAccount),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.warning_amber_outlined,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartLineTile extends ConsumerWidget {
  const _CartLineTile({required this.line});

  final CartLineDto line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CartState state = ref.watch(cartControllerProvider);
    final String? statusText = switch (line.status) {
      CartLineStatus.priceChanged => l10n.cartLinePriceChanged,
      CartLineStatus.reducedStock =>
        l10n.cartLineReducedStock(line.effectiveQuantity),
      CartLineStatus.outOfStock => l10n.cartLineOutOfStock,
      CartLineStatus.unavailable => l10n.cartLineUnavailable,
      CartLineStatus.ok || CartLineStatus.unknown => null,
    };

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () => context.push('/products/${line.slug}'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: ApiConfig.imageUrl(line.imagePublicId),
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    width: 72,
                    height: 72,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, _, _) => Container(
                    width: 72,
                    height: 72,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () => context.push('/products/${line.slug}'),
                    child: Text(
                      line.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    line.unitPrice?.formatted ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (statusText != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      statusText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      _QtyButton(
                        icon: Icons.remove,
                        enabled: !state.isBusy,
                        onPressed: () => ref
                            .read(cartControllerProvider.notifier)
                            .updateQuantity(
                              line.productId,
                              line.quantity - 1,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          line.effectiveQuantity.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        enabled:
                            !state.isBusy &&
                            line.effectiveQuantity < line.availableQuantity,
                        onPressed: () => ref
                            .read(cartControllerProvider.notifier)
                            .updateQuantity(
                              line.productId,
                              line.quantity + 1,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        line.lineTotal?.formatted ?? '',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: l10n.removeItem,
                        onPressed: state.isBusy
                            ? null
                            : () => ref
                                .read(cartControllerProvider.notifier)
                                .remove(line.productId),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
