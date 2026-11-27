import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_controller.dart';

/// Cart icon with a count badge (hidden when the cart is empty).
/// Watching the cart here is what loads it on the home/detail screens.
class CartButton extends ConsumerWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final int count = ref.watch(cartControllerProvider).totalQuantity;
    return IconButton(
      icon: Badge(
        label: Text(count.toString()),
        isLabelVisible: count > 0,
        child: const Icon(Icons.shopping_cart_outlined),
      ),
      tooltip: l10n.cartTitle,
      onPressed: () => context.push('/cart'),
    );
  }
}
