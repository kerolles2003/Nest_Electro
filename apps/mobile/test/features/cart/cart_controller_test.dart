import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/cart.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/cart/data/cart_repository.dart';
import 'package:nest_electro/src/features/cart/data/guest_cart_storage.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockCartRepository extends Mock implements CartRepository {}

class _FakeAuthController extends AuthController {
  _FakeAuthController(this.fixed);

  final AuthState fixed;

  @override
  AuthState build() => fixed;
}

AuthUserDto _user() {
  return AuthUserDto.fromJson(<String, dynamic>{
    'id': 'u1',
    'email': 'user@example.com',
    'fullName': 'Test User',
    'phone': null,
    'role': 'CUSTOMER',
    'emailVerified': true,
    'lastLoginAt': null,
    'createdAt': '2026-01-01T00:00:00.000Z',
  });
}

Map<String, dynamic> _lineJson(String productId, int quantity) {
  return <String, dynamic>{
    'productId': productId,
    'slug': 'slug-$productId',
    'sku': 'SKU-$productId',
    'name': 'Product $productId',
    'imagePublicId': 'nest/products/$productId/img',
    'quantity': quantity,
    'effectiveQuantity': quantity,
    'availableQuantity': 10,
    'unitPrice': <String, dynamic>{
      'amount': 10000,
      'currency': 'EGP',
      'formatted': '100.00 EGP',
    },
    'previousUnitPrice': null,
    'lineTotal': <String, dynamic>{
      'amount': 10000 * quantity,
      'currency': 'EGP',
      'formatted': '${100 * quantity}.00 EGP',
    },
    'status': 'OK',
    'addedAt': '2026-01-01T00:00:00.000Z',
  };
}

CartDto _cart(List<Map<String, dynamic>> items) {
  return CartDto.fromJson(<String, dynamic>{
    'items': items,
    'itemCount': items.length,
    'totalQuantity': items.fold<int>(
      0,
      (int sum, Map<String, dynamic> l) => sum + (l['quantity'] as int),
    ),
    'itemsSubtotal': <String, dynamic>{
      'amount': 10000,
      'currency': 'EGP',
      'formatted': '100.00 EGP',
    },
    'currency': 'EGP',
    'hasBlockingIssues': false,
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'expiresAt': '2026-01-02T00:00:00.000Z',
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
    registerFallbackValue(
      const GuestCartLineDto(productId: '', quantity: 0),
    );
  });

  late _MockCartRepository repository;

  ProviderContainer buildContainer({required bool authed}) {
    return ProviderContainer(
      overrides: <Override>[
        cartRepositoryProvider.overrideWithValue(repository),
        authControllerProvider.overrideWith(
          () => _FakeAuthController(
            authed
                ? AuthState.authenticated(_user())
                : const AuthState.unauthenticated(),
          ),
        ),
      ],
    );
  }

  setUp(() async {
    repository = _MockCartRepository();
    // Guest lines live in process-global mock SharedPreferences; clear
    // them so each test starts with an empty basket.
    await (await SharedPreferences.getInstance()).clear();
  });

  test('authed: loads the server cart', () async {
    when(
      () => repository.getCart(),
    ).thenAnswer((_) async => _cart(<Map<String, dynamic>>[_lineJson('p1', 2)]));

    final ProviderContainer container = buildContainer(authed: true);
    addTearDown(container.dispose);
    container.read(cartControllerProvider.notifier);
    await _pump();

    final CartState state = container.read(cartControllerProvider);
    expect(state.isLoading, false);
    expect(state.totalQuantity, 2);
    expect(state.cart?.items.single.slug, 'slug-p1');
  });

  test('authed: add/update/remove call the API and replace the cart',
      () async {
    when(() => repository.getCart()).thenAnswer(
      (_) async => _cart(const <Map<String, dynamic>>[]),
    );
    when(() => repository.addItem(any(), any())).thenAnswer(
      (_) async => _cart(<Map<String, dynamic>>[_lineJson('p1', 1)]),
    );
    when(() => repository.updateItem(any(), any())).thenAnswer(
      (_) async => _cart(<Map<String, dynamic>>[_lineJson('p1', 3)]),
    );
    when(() => repository.removeItem(any())).thenAnswer(
      (_) async => _cart(const <Map<String, dynamic>>[]),
    );

    final ProviderContainer container = buildContainer(authed: true);
    addTearDown(container.dispose);
    final CartController controller = container.read(
      cartControllerProvider.notifier,
    );
    await _pump();

    expect(await controller.add('p1', 1), true);
    expect(container.read(cartControllerProvider).totalQuantity, 1);
    expect(await controller.updateQuantity('p1', 3), true);
    expect(container.read(cartControllerProvider).totalQuantity, 3);
    expect(await controller.remove('p1'), true);
    expect(container.read(cartControllerProvider).totalQuantity, 0);
    verify(() => repository.addItem('p1', 1)).called(1);
    verify(() => repository.updateItem('p1', 3)).called(1);
    verify(() => repository.removeItem('p1')).called(1);
  });

  test('guest: add merges local lines and previews them', () async {
    when(() => repository.preview(any())).thenAnswer(
      (Invocation inv) async {
        final List<GuestCartLineDto> lines =
            inv.positionalArguments[0] as List<GuestCartLineDto>;
        return _cart(
          lines
              .map(
                (GuestCartLineDto l) =>
                    _lineJson(l.productId, l.quantity),
              )
              .toList(),
        );
      },
    );

    final ProviderContainer container = buildContainer(authed: false);
    addTearDown(container.dispose);
    final CartController controller = container.read(
      cartControllerProvider.notifier,
    );
    await _pump();
    expect(container.read(cartControllerProvider).isEmpty, true);

    expect(await controller.add('p1', 1), true);
    expect(await controller.add('p1', 2), true);
    expect(container.read(cartControllerProvider).totalQuantity, 3);
    expect(
      container.read(cartControllerProvider).guestLines.single.quantity,
      3,
    );

    // The lines survive a fresh load from storage.
    final List<GuestCartLineDto> stored = await GuestCartStorage().load();
    expect(stored.single.productId, 'p1');
    expect(stored.single.quantity, 3);
    verify(() => repository.preview(any())).called(2);
    verifyNever(() => repository.addItem(any(), any()));
  });

  test('guest lines move into the account on explicit request', () async {
    when(() => repository.preview(any())).thenAnswer(
      (_) async => _cart(<Map<String, dynamic>>[_lineJson('p1', 2)]),
    );
    when(() => repository.getCart()).thenAnswer(
      (_) async => _cart(const <Map<String, dynamic>>[]),
    );
    when(() => repository.addItem(any(), any())).thenAnswer(
      (_) async => _cart(<Map<String, dynamic>>[_lineJson('p1', 2)]),
    );

    // Guest adds lines first.
    final ProviderContainer guestContainer = buildContainer(authed: false);
    addTearDown(guestContainer.dispose);
    await guestContainer.read(cartControllerProvider.notifier).add('p1', 2);
    await _pump();
    expect(
      guestContainer.read(cartControllerProvider).guestLines.length,
      1,
    );

    // Then signs in: a fresh authed container sees the guest lines and
    // moves them on request.
    final ProviderContainer authedContainer = buildContainer(authed: true);
    addTearDown(authedContainer.dispose);
    authedContainer.read(cartControllerProvider.notifier);
    await _pump();
    expect(
      authedContainer.read(cartControllerProvider).guestLines.length,
      1,
    );
    expect(
      await authedContainer
          .read(cartControllerProvider.notifier)
          .moveGuestLinesToAccount(),
      true,
    );
    verify(() => repository.addItem('p1', 2)).called(1);
    expect(
      authedContainer.read(cartControllerProvider).guestLines,
      isEmpty,
    );
    expect(await GuestCartStorage().load(), isEmpty);
  });
}
