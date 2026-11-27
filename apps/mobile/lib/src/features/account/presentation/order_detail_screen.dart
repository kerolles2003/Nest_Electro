import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/features/account/presentation/orders_controller.dart';
import 'package:nest_electro/src/features/account/presentation/widgets/order_status_chip.dart';

/// Order detail: items, pricing, shipping address, payment state, shipment
/// and cancellation info. Cancel is offered for PLACED / CONFIRMED only
/// (the API is the final judge, 409 when the status moved on); payment
/// resubmit is offered when a wallet/InstaPay verification was rejected.
class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final TextEditingController _senderController = TextEditingController();

  @override
  void dispose() {
    _senderController.dispose();
    super.dispose();
  }

  Future<void> _cancel(OrderDto order) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextEditingController reasonController = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.orderCancelTitle),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            labelText: l10n.orderCancelReason,
            hintText: l10n.orderCancelReasonHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.orderCancelConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    final bool ok = await ref
        .read(orderDetailControllerProvider(widget.orderId).notifier)
        .cancel(
          reasonController.text.trim().isEmpty
              ? '—'
              : reasonController.text.trim(),
        );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.orderCancelled : l10n.errorGeneric),
      ),
    );
  }

  Future<void> _resubmit() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String sender = _senderController.text.trim();
    if (sender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.requiredField)),
      );
      return;
    }
    final bool ok = await ref
        .read(orderDetailControllerProvider(widget.orderId).notifier)
        .resubmitPayment(sender);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.orderResubmitted : l10n.errorGeneric),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final OrderDetailState state =
        ref.watch(orderDetailControllerProvider(widget.orderId));
    ref.listen<OrderDetailState>(
      orderDetailControllerProvider(widget.orderId),
      (_, OrderDetailState next) {
        if (next.error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!.message)),
          );
        }
      },
    );
    final String locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      key: const Key('order-detail-screen'),
      appBar: AppBar(title: Text(l10n.orderDetailsTitle)),
      body: Builder(
        builder: (BuildContext context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final OrderDto? order = state.order;
          if (order == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(l10n.errorGeneric),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref
                        .read(
                          orderDetailControllerProvider(widget.orderId)
                              .notifier,
                        )
                        .reload(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref
                .read(orderDetailControllerProvider(widget.orderId).notifier)
                .reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${l10n.orderNumber} ${order.orderNumber}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    OrderStatusChip(status: order.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.orderDetailPlacedOn} '
                  '${DateFormat.yMMMd(locale).format(order.placedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: l10n.orderDetailItems),
                ...order.items.map(
                  (OrderItemDto item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ApiConfig.imageUrl(item.imagePublicId),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text(
                      '${item.quantity} × ${item.unitPrice.formatted}',
                    ),
                    trailing: Text(item.lineTotal.formatted),
                  ),
                ),
                const Divider(),
                _PriceRow(
                  label: l10n.checkoutShipping,
                  value: order.pricing.shippingFee?.formatted ?? '—',
                ),
                if (order.pricing.discountTotal != null)
                  _PriceRow(
                    label: l10n.checkoutDiscount,
                    value: order.pricing.discountTotal!.formatted,
                  ),
                _PriceRow(
                  label: l10n.checkoutGrandTotal,
                  value: order.pricing.grandTotal.formatted,
                  bold: true,
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: l10n.checkoutAddress),
                Text(
                  '${order.shippingAddress.fullName} • '
                  '${order.shippingAddress.phone}',
                ),
                Text(
                  '${order.shippingAddress.street}, '
                  '${order.shippingAddress.city}, '
                  '${order.shippingAddress.governorate}',
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: l10n.orderDetailPayment),
                _PaymentRow(order: order),
                if (state.canResubmitPayment) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    l10n.orderPaymentRejected,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _senderController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.checkoutTransferSender,
                      hintText: l10n.checkoutTransferSenderHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: state.isBusy ? null : _resubmit,
                      child: Text(l10n.orderResubmit),
                    ),
                  ),
                ],
                if (order.shipment != null) ...<Widget>[
                  const SizedBox(height: 16),
                  _SectionTitle(title: l10n.orderDetailShipment),
                  Text(
                    '${order.shipment!.carrier} • '
                    '${order.shipment!.trackingNumber}',
                  ),
                ],
                if (order.cancellation != null) ...<Widget>[
                  const SizedBox(height: 16),
                  _SectionTitle(title: l10n.orderDetailCancellation),
                  Text(
                    '${order.cancellation!.reason} — '
                    '${DateFormat.yMMMd(locale).format(order.cancellation!.at)}',
                  ),
                ],
                if (state.canCancel) ...<Widget>[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.error,
                      ),
                      onPressed: state.isBusy ? null : () => _cancel(order),
                      child: Text(l10n.orderDetailCancel),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = bold
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.order});

  final OrderDto order;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final OrderPaymentDto? payment = order.payment;
    if (payment == null) {
      return Text(l10n.orderPaymentStatusPending);
    }
    final String method = switch (payment.method) {
      PaymentMethod.cod => l10n.trustCod,
      PaymentMethod.wallet => 'Wallet',
      PaymentMethod.instapay => 'InstaPay',
      PaymentMethod.unknown => payment.method.name,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(method),
        Text(
          paymentStatusLabel(l10n, payment.status),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (payment.verification != null)
          Text(
            '${l10n.checkoutTransferSender}: '
            '${payment.verification!.transferSender}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}
