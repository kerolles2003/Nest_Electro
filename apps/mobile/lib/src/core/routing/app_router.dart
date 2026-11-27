import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/common/presentation/placeholder_screen.dart';
import 'package:nest_electro/src/features/home/presentation/home_screen.dart';

/// Route table mirroring the storefront (see SCREENS.md).
/// Screens land in their phases; until then each route shows a clearly
/// labelled placeholder so the app always builds and navigates.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
      builder: (BuildContext context, GoRouterState state) =>
          const PlaceholderScreen(label: 'login'),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) =>
          const PlaceholderScreen(label: 'register'),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) =>
          const PlaceholderScreen(label: 'forgot-password'),
    ),
    GoRoute(
      path: '/forgot-password/reset',
      builder: (BuildContext context, GoRouterState state) =>
          const PlaceholderScreen(label: 'forgot-password-reset'),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (BuildContext context, GoRouterState state) =>
          const PlaceholderScreen(label: 'verify-email'),
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
