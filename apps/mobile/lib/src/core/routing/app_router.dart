import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';
import 'package:nest_electro/src/features/auth/presentation/forgot_password_screen.dart';
import 'package:nest_electro/src/features/auth/presentation/login_screen.dart';
import 'package:nest_electro/src/features/auth/presentation/register_screen.dart';
import 'package:nest_electro/src/features/auth/presentation/reset_password_screen.dart';
import 'package:nest_electro/src/features/auth/presentation/verify_email_screen.dart';
import 'package:nest_electro/src/features/account/presentation/account_screen.dart';
import 'package:nest_electro/src/features/account/presentation/addresses_screen.dart';
import 'package:nest_electro/src/features/account/presentation/order_detail_screen.dart';
import 'package:nest_electro/src/features/account/presentation/orders_screen.dart';
import 'package:nest_electro/src/features/account/presentation/profile_screen.dart';
import 'package:nest_electro/src/features/account/presentation/wishlist_screen.dart';
import 'package:nest_electro/src/features/cart/presentation/cart_screen.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/brand_screen.dart';
import 'package:nest_electro/src/features/catalogue/presentation/categories_screen.dart';
import 'package:nest_electro/src/features/catalogue/presentation/category_screen.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_detail_screen.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_list_screen.dart';
import 'package:nest_electro/src/features/catalogue/presentation/search_screen.dart';
import 'package:nest_electro/src/features/checkout/presentation/checkout_screen.dart';
import 'package:nest_electro/src/features/checkout/presentation/order_confirmation_screen.dart';
import 'package:nest_electro/src/features/common/presentation/placeholder_screen.dart';
import 'package:nest_electro/src/features/home/presentation/home_screen.dart';

/// Routes that require a session. Guests are sent to /login with the
/// original location kept in `?redirect=...`. Note `/cart` is NOT here:
/// guests keep a local basket priced by `POST /cart/preview` (D-20); only
/// checkout (which places the order) needs a session.
const Set<String> _authOnlyPaths = <String>{
  '/checkout',
  '/account',
};

/// Routes that make no sense while logged in.
const Set<String> _guestOnlyPaths = <String>{
  '/login',
  '/register',
};

bool _isAuthOnly(String location) {
  if (_authOnlyPaths.contains(location)) {
    return true;
  }
  return location.startsWith('/account/') ||
      location.startsWith('/checkout/');
}

/// Builds a [ProductQuery] from the listing URL. Params mirror the web
/// listing (`app/products/search-params.ts`): prices in EGP (converted to
/// piastres here), `in_stock`/`featured` as flags, `sort` as the API
/// string. Unknown sorts fall back to `newest`.
ProductQuery _productQueryFromUri(GoRouterState state) {
  final Map<String, String> params = state.uri.queryParameters;
  int? price(String key) {
    final int? egp = int.tryParse(params[key] ?? '');
    return egp == null ? null : egp * 100;
  }

  final ProductSort sort = ProductSort.values
      .where((ProductSort s) => s.value == params['sort'])
      .firstOrNull ?? ProductSort.newest;

  return ProductQuery(
    page: int.tryParse(params['page'] ?? '') ?? 1,
    q: params['q'],
    category: params['category'],
    brand: params['brand'],
    minPrice: price('min_price'),
    maxPrice: price('max_price'),
    inStock: params['in_stock'] == 'true',
    featured: params['featured'] == 'true',
    spec: params['spec'],
    sort: sort,
  );
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Route table mirroring the storefront (see SCREENS.md).
/// Screens land in their phases; until then each route shows a clearly
/// labelled placeholder so the app always builds and navigates.
/// The router is a provider so the redirect can read auth state, and it
/// re-runs the redirect whenever the auth state changes.
final appRouterProvider = Provider<GoRouter>((ref) {
  final _RouterRefreshNotifier refreshNotifier = _RouterRefreshNotifier();
  ref.listen<AuthState>(
    authControllerProvider,
    (_, __) => refreshNotifier.refresh(),
  );
  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState auth = ref.read(authControllerProvider);
      final bool loggedIn = auth.isAuthenticated;
      final String location = state.uri.path;
      if (!loggedIn && _isAuthOnly(location)) {
        return '/login?redirect=${Uri.encodeComponent(location)}';
      }
      if (loggedIn && _guestOnlyPaths.contains(location)) {
        return '/';
      }
      return null;
    },
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const PlaceholderScreen(label: 'not-found'),
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (BuildContext context, GoRouterState state) =>
            ProductListScreen(query: _productQueryFromUri(state)),
      ),
      GoRoute(
        path: '/products/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            ProductDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/categories',
        builder: (BuildContext context, GoRouterState state) =>
            const CategoriesScreen(),
      ),
      GoRoute(
        path: '/categories/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            CategoryScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/brands/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            BrandScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) =>
            const SearchScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (BuildContext context, GoRouterState state) =>
            const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (BuildContext context, GoRouterState state) =>
            const CheckoutScreen(),
      ),
      GoRoute(
        path: '/checkout/confirmation',
        builder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;
          if (extra is! OrderConfirmationArgs) {
            return const PlaceholderScreen(label: 'not-found');
          }
          return OrderConfirmationScreen(args: extra);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => LoginScreen(
          redirect: state.uri.queryParameters['redirect'],
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/forgot-password/reset',
        builder: (BuildContext context, GoRouterState state) =>
            ResetPasswordScreen(
          token: state.uri.queryParameters['token'],
        ),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (BuildContext context, GoRouterState state) =>
            VerifyEmailScreen(
          token: state.uri.queryParameters['token'],
          email: state.uri.queryParameters['email'],
          registered: state.uri.queryParameters['registered'] == 'true',
        ),
      ),
      GoRoute(
        path: '/account',
        builder: (BuildContext context, GoRouterState state) =>
            const AccountScreen(),
      ),
      GoRoute(
        path: '/account/profile',
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
      ),
      GoRoute(
        path: '/account/orders',
        builder: (BuildContext context, GoRouterState state) =>
            const OrdersScreen(),
      ),
      GoRoute(
        path: '/account/orders/:id',
        builder: (BuildContext context, GoRouterState state) =>
            OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/account/addresses',
        builder: (BuildContext context, GoRouterState state) =>
            const AddressesScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (BuildContext context, GoRouterState state) =>
            const WishlistScreen(),
      ),
      GoRoute(
        path: '/blog',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'blog'),
      ),
      GoRoute(
        path: '/blog/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'blog-post'),
      ),
      GoRoute(
        path: '/contact',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'contact'),
      ),
    ],
  );
});

/// Localised titles for placeholder routes (kept here so placeholders stay
/// honest about which screen they stand in for).
extension PlaceholderTitles on BuildContext {
  String placeholderTitle(String label) {
    final AppLocalizations l10n = AppLocalizations.of(this)!;
    return switch (label) {
      'products' => l10n.productsTitle,
      'product-details' => l10n.productDetailsTitle,
      'categories' => l10n.categoriesTitle,
      'category' => l10n.categoriesTitle,
      'brand' => l10n.categoriesTitle,
      'search' => l10n.navSearch,
      'cart' => l10n.cartTitle,
      'checkout' => l10n.checkoutTitle,
      'login' => l10n.loginTitle,
      'register' => l10n.registerTitle,
      'forgot-password' => l10n.forgotPasswordTitle,
      'forgot-password-reset' => l10n.forgotPasswordTitle,
      'verify-email' => l10n.registerTitle,
      'account' => l10n.accountTitle,
      'profile' => l10n.profileTitle,
      'orders' => l10n.ordersTitle,
      'order-details' => l10n.orderDetailsTitle,
      'addresses' => l10n.addressesTitle,
      'wishlist' => l10n.wishlistTitle,
      'blog' => l10n.blogTitle,
      'blog-post' => l10n.blogTitle,
      'contact' => l10n.contactTitle,
      'not-found' => l10n.pageNotFound,
      _ => label,
    };
  }
}
