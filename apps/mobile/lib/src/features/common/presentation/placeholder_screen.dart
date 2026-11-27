import 'package:flutter/material.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/routing/app_router.dart';

/// Temporary stand-in for screens that land in later phases.
/// Shows the screen's localised title and a "coming soon" note so the route
/// table is fully navigable from Phase 1.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(context.placeholderTitle(label))),
      body: Center(
        child: Text(l10n.comingSoon),
      ),
    );
  }
}
