import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';

/// Secure persistence for the rotating session tokens. Nothing else is
/// stored here — no passwords, no user data.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'nest_access_token';
  static const String _refreshTokenKey = 'nest_refresh_token';
  static const String _accessExpiresAtKey = 'nest_access_expires_at';
  static const String _refreshExpiresAtKey = 'nest_refresh_expires_at';

  Future<void> saveTokens(SessionTokensDto tokens) async {
    await Future.wait(<Future<void>>[
      _storage.write(key: _accessTokenKey, value: tokens.accessToken),
      _storage.write(key: _refreshTokenKey, value: tokens.refreshToken),
      _storage.write(
        key: _accessExpiresAtKey,
        value: tokens.accessTokenExpiresAt.toIso8601String(),
      ),
      _storage.write(
        key: _refreshExpiresAtKey,
        value: tokens.refreshTokenExpiresAt.toIso8601String(),
      ),
    ]);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<DateTime?> readAccessExpiresAt() async {
    final String? raw = await _storage.read(key: _accessExpiresAtKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<DateTime?> readRefreshExpiresAt() async {
    final String? raw = await _storage.read(key: _refreshExpiresAtKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<bool> get hasRefreshToken async {
    final String? token = await readRefreshToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clear() async {
    await Future.wait(<Future<void>>[
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _accessExpiresAtKey),
      _storage.delete(key: _refreshExpiresAtKey),
    ]);
  }
}
