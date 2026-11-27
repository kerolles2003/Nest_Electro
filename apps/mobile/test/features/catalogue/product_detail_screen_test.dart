import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/product_detail_screen.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

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
    'brand': <String, dynamic>{
      'id': 'b1',
      'slug': 'espressif',
      'name': 'Espressif',
    },
    'pricing': <String, dynamic>{
      'basePrice': <String, dynamic>{
        'amount': 25000,
        'currency': 'EGP',
        'formatted': '250.00 EGP',
      },
      'salePrice': <String, dynamic>{
        'amount': 20000,
        'currency': 'EGP',
        'formatted': '200.00 EGP',
      },
      'effectivePrice': <String, dynamic>{
        'amount': 20000,
        'currency': 'EGP',
        'formatted': '200.00 EGP',
      },
      'discountPercentBps': 2000,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.5, 'count': 12},
    'availability': 'IN_STOCK',
    'isFeatured': true,
    'description': 'Full description of the board.',
    'images': <dynamic>[],
    'specs': <dynamic>[
      <String, dynamic>{
        'key': 'mcu',
        'label': 'Microcontroller',
        'value': 'ESP32-S3',
        'unit': null,
        'filterable': true,
      },
      <String, dynamic>{
        'key': 'flash',
        'label': 'Flash',
        'value': '8',
        'unit': 'MB',
        'filterable': false,
      },
    ],
    'stockOnHand': 14,
    'salesCount': 42,
    'weight': 0.05,
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-02T00:00:00.000Z',
  });
}

ProductListItemDto _relatedItem() {
  return ProductListItemDto.fromJson(<String, dynamic>{
    'id': 'id-b',
    'slug': 'esp32-cam',
    'sku': 'ESP32-CAM',
    'name': 'ESP32-CAM Module',
    'shortDescription': 'Camera module.',
    'category': <String, dynamic>{
      'id': 'c1',
      'slug': 'microcontrollers',
      'name': 'Microcontrollers',
    },
    'brand': null,
    'pricing': <String, dynamic>{
      'basePrice': <String, dynamic>{
        'amount': 15000,
        'currency': 'EGP',
        'formatted': '150.00 EGP',
      },
      'salePrice': null,
      'effectivePrice': <String, dynamic>{
        'amount': 15000,
        'currency': 'EGP',
        'formatted': '150.00 EGP',
      },
      'discountPercentBps': 0,
    },
    'primaryImage': null,
    'rating': <String, dynamic>{'average': 4.0, 'count': 2},
    'availability': 'IN_STOCK',
    'isFeatured': false,
  });
}

void main() {
  testWidgets('renders price, specs and related products',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(
      () => repository.getProduct(any()),
    ).thenAnswer((_) async => _detail());
    when(
      () => repository.getRelated(any()),
    ).thenAnswer((_) async => <ProductListItemDto>[_relatedItem()]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          catalogueRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const ProductDetailScreen(slug: 'esp32-board'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ESP32 Dev Board'), findsWidgets);
    expect(find.text('200.00 EGP'), findsWidgets);
    expect(find.text('250.00 EGP'), findsOneWidget);
    expect(find.text('Microcontroller'), findsOneWidget);
    expect(find.text('ESP32-S3'), findsOneWidget);
    expect(find.text('8 MB'), findsOneWidget);
    expect(find.text('14 in stock'), findsOneWidget);
    expect(find.text('ESP32-CAM Module'), findsOneWidget);
    expect(find.text('Reviews are coming soon — this catalogue has no reviews yet.'),
        findsOneWidget);
  });
}
