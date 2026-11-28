import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/account/data/wishlist_repository.dart';

final wishlistControllerProvider =
    NotifierProvider<WishlistController, WishlistState>(
  WishlistController.new,
);

/// Local wishlist state (SharedPreferences — no API endpoint, G1).
class WishlistState {
  const WishlistState({
    this.items = const <WishlistItem>[],
    this.isLoading = true,
  });

  final List<WishlistItem> items;
  final bool isLoading;

  bool isSaved(String productId) {
    return items.any((WishlistItem i) => i.productId == productId);
  }

  WishlistState copyWith({
    List<WishlistItem>? items,
    bool? isLoading,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WishlistController extends Notifier<WishlistState> {
  @override
  WishlistState build() {
    Future.microtask(_load);
    return const WishlistState();
  }

  WishlistRepository get _repository => ref.read(wishlistRepositoryProvider);

  Future<void> _load() async {
    final List<WishlistItem> items = await _repository.load();
    state = state.copyWith(items: items, isLoading: false);
  }

  Future<void> reload() => _load();

  /// Toggles a product in the wishlist. Returns true when the product is
  /// saved afterwards, false when it was removed.
  Future<bool> toggle(ProductDetailDto product) async {
    if (state.isSaved(product.id)) {
      state = state.copyWith(
        items: await _repository.remove(product.id),
      );
      return false;
    }
    state = state.copyWith(
      items: await _repository.add(
        WishlistItem(
          productId: product.id,
          slug: product.slug,
          name: product.name,
          imagePublicId:
              product.primaryImage?.publicId ??
              (product.images.isEmpty
                  ? ''
                  : product.images.first.publicId),
          priceFormatted: product.pricing.effectivePrice.formatted,
        ),
      ),
    );
    return true;
  }

  Future<void> remove(String productId) async {
    state = state.copyWith(items: await _repository.remove(productId));
  }
}
