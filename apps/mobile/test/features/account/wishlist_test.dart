import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/account/data/wishlist_repository.dart';
import 'package:nest_electro/src/features/account/presentation/wishlist_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProductDetailDto _product() {
  return ProductDetailDto.fromJson(<String, dynamic>{
    'id': 'p1',
    'slug': 'precision-screwdriver-set-64',
    'sku': 'SCREWDRIVER-64',
    'name': 'Precision Screwdriver Set',
    'shortDescription': 'S2 steel bits.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'tools',
      'name': 'Tools',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': <String, dynamic>{
        'amount': 38000,
        'currency': 'EGP',
        'formatted': '380.00 EGP',
      },
      'salePrice': null,
      'effectivePrice': <String, dynamic>{
        'amount': 38000,
        'currency': 'EGP',
        'formatted': '380.00 EGP',
      },
      'discountPercentBps': 0,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.5, 'count': 10},
    'availability': 'IN_STOCK',
    'isFeatured': false,
    'description': 'A great set.',
    'images': <dynamic>[
      <String, dynamic>{
        'publicId': 'nest/products/p1/img',
        'version': 1,
        'format': 'webp',
        'width': 800,
        'height': 800,
        'alt': 'Screwdriver set',
      },
    ],
    'specs': <dynamic>[],
    'stockOnHand': 22,
    'salesCount': 3,
    'weight': 0.5,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
  });
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  setUp(() async {
    await (await SharedPreferences.getInstance()).clear();
  });

  test('repository: add/remove round-trip, corrupt payload is empty', () async {
    final WishlistRepository repository = WishlistRepository();
    expect(await repository.load(), isEmpty);

    await repository.add(
      const WishlistItem(
        productId: 'p1',
        slug: 'slug-p1',
        name: 'Product p1',
        imagePublicId: 'nest/products/p1/img',
        priceFormatted: '380.00 EGP',
      ),
    );
    expect(await repository.isSaved('p1'), true);
    expect((await repository.load()).single.name, 'Product p1');

    // Adding the same product twice does not duplicate it.
    await repository.add(
      const WishlistItem(
        productId: 'p1',
        slug: 'slug-p1',
        name: 'Product p1',
        imagePublicId: 'nest/products/p1/img',
        priceFormatted: '380.00 EGP',
      ),
    );
    expect((await repository.load()).length, 1);

    await repository.remove('p1');
    expect(await repository.load(), isEmpty);

    // Corrupt JSON must not brick the wishlist.
    await (await SharedPreferences.getInstance()).setString(
      WishlistRepository.storageKey,
      '{not json',
    );
    expect(await repository.load(), isEmpty);
  });

  test('controller: toggle adds then removes', () async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);
    final WishlistController controller = container.read(
      wishlistControllerProvider.notifier,
    );
    await _pump();
    expect(container.read(wishlistControllerProvider).isLoading, false);

    expect(await controller.toggle(_product()), true);
    expect(
      container.read(wishlistControllerProvider).isSaved('p1'),
      true,
    );
    expect(
      container.read(wishlistControllerProvider).items.single.name,
      'Precision Screwdriver Set',
    );

    expect(await controller.toggle(_product()), false);
    expect(
      container.read(wishlistControllerProvider).items,
      isEmpty,
    );
  });
}
