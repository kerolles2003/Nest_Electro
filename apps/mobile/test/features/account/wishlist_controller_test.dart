import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/account/data/wishlist_repository.dart';
import 'package:nest_electro/src/features/account/presentation/wishlist_controller.dart';

class _MockWishlistRepository extends Mock implements WishlistRepository {}

ProductDetailDto _detail() {
  return ProductDetailDto.fromJson(<String, dynamic>{
    'id': 'id-a',
    'slug': 'esp32-board',
    'sku': 'ESP32-BOARD',
    'name': 'ESP32 Dev Board',
    'shortDescription': 'A dev board.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'microcontrollers',
      'name': 'Microcontrollers',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': <String, dynamic>{
        'amount': 25000,
        'currency': 'EGP',
        'formatted': '250.00 EGP',
      },
      'salePrice': null,
      'effectivePrice': <String, dynamic>{
        'amount': 25000,
        'currency': 'EGP',
        'formatted': '250.00 EGP',
      },
      'discountPercentBps': 0,
    },
    'primaryImage': <String, dynamic>{
      'publicId': 'nest/products/id-a/hero',
      'version': 1,
      'format': 'webp',
      'width': 800,
      'height': 800,
      'alt': 'ESP32 Dev Board',
    },
    'rating': <String, dynamic>{'average': 4.5, 'count': 12},
    'availability': 'IN_STOCK',
    'isFeatured': true,
    'description': 'Full description of the board.',
    'images': <dynamic>[],
    'specs': <dynamic>[],
    'stockOnHand': 14,
    'salesCount': 42,
    'weight': 0.05,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-02T00:00:00.000Z',
  });
}

WishlistItem _item(String productId) {
  return WishlistItem(
    productId: productId,
    slug: 'esp32-board',
    name: 'ESP32 Dev Board',
    imagePublicId: 'nest/products/id-a/hero',
    priceFormatted: '250.00 EGP',
  );
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _MockWishlistRepository repository;

  setUpAll(() {
    registerFallbackValue(_item('x'));
  });

  setUp(() {
    repository = _MockWishlistRepository();
    when(() => repository.load()).thenAnswer((_) async => <WishlistItem>[]);
  });

  ProviderContainer makeContainer() {
    final ProviderContainer c = ProviderContainer(
      overrides: <Override>[
        wishlistRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('loads the saved items on build', () async {
    late final ProviderContainer container;
    when(() => repository.load()).thenAnswer(
      (_) async => <WishlistItem>[_item('id-a'), _item('id-b')],
    );
    container = makeContainer();
    // Reading the provider triggers build() and its microtasked _load;
    // only then do the pumps let the load finish.
    container.read(wishlistControllerProvider);
    await _pump();

    final WishlistState state = container.read(wishlistControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.items, hasLength(2));
    expect(state.isSaved('id-a'), isTrue);
    expect(state.isSaved('id-z'), isFalse);
  });

  test('toggle adds an unsaved product and snapshots its details', () async {
    final ProviderContainer container = makeContainer();
    final ProductDetailDto product = _detail();
    when(() => repository.add(any())).thenAnswer(
      (_) async => <WishlistItem>[_item('id-a')],
    );
    // Drain the initial load first, or it can overwrite the toggle's
    // state update when it lands afterwards.
    container.read(wishlistControllerProvider);
    await _pump();

    final bool saved = await container
        .read(wishlistControllerProvider.notifier)
        .toggle(product);

    expect(saved, isTrue);
    final WishlistItem added =
        verify(() => repository.add(captureAny())).captured.single
            as WishlistItem;
    expect(added.productId, 'id-a');
    expect(added.slug, 'esp32-board');
    expect(added.imagePublicId, 'nest/products/id-a/hero');
    expect(added.priceFormatted, '250.00 EGP');
    expect(container.read(wishlistControllerProvider).isSaved('id-a'), isTrue);
  });

  test('toggle removes an already saved product', () async {
    late final ProviderContainer container;
    when(() => repository.load()).thenAnswer(
      (_) async => <WishlistItem>[_item('id-a')],
    );
    when(() => repository.remove('id-a')).thenAnswer(
      (_) async => <WishlistItem>[],
    );
    container = makeContainer();
    container.read(wishlistControllerProvider);
    await _pump();

    final bool saved = await container
        .read(wishlistControllerProvider.notifier)
        .toggle(_detail());

    expect(saved, isFalse);
    verify(() => repository.remove('id-a')).called(1);
    expect(container.read(wishlistControllerProvider).items, isEmpty);
  });

  test('remove deletes by id', () async {
    final ProviderContainer container = makeContainer();
    when(() => repository.remove('id-a')).thenAnswer(
      (_) async => <WishlistItem>[],
    );
    container.read(wishlistControllerProvider);
    await _pump();

    await container.read(wishlistControllerProvider.notifier).remove('id-a');

    verify(() => repository.remove('id-a')).called(1);
    expect(container.read(wishlistControllerProvider).items, isEmpty);
  });
}
