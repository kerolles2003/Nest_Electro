import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/product.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/search_screen.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

void main() {
  testWidgets('typing shows debounced suggestions',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.suggest(any())).thenAnswer(
      (_) async => <ProductSuggestionDto>[
        ProductSuggestionDto.fromJson(<String, dynamic>{
          'slug': 'esp32-devkit-v1',
          'name': 'ESP32 DevKit V1',
          'sku': 'ESP32-DEVKIT-V1',
          'primaryImage': null,
        }),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          catalogueRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SearchScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Empty query: hint, no request.
    expect(find.textContaining('Search by name'), findsOneWidget);
    verifyNever(() => repository.suggest(any()));

    await tester.enterText(find.byType(TextField), 'esp32');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    verify(() => repository.suggest('esp32')).called(1);
    expect(find.text('ESP32 DevKit V1'), findsOneWidget);
    expect(find.text('ESP32-DEVKIT-V1'), findsOneWidget);
  });
}
