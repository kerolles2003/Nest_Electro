import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/pagination.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';

final ordersControllerProvider =
    NotifierProvider<OrdersController, OrdersState>(OrdersController.new);

final orderDetailControllerProvider =
    NotifierProviderFamily<OrderDetailController, OrderDetailState, String>(
  OrderDetailController.new,
);

/// Order history: paginated, filterable by status, infinite scroll.
/// `status == null` means all orders.
class OrdersState {
  const OrdersState({
    this.items = const <OrderSummaryDto>[],
    this.status,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.error,
  });

  final List<OrderSummaryDto> items;
  final OrderStatus? status;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final ApiException? error;

  OrdersState copyWith({
    List<OrderSummaryDto>? items,
    OrderStatus? status,
    bool clearStatus = false,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    ApiException? error,
    bool clearError = false,
  }) {
    return OrdersState(
      items: items ?? this.items,
      status: clearStatus ? null : (status ?? this.status),
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class OrdersController extends Notifier<OrdersState> {
  static const int _pageSize = 20;

  @override
  OrdersState build() {
    Future.microtask(_loadFirstPage);
    return const OrdersState();
  }

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  Future<void> _loadFirstPage() async {
    try {
      final PaginatedList<OrderSummaryDto> page =
          await _repository.listOrders(limit: _pageSize, status: state.status);
      state = state.copyWith(
        items: page.items,
        isLoading: false,
        hasMore: page.meta.hasNext,
        clearError: true,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (_) {
      // Non-API failure must not leave the list stuck loading (same hang
      // class phase 8 fixed in CartController._load, D-32).
      state = state.copyWith(
        isLoading: false,
        error: const ApiException(
          code: 'LOAD_FAILED',
          message: 'Could not load your orders. Please try again.',
        ),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, items: const <OrderSummaryDto>[]);
    await _loadFirstPage();
  }

  Future<void> setStatus(OrderStatus? status) async {
    if (status == state.status) {
      return;
    }
    state = state.copyWith(
      status: status,
      clearStatus: status == null,
      isLoading: true,
      items: const <OrderSummaryDto>[],
    );
    await _loadFirstPage();
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    try {
      final int nextPage = state.items.length ~/ _pageSize + 1;
      final PaginatedList<OrderSummaryDto> page =
          await _repository.listOrders(
        page: nextPage,
        limit: _pageSize,
        status: state.status,
      );
      state = state.copyWith(
        items: <OrderSummaryDto>[...state.items, ...page.items],
        isLoadingMore: false,
        hasMore: page.meta.hasNext,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    } catch (_) {
      // Same hang class as the first page: a non-API failure must clear
      // isLoadingMore so the user can retry instead of spinning forever.
      state = state.copyWith(
        isLoadingMore: false,
        error: const ApiException(
          code: 'LOAD_FAILED',
          message: 'Could not load more orders. Please try again.',
        ),
      );
    }
  }
}

/// One order: detail, cancel, payment resubmit.
class OrderDetailState {
  const OrderDetailState({
    this.order,
    this.isLoading = true,
    this.isBusy = false,
    this.error,
  });

  final OrderDto? order;
  final bool isLoading;
  final bool isBusy;
  final ApiException? error;

  /// The storefront offers cancel for PLACED / CONFIRMED only; the API is
  /// the final judge (409 when the status moved on).
  bool get canCancel =>
      order != null &&
      (order!.status == OrderStatus.placed ||
          order!.status == OrderStatus.confirmed);

  /// Resubmit is for wallet/InstaPay orders whose verification was rejected.
  bool get canResubmitPayment =>
      order?.payment?.status == PaymentStatus.verificationRejected;

  OrderDetailState copyWith({
    OrderDto? order,
    bool? isLoading,
    bool? isBusy,
    ApiException? error,
    bool clearError = false,
  }) {
    return OrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class OrderDetailController extends FamilyNotifier<OrderDetailState, String> {
  @override
  OrderDetailState build(String orderId) {
    Future.microtask(() => _load(orderId));
    return const OrderDetailState();
  }

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  Future<void> _load(String orderId) async {
    try {
      final OrderDto order = await _repository.getOrder(orderId);
      state = state.copyWith(order: order, isLoading: false, clearError: true);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (_) {
      // Non-API failure must not leave the detail screen stuck loading.
      state = state.copyWith(
        isLoading: false,
        error: const ApiException(
          code: 'LOAD_FAILED',
          message: 'Could not load this order. Please try again.',
        ),
      );
    }
  }

  Future<void> reload() => _load(arg);

  Future<bool> cancel(String reason) async {
    if (state.isBusy || state.order == null) {
      return false;
    }
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final OrderDto order = await _repository.cancelOrder(
        state.order!.id,
        reason,
      );
      state = state.copyWith(order: order, isBusy: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }

  Future<bool> resubmitPayment(String transferSender) async {
    if (state.isBusy || state.order == null) {
      return false;
    }
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final OrderDto order = await _repository.resubmitPayment(
        state.order!.id,
        transferSender,
      );
      state = state.copyWith(order: order, isBusy: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isBusy: false, error: e);
      return false;
    }
  }
}
