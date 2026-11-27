import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/category.dart';
import 'package:nest_electro/src/features/catalogue/data/catalogue_repository.dart';
import 'package:nest_electro/src/features/catalogue/presentation/catalogue_providers.dart';
import 'package:nest_electro/src/features/catalogue/presentation/categories_screen.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

CategoryDto _category(String id, String slug, String name, {String? parentId}) {
  return CategoryDto.fromJson(<String, dynamic>{
    'id': id,
    'slug': slug,
    'name': name,
    'description': '',
    'parentId': parentId,
    'depth': parentId == null ? 0 : 1,
    'image': null,
    'productCount': 3,
    'sortOrder': 0,
  });
}

Future<void> _pumpScreen(
  WidgetTester tester,
  _MockCatalogueRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        catalogueRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const CategoriesScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('shows roots with children grouped under them',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.listCategories()).thenAnswer(
      (_) async => <CategoryDto>[
        _category('c1', 'tools', 'Tools & Equipment'),
        _category('c2', 'screwdrivers', 'Screwdrivers', parentId: 'c1'),
        _category('c3', 'sensors', 'Sensors'),
      ],
    );

    await _pumpScreen(tester, repository);

    expect(find.text('Tools & Equipment'), findsOneWidget);
    expect(find.text('Sensors'), findsOneWidget);
    // The child is inside an ExpansionTile, so it is not rendered until
    // the tile is expanded.
    expect(find.text('Screwdrivers'), findsNothing);
    await tester.tap(find.text('Tools & Equipment'));
    await tester.pump();
    expect(find.text('Screwdrivers'), findsOneWidget);
  });

  testWidgets('shows the error state with a retry that reloads',
      (WidgetTester tester) async {
    final _MockCatalogueRepository repository = _MockCatalogueRepository();
    when(() => repository.listCategories()).thenThrow(
      const ApiException(code: 'NETWORK_ERROR', message: 'boom'),
    );

    await _pumpScreen(tester, repository);

    expect(find.text("Couldn't load products"), findsOneWidget);
    when(() => repository.listCategories()).thenAnswer(
      (_) async => <CategoryDto>[_category('c1', 'tools', 'Tools')],
    );
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Tools'), findsOneWidget);
  });
}
