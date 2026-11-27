import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/api/providers.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';
import 'package:nest_electro/src/features/auth/data/auth_repository.dart';
import 'package:nest_electro/src/features/auth/presentation/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    client: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Owns the session: restores it on start (via `GET /auth/me`, which the
/// client refreshes automatically on 401), and drives login / register /
/// logout. Returns `true` from login/register on success so screens can
/// navigate; failures land in the state as `unauthenticated(error: ...)`.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restore();
    return const AuthState.initial();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  TokenStorage get _tokenStorage => ref.read(tokenStorageProvider);

  Future<void> _restore() async {
    if (!await _tokenStorage.hasRefreshToken) {
      state = const AuthState.unauthenticated();
      return;
    }
    state = const AuthState.loading();
    try {
      final AuthUserDto user = await _repository.me();
      state = AuthState.authenticated(user);
    } on ApiException {
      // Refresh already failed inside the client (tokens cleared) or the
      // session is otherwise dead: the user just logs in again.
      state = const AuthState.unauthenticated();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final LoginPayloadDto payload = await _repository.login(
        LoginDto(email: email, password: password),
      );
      state = AuthState.authenticated(payload.user);
      return true;
    } on ApiException catch (e) {
      state = AuthState.unauthenticated(error: e);
      return false;
    }
  }

  /// Returns the register payload on success (screens use
  /// `emailVerificationRequired` to route to the verify-email flow),
  /// `null` on failure (error is in the state).
  Future<RegisterPayloadDto?> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    state = const AuthState.loading();
    try {
      final RegisterPayloadDto payload = await _repository.register(
        RegisterDto(
          email: email,
          password: password,
          fullName: fullName,
          phone: phone,
        ),
      );
      state = const AuthState.unauthenticated();
      return payload;
    } on ApiException catch (e) {
      state = AuthState.unauthenticated(error: e);
      return null;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> logoutAll() async {
    await _repository.logoutAll();
    state = const AuthState.unauthenticated();
  }

  /// Clears a stale error (e.g. when the user edits a field after a failed
  /// attempt) without touching the session.
  void clearError() {
    state.when(
      initial: () {},
      loading: () {},
      authenticated: (_) {},
      unauthenticated: (ApiException? error) {
        if (error != null) {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }
}
