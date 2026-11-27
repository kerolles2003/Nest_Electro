import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nest_electro/src/core/config/api_config.dart';
import 'package:nest_electro/src/core/l10n/gen/app_localizations.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/features/account/presentation/orders_controller.dart';
import 'package:nest_electro/src/features/account/presentation/widgets/order_status_chip.dart';

/// Order history: status filter chips + paginated list, newest first.
/// Tap an order for its detail screen.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(ordersControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const List<OrderStatus?> _filters = <OrderStatus?>[
    null,
    OrderStatus.placed,
    OrderStatus.confirmed,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.deliveryFailed,
    OrderStatus.cancelled,
    OrderStatus.returned,
  ];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final OrdersState state = ref.watch(ordersControllerProvider);
    ref.listen<OrdersState>(ordersControllerProvider, (_, OrdersState next) {
      if (next.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!.message)),
        );
      }
    });
    final String locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      key: const Key('orders-screen'),
      appBar: AppBar(title: Text(l10n.ordersTitle)),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: _filters
                  .map(
                    (OrderStatus? status) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(
                          status == null
                              ? l10n.ordersFilterAll
                              : orderStatusLabel(l10n, status),
                        ),
                        selected: state.status == status,
                        onSelected: (_) => ref
                            .read(ordersControllerProvider.notifier)
                            .setStatus(status),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(ordersControllerProvider.notifier)
                        .refresh(),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            l10n.ordersEmpty,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(ordersControllerProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.items.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final OrderSummaryDto order = state.items[index];
                      return InkWell(
                        onTap: () =>
                            context.push('/account/orders/${order.id}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  ApiConfig.imageUrl(
                                    order.previewImagePublicId,
                                  ),
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.image_not_supported,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${l10n.orderNumber} '
                                      '${order.orderNumber}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      DateFormat.yMMMd(
                                        locale,
                                      ).format(order.placedAt),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 6),
                                    OrderStatusChip(status: order.status),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order.pricing.grandTotal.formatted,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
