import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/account/presentation/orders_controller.dart';

class _MockAccountRepository extends Mock implements AccountRepository {}

Map<String, dynamic> _pricingJson() {
  return <String, dynamic>{
    'itemsSubtotal': <String, dynamic>{
      'amount': 10000,
      'currency': 'EGP',
      'formatted': '100.00 EGP',
    },
    'discountTotal': null,
    'shippingFee': null,
    'shippingPriced': false,
    'grandTotal': <String, dynamic>{
      'amount': 10000,
      'currency': 'EGP',
      'formatted': '100.00 EGP',
    },
    'vatInclusive': true,
    'vatRateBps': 1400,
  };
}

OrderSummaryDto _summary(String id, String status) {
  return OrderSummaryDto.fromJson(<String, dynamic>{
    'id': id,
    'orderNumber': 'NE-$id',
    'status': status,
    'payment': null,
    'pricing': _pricingJson(),
    'itemCount': 1,
    'totalQuantity': 1,
    'previewImagePublicId': 'nest/products/p1/img',
    'placedAt': '2026-01-01T00:00:00.000Z',
  });
}

OrderDto _order({String status = 'PLACED', String? paymentStatus}) {
  return OrderDto.fromJson(<String, dynamic>{
    'id': 'o1',
    'orderNumber': 'NE-1001',
    'status': status,
    'customer': <String, dynamic>{
      'fullName': 'Test User',
      'email': 'user@example.com',
      'phone': null,
    },
    'items': <dynamic>[],
    'currency': 'EGP',
    'pricing': _pricingJson(),
    'payment': paymentStatus == null
        ? null
        : <String, dynamic>{
            'method': 'WALLET',
            'status': paymentStatus,
            'collectedAt': null,
            'verification': null,
          },
    'shippingAddress': <String, dynamic>{
      'fullName': 'Test User',
      'phone': '01000000000',
      'street': '1 Main St',
      'city': 'Cairo',
      'governorate': 'Cairo',
      'postalCode': '',
    },
    'customerNote': '',
    'cancellation': null,
    'shipment': null,
    'placedAt': '2026-01-01T00:00:00.000Z',
  });
}

PaginatedList<OrderSummaryDto> _page(
  List<OrderSummaryDto> items, {
  bool hasNext = false,
}) {
  return PaginatedList<OrderSummaryDto>(
    items: items,
    meta: PaginationMetaDto.fromJson(<String, dynamic>{
      'page': 1,
      'limit': 20,
      'total': items.length,
      'totalPages': 1,
      'hasNext': hasNext,
      'hasPrev': false,
    }),
  );
}

Future<void> _pump() async {
  for (int i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(OrderStatus.placed);
  });

  late _MockAccountRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockAccountRepository();
    container = ProviderContainer(
      overrides: <Override>[
        accountRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('loads the first page of orders', () async {
    when(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => _page(<OrderSummaryDto>[
        _summary('o1', 'PLACED'),
        _summary('o2', 'DELIVERED'),
      ]),
    );

    container.read(ordersControllerProvider.notifier);
    await _pump();

    final OrdersState state = container.read(ordersControllerProvider);
    expect(state.isLoading, false);
    expect(state.items.length, 2);
    expect(state.items.first.orderNumber, 'NE-o1');
  });

  test('setStatus reloads with the filter', () async {
    when(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => _page(<OrderSummaryDto>[_summary('o1', 'PLACED')]),
    );

    final OrdersController controller = container.read(
      ordersControllerProvider.notifier,
    );
    await _pump();
    await controller.setStatus(OrderStatus.delivered);
    await _pump();

    expect(container.read(ordersControllerProvider).status,
        OrderStatus.delivered);
    verify(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: OrderStatus.delivered,
      ),
    ).called(1);
  });

  test('loadMore appends the next page', () async {
    when(
      () => repository.listOrders(
        page: any(named: 'page'),
        limit: any(named: 'limit'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((Invocation inv) async {
      final int page = inv.namedArguments[#page] as int;
      if (page == 1) {
        return _page(
          List<OrderSummaryDto>.generate(
            20,
            (int i) => _summary('o$i', 'PLACED'),
          ),
          hasNext: true,
        );
      }
      return _page(<OrderSummaryDto>[_summary('o20', 'PLACED')]);
    });

    final OrdersController controller = container.read(
      ordersControllerProvider.notifier,
    );
    await _pump();
    expect(container.read(ordersControllerProvider).items.length, 20);

    await controller.loadMore();
    await _pump();
    expect(container.read(ordersControllerProvider).items.length, 21);
    expect(container.read(ordersControllerProvider).hasMore, false);
  });

  test('order detail loads, cancels and resubmits', () async {
    when(() => repository.getOrder(any())).thenAnswer(
      (_) async => _order(),
    );
    when(() => repository.cancelOrder(any(), any())).thenAnswer(
      (_) async => _order(status: 'CANCELLED'),
    );
    when(() => repository.resubmitPayment(any(), any())).thenAnswer(
      (_) async => _order(
        status: 'PLACED',
        paymentStatus: 'PENDING_VERIFICATION',
      ),
    );

    final OrderDetailController controller = container.read(
      orderDetailControllerProvider('o1').notifier,
    );
    await _pump();

    OrderDetailState state = container.read(
      orderDetailControllerProvider('o1'),
    );
    expect(state.order?.orderNumber, 'NE-1001');
    expect(state.canCancel, true);
    expect(state.canResubmitPayment, false);

    expect(await controller.cancel('changed my mind'), true);
    state = container.read(orderDetailControllerProvider('o1'));
    expect(state.order?.status, OrderStatus.cancelled);
    expect(state.canCancel, false);
    verify(() => repository.cancelOrder('o1', 'changed my mind')).called(1);

    // A rejected wallet payment can be resubmitted.
    when(() => repository.getOrder(any())).thenAnswer(
      (_) async => _order(paymentStatus: 'VERIFICATION_REJECTED'),
    );
    await controller.reload();
    await _pump();
    state = container.read(orderDetailControllerProvider('o1'));
    expect(state.canResubmitPayment, true);
    expect(await controller.resubmitPayment('01011112222'), true);
    verify(() => repository.resubmitPayment('o1', '01011112222')).called(1);
  });

  test('order detail failure keeps the error in state', () async {
    when(() => repository.getOrder(any())).thenThrow(
      const ApiException(code: 'NOT_FOUND', message: 'no such order'),
    );
    container.read(orderDetailControllerProvider('o1').notifier);
    await _pump();

    expect(
      container.read(orderDetailControllerProvider('o1')).error?.code,
      'NOT_FOUND',
    );
  });
}
