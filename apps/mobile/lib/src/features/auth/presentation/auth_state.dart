import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/api/api_exception.dart';
import 'package:nest_electro/src/core/models/auth.dart';

part 'auth_state.freezed.dart';

/// Auth UI state. Errors are data, not exceptions: screens render
/// `unauthenticated(error: ...)` and the router guards on `authenticated`.
/// The full [ApiException] is kept so screens can branch on it
/// (e.g. the register rate limit).
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.authenticated(AuthUserDto user) = _Authenticated;

  const factory AuthState.unauthenticated({ApiException? error}) =
      _Unauthenticated;
}

/// Public readers for the state. These live in an extension (not the freezed
/// class body) because freezed union impls `implement` their case classes
/// and do not inherit concrete members defined in the class body.
extension AuthStateX on AuthState {
  bool get isAuthenticated =>
      maybeWhen(authenticated: (_) => true, orElse: () => false);

  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);

  AuthUserDto? get user =>
      maybeWhen(authenticated: (user) => user, orElse: () => null);

  ApiException? get error =>
      maybeWhen(unauthenticated: (error) => error, orElse: () => null);
}
