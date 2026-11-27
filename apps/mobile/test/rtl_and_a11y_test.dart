import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/brand.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/core/theme/app_theme.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/data/product_query.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_list_screen.dart';
import 'package:nest_electro/src/features/home/presentation/home_screen.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

PaginatedList<ProductListItemDto> _emptyPage() {
  return PaginatedList<ProductListItemDto>(
    items: const <ProductListItemDto>[],
    meta: PaginationMetaDto(
      page: 1,
      limit: 10,
      total: 0,
      totalPages: 0,
      hasNext: false,
      hasPrev: false,
    ),
  );
}

ProductListItemDto _item(String slug, String name) {
  return ProductListItemDto.fromJson(<String, dynamic>{
    'id': 'id-$slug',
    'slug': slug,
    'sku': 'SKU-$slug',
    'name': name,
    'shortDescription': 'Short.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'tools',
      'name': 'Tools & Equipment',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'salePrice': null,
      'effectivePrice': <String, dynamic>{
        'amount': 10000,
        'currency': 'EGP',
        'formatted': '100.00 EGP',
      },
      'discountPercentBps': 0,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.0, 'count': 1},
    'availability': 'IN_STOCK',
    'isFeatured': false,
  });
}

Future<void> _pumpAr(
  WidgetTester tester,
  _MockCatalogueRepository repository,
  Widget child,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        catalogueRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        // No theme: AppTheme uses google_fonts, which tries to fetch fonts
        // over the network and fails inside the test zone. The default
        // Material theme is enough for the RTL assertions; the contrast
        // tests below read the scheme values without rendering text.
        home: child,
      ),
    ),
  );
  // Manual pumps: the home hero has an 8-second auto-advance timer that
  // never settles under pumpAndSettle (D-19).
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

/// WCAG relative luminance, per https://www.w3.org/TR/WCAG20/#relativeluminancedef
double _luminance(Color color) {
  double channel(int value) {
    final double c = value / 255;
    return c <= 0.03928
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4) as double;
  }

  return 0.2126 * channel((color.r * 255.0).round() & 0xff) +
      0.7152 * channel((color.g * 255.0).round() & 0xff) +
      0.0722 * channel((color.b * 255.0).round() & 0xff);
}

double _contrast(Color foreground, Color background) {
  final double l1 = _luminance(foreground);
  final double l2 = _luminance(background);
  final double lighter = math.max(l1, l2);
  final double darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  setUpAll(() {
    registerFallbackValue(const ProductQuery());
  });

  group('RTL (Arabic default)', () {
    testWidgets('home renders right-to-left with Arabic strings', (
      WidgetTester tester,
    ) async {
      final _MockCatalogueRepository repository = _MockCatalogueRepository();
      when(
        () => repository.listCategories(),
      ).thenAnswer((_) async => <CategoryDto>[]);
      when(() => repository.listBrands()).thenAnswer((_) async => <BrandDto>[]);
      when(
        () => repository.listProducts(any()),
      ).thenAnswer((_) async => _emptyPage());

      await _pumpAr(tester, repository, const HomeScreen());

      expect(find.text('نيست إلكترو'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('نيست إلكترو'))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('product list renders right-to-left with Arabic count', (
      WidgetTester tester,
    ) async {
      final _MockCatalogueRepository repository = _MockCatalogueRepository();
      when(() => repository.listProducts(any())).thenAnswer(
        (_) async => PaginatedList<ProductListItemDto>(
          items: <ProductListItemDto>[
            _item('a', 'Screwdriver Set'),
            _item('b', 'ESP32 Board'),
          ],
          meta: PaginationMetaDto(
            page: 1,
            limit: 12,
            total: 2,
            totalPages: 1,
            hasNext: false,
            hasPrev: false,
          ),
        ),
      );

      await _pumpAr(
        tester,
        repository,
        const ProductListScreen(query: ProductQuery()),
      );

      expect(find.text('المنتجات'), findsOneWidget);
      expect(find.text('عدد المنتجات: 2'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('المنتجات'))),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('theme contrast (WCAG AA, normal text >= 4.5:1)', () {
    // The schemes are built from the same AppColors tokens as
    // AppTheme.light/dark. Constructing AppTheme itself in a test triggers
    // google_fonts runtime font loading, which cannot run in the test
    // zone (the fonts are fetched, not bundled), so the test pins the
    // token wiring directly. If AppTheme's scheme arguments change, copy
    // the change here.
    const ColorScheme lightScheme = ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightForeground,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightForeground,
      surfaceContainerLow: AppColors.lightMuted,
      error: AppColors.lightDanger,
      onError: Colors.white,
      outline: AppColors.lightBorder,
      tertiary: AppColors.lightSuccess,
    );
    const ColorScheme darkScheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkBackground,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkForeground,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkForeground,
      surfaceContainerLow: AppColors.darkSecondary,
      error: AppColors.darkDanger,
      onError: AppColors.darkBackground,
      outline: AppColors.darkBorder,
      tertiary: AppColors.darkSuccess,
    );

    void checkScheme(String name, ColorScheme scheme) {
      test(name, () {
        final Map<String, (Color, Color)> pairs = <String, (Color, Color)>{
          'onSurface / surface': (scheme.onSurface, scheme.surface),
          'onPrimary / primary': (scheme.onPrimary, scheme.primary),
          'onSecondary / secondary': (scheme.onSecondary, scheme.secondary),
          'onError / error': (scheme.onError, scheme.error),
          'onSurfaceVariant / surface': (
            scheme.onSurfaceVariant,
            scheme.surface,
          ),
        };
        for (final MapEntry<String, (Color, Color)> entry in pairs.entries) {
          final double ratio = _contrast(entry.value.$1, entry.value.$2);
          expect(
            ratio,
            greaterThanOrEqualTo(4.5),
            reason: '${entry.key} contrast is ${ratio.toStringAsFixed(2)}:1',
          );
        }
      });
    }

    checkScheme('light theme', lightScheme);
    checkScheme('dark theme', darkScheme);
  });
}
