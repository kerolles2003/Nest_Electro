import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_electro/src/app.dart';

void main() {
  // Phase 10: fonts are bundled (assets/fonts) — no runtime fetching,
  // so the smoke test needs no GoogleFonts config any more.
  testWidgets('app boots to the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NestElectroApp()));
    // No pumpAndSettle: the hero carousel's 8-second auto-advance timer
    // never settles, and the home providers hit the network. A few manual
    // pumps are enough — the scaffold, app bar and hero render at once.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const Key('home-screen')), findsOneWidget);
    expect(find.text('نيست إلكترو'), findsOneWidget);
  });
}
