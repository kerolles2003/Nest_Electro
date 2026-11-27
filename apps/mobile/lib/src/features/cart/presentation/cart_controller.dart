import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/models/cart.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/cart/data/cart_repository.dart';
import 'package:nest_electro/src/features/cart/data/guest_cart_storage.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(client: ref.watch(apiClientProvider));
});

final guestCartStorageProvider = Provider<GuestCartStorage>((_) {
  return GuestCartStorage();
});

/// One cart, two homes. Signed-in users have a server cart (`GET /cart`);
/// guests have local lines priced on demand by `POST /cart/preview`. The
/// UI never distinguishes the two — `cart` is a priced `CartDto` either
/// way, and `guestLines` is non-empty only for guests (or for a signed-in
/// user who still has an unmoved guest basket).
class CartState {
  const CartState({
    this.cart,
    this.guestLines = const <GuestCartLineDto>[],
    this.isLoading = true,
    this.isBusy = false,
    this.error,
  });

  final CartDto? cart;
  final List<GuestCartLineDto> guestLines;
  final bool isLoading;
  final bool isBusy;
  final ApiException? error;

  int get totalQuantity => cart?.totalQuantity ?? 0;

  bool get isEmpty => totalQuantity == 0 && guestLines.isEmpty;

  CartState copyWith({
    CartDto? cart,
    bool clearCart = false,
    List<GuestCartLineDto>? guestLines,
    bool? isLoading,
    bool? isBusy,
    ApiException? error,
    bool clearError = false,
  }) {
    return CartState(
      cart: clearCart ? null : (cart ?? this.cart),
      guestLines: guestLines ?? this.guestLines,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CartController extends Notifier<CartState> {
  @override
  CartState build() {
    // Rebuilds (and reloads) when the session changes — login/logout
    // switches the cart between the server cart and the guest basket.
    ref.watch(authControllerProvider);
    Future.microtask(_load);
    return const CartState();
  }

  CartRepository get _repo => ref.read(cartRepositoryProvider);
  GuestCartStorage get _storage => ref.read(guestCartStorageProvider);
  bool get _authed =>
      ref.read(authControllerProvider).isAuthenticated;

  Future<void> _load() async {
    try {
      if (_authed) {
        final CartDto cart = await _repo.getCart();
        final List<GuestCartLineDto> lines = await _storage.load();
        state = state.copyWith(
          cart: cart,
          guestLines: lines,
          isLoading: false,
          clearError: true,
        );
      } else {
        final List<GuestCartLineDto> lines = await _storage.load();
        if (lines.isEmpty) {
          state = state.copyWith(
            clearCart: true,
            guestLines: lines,
            isLoading: false,
            clearError: true,
          );
        } else {
          final CartDto preview = await _repo.preview(lines);
          state = state.copyWith(
            cart: preview,
            guestLines: lines,
            isLoading: false,
            clearError: true,
          );
        }
      }
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _load();
  }

  /// Adds [quantity] of [productId]. Guests merge into local lines;
  /// signed-in users hit the API. Returns false when the call failed
  /// (the error is in state for the UI to show).
  Future<bool> add(String productId, int quantity) async {
    if (state.isBusy) return false;
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      if (_authed) {
        state = state.copyWith(
          cart: await _repo.addItem(productId, quantity),
          isBusy: false,
        );
      } else {
        final List<GuestCartLineDto> lines = await _guestAdd(
          productId,
          quantity,
        );
        state = state.copyWith(
          cart: await _repo.preview(lines),
          guestLines: lines,
          isBusy: false,
        );
      }
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }

  Future<List<GuestCartLineDto>> _guestAdd(
    String productId,
    int quantity,
  ) async {
    final List<GuestCartLineDto> lines = await _storage.load();
    final int index = lines.indexWhere(
      (GuestCartLineDto l) => l.productId == productId,
    );
    final List<GuestCartLineDto> next = List<GuestCartLineDto>.of(lines);
    if (index >= 0) {
      final GuestCartLineDto existing = next[index];
      next[index] = GuestCartLineDto(
        productId: productId,
        quantity: existing.quantity + quantity,
      );
    } else {
      next.add(GuestCartLineDto(productId: productId, quantity: quantity));
    }
    await _storage.save(next);
    return next;
  }

  Future<bool> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      return remove(productId);
    }
    if (state.isBusy) return false;
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      if (_authed) {
        state = state.copyWith(
          cart: await _repo.updateItem(productId, quantity),
          isBusy: false,
        );
      } else {
        final List<GuestCartLineDto> lines = await _guestSetQuantity(
          productId,
          quantity,
        );
        state = state.copyWith(
          cart: await _repo.preview(lines),
          guestLines: lines,
          isBusy: false,
        );
      }
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }

  Future<List<GuestCartLineDto>> _guestSetQuantity(
    String productId,
    int quantity,
  ) async {
    final List<GuestCartLineDto> lines = await _storage.load();
    final List<GuestCartLineDto> next = lines
        .map(
          (GuestCartLineDto l) => l.productId == productId
              ? GuestCartLineDto(productId: productId, quantity: quantity)
              : l,
        )
        .toList();
    await _storage.save(next);
    return next;
  }

  Future<bool> remove(String productId) async {
    if (state.isBusy) return false;
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      if (_authed) {
        state = state.copyWith(
          cart: await _repo.removeItem(productId),
          isBusy: false,
        );
      } else {
        final List<GuestCartLineDto> lines = await _storage.load();
        final List<GuestCartLineDto> next = lines
            .where((GuestCartLineDto l) => l.productId != productId)
            .toList();
        await _storage.save(next);
        if (next.isEmpty) {
          state = state.copyWith(
            clearCart: true,
            guestLines: next,
            isBusy: false,
          );
        } else {
          state = state.copyWith(
            cart: await _repo.preview(next),
            guestLines: next,
            isBusy: false,
          );
        }
      }
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }

  Future<bool> clear() async {
    if (state.isBusy) return false;
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      if (_authed) {
        state = state.copyWith(
          cart: await _repo.clearCart(),
          isBusy: false,
        );
      } else {
        await _storage.clear();
        state = state.copyWith(
          clearCart: true,
          guestLines: const <GuestCartLineDto>[],
          isBusy: false,
        );
      }
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }

  /// Moves the local guest basket into the server cart, line by line, in
  /// order — the server cart is one document, so the adds are sequential,
  /// not parallel. Only ever runs on an explicit user tap (see the cart
  /// screen banner); never on login. Returns false on the first failure
  /// (lines already moved stay moved; the rest stay local).
  Future<bool> moveGuestLinesToAccount() async {
    final List<GuestCartLineDto> lines = state.guestLines;
    if (!_authed || lines.isEmpty || state.isBusy) {
      return false;
    }
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      CartDto cart = state.cart ?? await _repo.getCart();
      for (final GuestCartLineDto line in lines) {
        cart = await _repo.addItem(line.productId, line.quantity);
      }
      await _storage.clear();
      state = state.copyWith(
        cart: cart,
        guestLines: const <GuestCartLineDto>[],
        isBusy: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }
}

final cartControllerProvider = NotifierProvider<CartController, CartState>(
  CartController.new,
);
