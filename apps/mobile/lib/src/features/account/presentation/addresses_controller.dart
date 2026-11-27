import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';

final addressesControllerProvider =
    NotifierProvider<AddressesController, AddressesState>(
  AddressesController.new,
);

/// Saved addresses: list, add, edit, delete, set default.
class AddressesState {
  const AddressesState({
    this.addresses = const <AddressDto>[],
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

  final List<AddressDto> addresses;
  final bool isLoading;
  final bool isSaving;
  final ApiException? error;

  AddressesState copyWith({
    List<AddressDto>? addresses,
    bool? isLoading,
    bool? isSaving,
    ApiException? error,
    bool clearError = false,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AddressesController extends Notifier<AddressesState> {
  @override
  AddressesState build() {
    Future.microtask(_load);
    return const AddressesState();
  }

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  Future<void> _load() async {
    try {
      final List<AddressDto> addresses = await _repository.listAddresses();
      state = state.copyWith(
        addresses: addresses,
        isLoading: false,
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
          message: 'Could not load your addresses. Please try again.',
        ),
      );
    }
  }

  Future<void> reload() => _load();

  Future<AddressDto?> create(CreateAddressDto dto) async {
    if (state.isSaving) {
      return null;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final AddressDto created = await _repository.createAddress(dto);
      state = state.copyWith(
        addresses: <AddressDto>[...state.addresses, created],
        isSaving: false,
      );
      return created;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e);
      return null;
    }
  }

  Future<AddressDto?> update(String id, UpdateAddressDto dto) async {
    if (state.isSaving) {
      return null;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final AddressDto updated = await _repository.updateAddress(id, dto);
      state = state.copyWith(
        addresses: state.addresses
            .map((AddressDto a) => a.id == id ? updated : a)
            .toList(),
        isSaving: false,
      );
      return updated;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e);
      return null;
    }
  }

  Future<bool> delete(String id) async {
    if (state.isSaving) {
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      // The API returns the remaining list.
      final List<AddressDto> remaining = await _repository.deleteAddress(id);
      state = state.copyWith(addresses: remaining, isSaving: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e);
      return false;
    }
  }

  Future<bool> setDefault(String id) async {
    if (state.isSaving) {
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      // The API returns the list with the new default applied.
      final List<AddressDto> updated =
          await _repository.setDefaultAddress(id);
      state = state.copyWith(addresses: updated, isSaving: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e);
      return false;
    }
  }
}
