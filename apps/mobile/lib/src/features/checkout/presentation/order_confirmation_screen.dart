import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';

/// Arguments for the confirmation route (passed via `extra`): the placed
/// order plus the payment instructions that were in effect at checkout,
/// so the manual-payment details can be shown again here.
class OrderConfirmationArgs {
  const OrderConfirmationArgs({required this.order, this.instructions});

  final OrderDto order;
  final ManualPaymentInstructionsDto? instructions;
}

/// Order confirmation: order number, total, shipping address, and what
/// happens next for the payment method. Manual payments (wallet/InstaPay)
/// stay `PENDING_VERIFICATION` until an admin confirms the transfer — the
/// screen says so and shows the transfer target again.
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({required this.args, super.key});

  final OrderConfirmationArgs args;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final OrderDto order = args.order;
    final PaymentMethod method = order.payment?.method ?? PaymentMethod.cod;
    final ManualPaymentInstructionsDto? instructions = args.instructions;

    return Scaffold(
      key: const Key('order-confirmation-screen'),
      appBar: AppBar(title: Text(l10n.orderConfirmationTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.orderPlacedMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.orderNumber} ${order.orderNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      order.pricing.grandTotal.formatted,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.checkoutAddress,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${order.shippingAddress.fullName} • ${order.shippingAddress.street}, '
                '${order.shippingAddress.city}, ${order.shippingAddress.governorate}',
              ),
              const SizedBox(height: 16),
              Text(
                l10n.checkoutPaymentMethod,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(_paymentMethodLabel(l10n, method)),
              const SizedBox(height: 8),
              if (method == PaymentMethod.cod)
                Text(l10n.orderCodPending)
              else ...<Widget>[
                Text(l10n.orderPaymentPendingVerification),
                const SizedBox(height: 12),
                if (method == PaymentMethod.wallet &&
                    instructions?.walletNumber != null)
                  _CopyableRow(
                    label: 'Wallet',
                    value: instructions!.walletNumber,
                  ),
                if (method == PaymentMethod.instapay &&
                    instructions?.instapayAddress != null)
                  _CopyableRow(
                    label: 'InstaPay',
                    value: instructions!.instapayAddress,
                  ),
                if (instructions?.whatsappNumber != null &&
                    instructions!.whatsappNumber.isNotEmpty)
                  _CopyableRow(
                    label: 'WhatsApp',
                    value: instructions.whatsappNumber,
                  ),
              ],
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: Text(l10n.orderContinueShopping),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          context.push('/account/orders/${order.id}'),
                      child: Text(l10n.orderViewOrder),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _paymentMethodLabel(
    AppLocalizations l10n,
    PaymentMethod method,
  ) {
    return switch (method) {
      PaymentMethod.cod => l10n.trustCod,
      PaymentMethod.wallet => 'Wallet',
      PaymentMethod.instapay => 'InstaPay',
      PaymentMethod.unknown => method.name,
    };
  }
}

class _CopyableRow extends StatelessWidget {
  const _CopyableRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(child: SelectableText(value)),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            tooltip: label,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label: $value')),
              );
            },
          ),
        ],
      ),
    );
  }
}
