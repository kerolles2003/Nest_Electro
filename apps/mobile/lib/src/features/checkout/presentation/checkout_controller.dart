import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/models/checkout.dart';
import 'package:nest_electro/src/core/models/enums.dart';
import 'package:nest_electro/src/core/models/order.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/checkout/data/checkout_repository.dart';
import 'package:uuid/uuid.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(client: ref.watch(apiClientProvider));
});

/// Checkout state: address → per-address quote → payment method → place
/// order. The idempotency key is generated once per controller lifetime
/// and reused across retries, so a retry after a dropped response cannot
/// create a second order.
class CheckoutState {
  const CheckoutState({
    this.addresses = const <AddressDto>[],
    this.selectedAddressId,
    this.quote,
    this.paymentMethods,
    this.paymentMethodsFailed = false,
    this.selectedPaymentMethod,
    this.transferSender = '',
    this.customerNote = '',
    this.isLoading = true,
    this.isLoadingQuote = false,
    this.isPlacingOrder = false,
    this.error,
    required this.idempotencyKey,
    this.placedOrder,
  });

  final List<AddressDto> addresses;
  final String? selectedAddressId;
  final CheckoutQuoteViewDto? quote;
  final ManualPaymentInstructionsDto? paymentMethods;
  final bool paymentMethodsFailed;
  final PaymentMethod? selectedPaymentMethod;
  final String transferSender;
  final String customerNote;
  final bool isLoading;
  final bool isLoadingQuote;
  final bool isPlacingOrder;
  final ApiException? error;
  final String idempotencyKey;
  final OrderDto? placedOrder;

  /// Methods the user can actually pick. When the instructions call
  /// failed, only COD is offered (the storefront degrades the same way).
  List<PaymentMethod> get availableMethods =>
      availableMethodsFor(paymentMethods);

  bool get canPlaceOrder =>
      selectedAddressId != null &&
      quote != null &&
      quote!.canPlaceOrder &&
      selectedPaymentMethod != null &&
      !isPlacingOrder;

  /// Manual methods need the sender account the customer transferred from.
  bool get needsTransferSender =>
      selectedPaymentMethod == PaymentMethod.wallet ||
      selectedPaymentMethod == PaymentMethod.instapay;

  CheckoutState copyWith({
    List<AddressDto>? addresses,
    String? selectedAddressId,
    CheckoutQuoteViewDto? quote,
    bool clearQuote = false,
    ManualPaymentInstructionsDto? paymentMethods,
    bool? paymentMethodsFailed,
    PaymentMethod? selectedPaymentMethod,
    bool clearPaymentMethod = false,
    String? transferSender,
    String? customerNote,
    bool? isLoading,
    bool? isLoadingQuote,
    bool? isPlacingOrder,
    ApiException? error,
    bool clearError = false,
    OrderDto? placedOrder,
  }) {
    return CheckoutState(
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      quote: clearQuote ? null : (quote ?? this.quote),
      paymentMethods: paymentMethods ?? this.paymentMethods,
      paymentMethodsFailed: paymentMethodsFailed ?? this.paymentMethodsFailed,
      selectedPaymentMethod: clearPaymentMethod
          ? null
          : (selectedPaymentMethod ?? this.selectedPaymentMethod),
      transferSender: transferSender ?? this.transferSender,
      customerNote: customerNote ?? this.customerNote,
      isLoading: isLoading ?? this.isLoading,
      isLoadingQuote: isLoadingQuote ?? this.isLoadingQuote,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      error: clearError ? null : (error ?? this.error),
      idempotencyKey: idempotencyKey,
      placedOrder: placedOrder ?? this.placedOrder,
    );
  }
}

/// Maps the API's `availableMethods` strings (`COD`, `WALLET`,
/// `INSTAPAY`) to [PaymentMethod]. A null instructions object (the call
/// failed) degrades to COD-only.
List<PaymentMethod> availableMethodsFor(
  ManualPaymentInstructionsDto? methods,
) {
  final List<String>? configured = methods?.availableMethods;
  if (configured == null) {
    return const <PaymentMethod>[PaymentMethod.cod];
  }
  return configured
      .map(
        (String m) => PaymentMethod.values
            .where((PaymentMethod p) => p.name.toUpperCase() == m)
            .firstOrNull,
      )
      .whereType<PaymentMethod>()
      .toList();
}

class CheckoutController extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    Future.microtask(_load);
    return CheckoutState(idempotencyKey: const Uuid().v4());
  }

  CheckoutRepository get _repo => ref.read(checkoutRepositoryProvider);

  /// Re-runs the initial load (error retry).
  Future<void> reload() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _load();
  }

  Future<void> _load() async {
    try {
      final List<AddressDto> addresses = await _repo.listAddresses();
      ManualPaymentInstructionsDto? methods;
      bool methodsFailed = false;
      try {
        methods = await _repo.getPaymentMethods();
      } on ApiException {
        // Degrade to COD-only — a failed instructions call must not block
        // checkout (same rule as the storefront).
        methodsFailed = true;
      }
      final String? selected = _defaultAddressId(addresses);
      state = state.copyWith(
        addresses: addresses,
        selectedAddressId: selected,
        paymentMethods: methods,
        paymentMethodsFailed: methodsFailed,
        selectedPaymentMethod: availableMethodsFor(methods).firstOrNull,
        isLoading: false,
        clearError: true,
      );
      if (selected != null) {
        await _fetchQuote(selected);
      }
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (_) {
      // Non-API failure must not leave checkout stuck loading (same hang
      // class phase 8 fixed in CartController._load, D-32).
      state = state.copyWith(
        isLoading: false,
        error: const ApiException(
          code: 'LOAD_FAILED',
          message: 'Could not load checkout. Please try again.',
        ),
      );
    }
  }

  String? _defaultAddressId(List<AddressDto> addresses) {
    if (addresses.isEmpty) return null;
    return addresses
        .where((AddressDto a) => a.isDefault)
        .firstOrNull
        ?.id ?? addresses.first.id;
  }

  Future<void> _fetchQuote(String addressId) async {
    state = state.copyWith(isLoadingQuote: true, clearError: true);
    try {
      final CheckoutQuoteViewDto quote = await _repo.getQuote(addressId);
      state = state.copyWith(quote: quote, isLoadingQuote: false);
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoadingQuote: false,
        clearQuote: true,
        error: e,
      );
    } catch (_) {
      // Non-API failure must clear isLoadingQuote so the quote section
      // shows its error state instead of spinning forever.
      state = state.copyWith(
        isLoadingQuote: false,
        clearQuote: true,
        error: const ApiException(
          code: 'LOAD_FAILED',
          message: 'Could not load the quote. Please try again.',
        ),
      );
    }
  }

  Future<void> selectAddress(String addressId) async {
    if (addressId == state.selectedAddressId) return;
    state = state.copyWith(selectedAddressId: addressId);
    await _fetchQuote(addressId);
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedPaymentMethod: method, clearError: true);
  }

  void setTransferSender(String value) {
    state = state.copyWith(transferSender: value);
  }

  void setCustomerNote(String value) {
    state = state.copyWith(customerNote: value);
  }

  /// Creates an address, selects it, and fetches its quote. Returns null
  /// on failure (the error is in state).
  Future<AddressDto?> addAddress(CreateAddressDto dto) async {
    try {
      final AddressDto created = await _repo.createAddress(dto);
      final List<AddressDto> addresses = <AddressDto>[
        ...state.addresses,
        created,
      ];
      state = state.copyWith(
        addresses: addresses,
        selectedAddressId: created.id,
        clearError: true,
      );
      await _fetchQuote(created.id);
      return created;
    } on ApiException catch (e) {
      state = state.copyWith(error: e);
      return null;
    }
  }

  /// Places the order. Returns the placed order, or null on failure.
  Future<OrderDto?> placeOrder() async {
    if (!state.canPlaceOrder) return null;
    state = state.copyWith(isPlacingOrder: true, clearError: true);
    try {
      final OrderDto order = await _repo.placeOrder(
        PlaceOrderDto(
          addressId: state.selectedAddressId!,
          customerNote: state.customerNote.isEmpty
              ? null
              : state.customerNote,
          paymentMethod: state.selectedPaymentMethod,
          transferSender: state.needsTransferSender &&
                  state.transferSender.trim().isNotEmpty
              ? state.transferSender.trim()
              : null,
        ),
        state.idempotencyKey,
      );
      state = state.copyWith(isPlacingOrder: false, placedOrder: order);
      return order;
    } on ApiException catch (e) {
      state = state.copyWith(isPlacingOrder: false, error: e);
      return null;
    }
  }
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutState>(
  CheckoutController.new,
);
