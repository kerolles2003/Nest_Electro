import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/core/models/profile.dart';
import 'package:nest_electro/src/features/account/data/account_repository.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_controller.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';

final accountControllerProvider =
    NotifierProvider<AccountController, AccountState>(
  AccountController.new,
);

/// Profile state. The user shown here is the session user (`GET /auth/me`,
/// same source the auth controller restores from); edits go through
/// `PATCH /users/me` and then refresh the session so the new name/phone
/// show up everywhere without a relogin.
class AccountState {
  const AccountState({
    this.user,
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

  final AuthUserDto? user;
  final bool isLoading;
  final bool isSaving;
  final ApiException? error;

  AccountState copyWith({
    AuthUserDto? user,
    bool? isLoading,
    bool? isSaving,
    ApiException? error,
    bool clearError = false,
  }) {
    return AccountState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AccountController extends Notifier<AccountState> {
  @override
  AccountState build() {
    Future.microtask(_load);
    return const AccountState();
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  Future<void> _load() async {
    try {
      final AuthUserDto user = await _authRepository.me();
      state = state.copyWith(user: user, isLoading: false, clearError: true);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (_) {
      // A non-API failure (e.g. a platform/storage error) must not leave
      // the screen stuck on its loading spinner — same hang class phase 8
      // fixed in CartController._load (D-32).
      state = state.copyWith(
        isLoading: false,
        error: const ApiException(
          code: 'LOAD_FAILED',
          message: 'Could not load your profile. Please try again.',
        ),
      );
    }
  }

  Future<void> reload() => _load();

  /// Saves the profile. Returns false when the API rejects the update
  /// (the error stays in state for the screen to show).
  Future<bool> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    if (state.isSaving) {
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.updateProfile(
        UpdateProfileDto(
          fullName: fullName,
          phone: phone?.isEmpty ?? true ? null : phone,
        ),
      );
      // Sync the session user with the updated profile, then pick the
      // fresh user up for this screen too.
      await ref.read(authControllerProvider.notifier).refresh();
      final AuthUserDto? freshUser =
          ref.read(authControllerProvider).user;
      state = state.copyWith(user: freshUser, isSaving: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e);
      return false;
    }
  }
}
