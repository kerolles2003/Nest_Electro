import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/features/account/data/wishlist_repository.dart';
import 'package:nest_electro/src/features/account/presentation/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  late GoRouter router;

  setUp(() async {
    await (await SharedPreferences.getInstance()).clear();
    router = GoRouter(
      initialLocation: '/wishlist',
      routes: <RouteBase>[
        GoRoute(
          path: '/wishlist',
          builder: (BuildContext context, GoRouterState state) =>
              const WishlistScreen(),
        ),
        GoRoute(
          path: '/products/:slug',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('product')),
        ),
      ],
    );
  });

  Future<void> pumpWishlist(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empty wishlist shows the local-only note',
      (WidgetTester tester) async {
    await pumpWishlist(tester);

    expect(
      find.text('Saved on this device only — the API has no wishlist yet.'),
      findsOneWidget,
    );
    expect(find.text('Your wishlist is empty.'), findsOneWidget);
  });

  testWidgets('saved items render and can be removed',
      (WidgetTester tester) async {
    await (await SharedPreferences.getInstance()).setString(
      WishlistRepository.storageKey,
      jsonEncode(<Map<String, dynamic>>[
        <String, dynamic>{
          'productId': 'p1',
          'slug': 'slug-p1',
          'name': 'Product p1',
          'imagePublicId': 'nest/products/p1/img',
          'priceFormatted': '380.00 EGP',
        },
      ]),
    );

    await pumpWishlist(tester);

    expect(find.text('Product p1'), findsOneWidget);
    expect(find.text('380.00 EGP'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Product p1'), findsNothing);
    expect(find.text('Your wishlist is empty.'), findsOneWidget);
  });

  testWidgets('tapping an item opens its product page',
      (WidgetTester tester) async {
    await (await SharedPreferences.getInstance()).setString(
      WishlistRepository.storageKey,
      jsonEncode(<Map<String, dynamic>>[
        <String, dynamic>{
          'productId': 'p1',
          'slug': 'slug-p1',
          'name': 'Product p1',
          'imagePublicId': '',
          'priceFormatted': '380.00 EGP',
        },
      ]),
    );

    await pumpWishlist(tester);
    await tester.tap(find.text('Product p1'));
    await tester.pumpAndSettle();
    expect(find.text('product'), findsOneWidget);
  });
}
