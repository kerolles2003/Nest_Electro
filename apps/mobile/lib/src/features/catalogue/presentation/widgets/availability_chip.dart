import 'package:flutter/material.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/enums.dart';

/// Small availability badge. Rendered only where the state needs
/// flagging — in-stock products show nothing (the storefront does the
/// same: availability is a fact, not a decoration).
class AvailabilityChip extends StatelessWidget {
  const AvailabilityChip({required this.availability, super.key});

  final Availability availability;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final (Color color, String label) = switch (availability) {
      Availability.inStock => (
        Theme.of(context).colorScheme.primary,
        l10n.availabilityInStock,
      ),
      Availability.lowStock => (
        Theme.of(context).colorScheme.tertiary,
        l10n.availabilityLowStock,
      ),
      Availability.outOfStock => (
        Theme.of(context).colorScheme.error,
        l10n.availabilityOutOfStock,
      ),
      Availability.unknown => (
        Theme.of(context).colorScheme.outline,
        l10n.availabilityOutOfStock,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
