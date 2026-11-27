import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nest_electro/src/app.dart';

void main() {
  setUpAll(() {
    // No network in tests: fall back to system fonts instead of fetching
    // Google Fonts at runtime.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('app boots to the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NestElectroApp()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-screen')), findsOneWidget);
    expect(find.text('نيست إلكترو'), findsOneWidget);
  });
}
