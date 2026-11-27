import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/checkout/presentation/checkout_controller.dart';
import 'package:nest_electro/src/features/checkout/presentation/order_confirmation_screen.dart';
import 'package:nest_electro/src/features/checkout/presentation/widgets/add_address_form.dart';

/// Checkout: address → per-address quote → payment method → place order.
/// Single scrollable page (like the web checkout), with a sticky bottom
/// bar carrying the grand total and the place-order button.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _senderController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _senderController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CheckoutState state = ref.watch(checkoutControllerProvider);

    ref.listen<CheckoutState>(checkoutControllerProvider, (
      _,
      CheckoutState next,
    ) {
      if (next.error != null && next.placedOrder == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!.message)));
      }
    });

    return Scaffold(
      key: const Key('checkout-screen'),
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: _buildBody(context, state),
      bottomNavigationBar: _buildBottomBar(context, state),
    );
  }

  Widget _buildBody(BuildContext context, CheckoutState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.addresses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                l10n.errorLoadProducts,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(checkoutControllerProvider.notifier).reload(),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(checkoutControllerProvider.notifier).reload(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SectionTitle(title: l10n.checkoutAddress),
            if (state.addresses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l10n.checkoutNoAddress),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add_location_alt_outlined),
                      label: Text(l10n.checkoutAddAddress),
                      onPressed: () => _showAddAddress(context),
                    ),
                  ],
                ),
              )
            else
              RadioGroup<String>(
                groupValue: state.selectedAddressId,
                onChanged: (String? id) {
                  if (id != null) {
                    ref
                        .read(checkoutControllerProvider.notifier)
                        .selectAddress(id);
                  }
                },
                child: Column(
                  children: state.addresses
                      .map(
                        (AddressDto address) => RadioListTile<String>(
                          title: Text(address.label),
                          subtitle: Text(
                            '${address.fullName} • ${address.street}, ${address.city}, ${address.governorate}',
                          ),
                          secondary: address.isDefault
                              ? Chip(label: Text(l10n.addressDefaultBadge))
                              : null,
                          value: address.id,
                        ),
                      )
                      .toList(),
                ),
              ),
            if (state.addresses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: TextButton.icon(
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: Text(l10n.checkoutAddAddress),
                  onPressed: () => _showAddAddress(context),
                ),
              ),
            _SectionTitle(title: l10n.checkoutQuote),
            _QuoteSection(state: state),
            _SectionTitle(title: l10n.checkoutPaymentMethod),
            if (state.paymentMethodsFailed)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  l10n.checkoutPaymentMethodsUnavailable,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            RadioGroup<PaymentMethod>(
              groupValue: state.selectedPaymentMethod,
              onChanged: (PaymentMethod? m) {
                if (m != null) {
                  ref
                      .read(checkoutControllerProvider.notifier)
                      .selectPaymentMethod(m);
                }
              },
              child: Column(
                children: state.availableMethods
                    .map(
                      (PaymentMethod method) => RadioListTile<PaymentMethod>(
                        title: Text(_paymentMethodLabel(l10n, method)),
                        value: method,
                      ),
                    )
                    .toList(),
              ),
            ),
            if (state.selectedPaymentMethod != null)
              _PaymentInstructions(
                state: state,
                senderController: _senderController,
                onSenderChanged: (String v) => ref
                    .read(checkoutControllerProvider.notifier)
                    .setTransferSender(v),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.checkoutCustomerNote,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (String v) => ref
                    .read(checkoutControllerProvider.notifier)
                    .setCustomerNote(v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomBar(BuildContext context, CheckoutState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CheckoutQuoteViewDto? quote = state.quote;
    if (state.isLoading || state.addresses.isEmpty) {
      return null;
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  l10n.checkoutGrandTotal,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  quote?.pricing.grandTotal.formatted ?? '—',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.canPlaceOrder ? _placeOrder : null,
                child: state.isPlacingOrder
                    ? Text(l10n.checkoutPlacingOrder)
                    : Text(l10n.checkoutPlaceOrder),
              ),
            ),
            if (quote != null && !quote.canPlaceOrder)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.checkoutCannotPlaceOrder,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddAddress(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddAddressForm(
        onSubmit: (CreateAddressDto dto) async {
          final AddressDto? created = await ref
              .read(checkoutControllerProvider.notifier)
              .addAddress(dto);
          if (created != null && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.addressAdded)));
          }
          return created != null;
        },
      ),
    );
  }

  Future<void> _placeOrder() async {
    final OrderDto? order = await ref
        .read(checkoutControllerProvider.notifier)
        .placeOrder();
    if (order != null && mounted) {
      final CheckoutState state = ref.read(checkoutControllerProvider);
      context.push(
        '/checkout/confirmation',
        extra: OrderConfirmationArgs(
          order: order,
          instructions: state.paymentMethods,
        ),
      );
    }
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _QuoteSection extends StatelessWidget {
  const _QuoteSection({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CheckoutQuoteViewDto? quote = state.quote;

    if (state.isLoadingQuote) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (quote == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          l10n.errorLoadProducts,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }
    final PricingBreakdownDto pricing = quote.pricing;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          ...quote.items.map(
            (QuoteLineDto line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('${line.name} × ${line.effectiveQuantity}'),
                  ),
                  Text(line.lineTotal?.formatted ?? ''),
                ],
              ),
            ),
          ),
          const Divider(),
          _BreakdownRow(
            label: l10n.cartSubtotal,
            value: pricing.itemsSubtotal.formatted,
          ),
          if (pricing.discountTotal != null)
            _BreakdownRow(
              label: l10n.checkoutDiscount,
              value: '-${pricing.discountTotal!.formatted}',
            ),
          _BreakdownRow(
            label: l10n.checkoutShipping,
            value: pricing.shippingPriced
                ? (pricing.shippingFee?.formatted ?? '—')
                : l10n.checkoutShippingUnpriced,
          ),
          _BreakdownRow(
            label: l10n.checkoutGrandTotal,
            value: pricing.grandTotal.formatted,
            bold: true,
          ),
          if (pricing.vatInclusive)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                '${l10n.checkoutVatIncluded} (${pricing.vatRateBps ~/ 100}%)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          if (quote.hasBlockingIssues)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.cartBlockingIssues,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Manual-payment instructions for the selected method: the transfer
/// target (wallet number / InstaPay address), what to do next, and the
/// sender-account field the API collects as `transferSender`.
class _PaymentInstructions extends StatelessWidget {
  const _PaymentInstructions({
    required this.state,
    required this.senderController,
    required this.onSenderChanged,
  });

  final CheckoutState state;
  final TextEditingController senderController;
  final ValueChanged<String> onSenderChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final PaymentMethod method = state.selectedPaymentMethod!;
    final ManualPaymentInstructionsDto? methods = state.paymentMethods;

    if (method == PaymentMethod.cod) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Text(l10n.checkoutCodNote),
      );
    }

    final bool isWallet = method == PaymentMethod.wallet;
    final String? target = isWallet
        ? methods?.walletNumber
        : methods?.instapayAddress;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (target != null && target.isNotEmpty)
            _CopyableField(
              label: isWallet ? 'Wallet' : 'InstaPay',
              value: target,
            ),
          const SizedBox(height: 8),
          Text(
            isWallet
                ? l10n.checkoutWalletInstructions
                : l10n.checkoutInstapayInstructions,
          ),
          if (methods?.whatsappNumber != null &&
              methods!.whatsappNumber.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            _CopyableField(label: 'WhatsApp', value: methods.whatsappNumber),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: senderController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.checkoutTransferSender,
              hintText: l10n.checkoutTransferSenderHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: onSenderChanged,
          ),
        ],
      ),
    );
  }
}

class _CopyableField extends StatelessWidget {
  const _CopyableField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          tooltip: label,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$label: $value')));
          },
        ),
      ],
    );
  }
}
