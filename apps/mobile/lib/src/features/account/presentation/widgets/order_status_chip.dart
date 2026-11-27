import 'package:flutter/material.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/enums.dart';

/// Localised labels for order and payment statuses, shared by the order
/// history and order detail screens.
String orderStatusLabel(AppLocalizations l10n, OrderStatus status) {
  return switch (status) {
    OrderStatus.placed => l10n.orderStatusPlaced,
    OrderStatus.confirmed => l10n.orderStatusConfirmed,
    OrderStatus.shipped => l10n.orderStatusShipped,
    OrderStatus.delivered => l10n.orderStatusDelivered,
    OrderStatus.deliveryFailed => l10n.orderStatusDeliveryFailed,
    OrderStatus.cancelled => l10n.orderStatusCancelled,
    OrderStatus.returned => l10n.orderStatusReturned,
    OrderStatus.unknown => l10n.orderStatusUnknown,
  };
}

String paymentStatusLabel(AppLocalizations l10n, PaymentStatus status) {
  return switch (status) {
    PaymentStatus.pending => l10n.orderPaymentStatusPending,
    PaymentStatus.pendingVerification =>
      l10n.orderPaymentStatusPendingVerification,
    PaymentStatus.verificationRejected => l10n.orderPaymentStatusRejected,
    PaymentStatus.paid => l10n.orderPaymentStatusPaid,
    PaymentStatus.refunded => l10n.orderPaymentStatusRefunded,
    PaymentStatus.unknown => l10n.orderStatusUnknown,
  };
}

/// Status chip coloured by order state: green for delivered/paid, red for
/// cancelled/failed, amber for in-flight.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color = switch (status) {
      OrderStatus.delivered => scheme.primary,
      OrderStatus.cancelled ||
      OrderStatus.deliveryFailed ||
      OrderStatus.returned => scheme.error,
      OrderStatus.unknown => scheme.outline,
      _ => Colors.orange.shade800,
    };
    return Chip(
      label: Text(orderStatusLabel(l10n, status)),
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
    );
  }
}
