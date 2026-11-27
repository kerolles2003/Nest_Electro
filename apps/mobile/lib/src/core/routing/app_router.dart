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
import 'package:nest_electro/src/features/common/presentation/placeholder_screen.dart';
import 'package:nest_electro/src/features/home/presentation/home_screen.dart';

/// Routes that require a session. Guests are sent to /login with the
/// original location kept in `?redirect=...`.
const Set<String> _authOnlyPaths = <String>{
  '/cart',
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
  return location.startsWith('/account/');
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
            const PlaceholderScreen(label: 'products'),
      ),
      GoRoute(
        path: '/products/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'product-details'),
      ),
      GoRoute(
        path: '/categories',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'categories'),
      ),
      GoRoute(
        path: '/categories/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'category'),
      ),
      GoRoute(
        path: '/brands/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'brand'),
      ),
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'search'),
      ),
      GoRoute(
        path: '/cart',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'cart'),
      ),
      GoRoute(
        path: '/checkout',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'checkout'),
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
            const PlaceholderScreen(label: 'account'),
      ),
      GoRoute(
        path: '/account/profile',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'profile'),
      ),
      GoRoute(
        path: '/account/orders',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'orders'),
      ),
      GoRoute(
        path: '/account/orders/:id',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'order-details'),
      ),
      GoRoute(
        path: '/account/addresses',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'addresses'),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (BuildContext context, GoRouterState state) =>
            const PlaceholderScreen(label: 'wishlist'),
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
