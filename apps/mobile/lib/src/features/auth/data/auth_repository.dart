import 'package:nest_electro/src/core/api/api_client.dart';
import 'package:nest_electro/src/core/api/token_storage.dart';
import 'package:nest_electro/src/core/models/auth.dart';

/// Auth endpoints (`POST /auth/*`, `GET /auth/me`). Token persistence lives
/// here (login stores, logout clears); rotation is the client's job.
class AuthRepository {
  AuthRepository({
    required ApiClient client,
    required TokenStorage tokenStorage,
  })  : _client = client,
        _tokenStorage = tokenStorage;

  final ApiClient _client;
  final TokenStorage _tokenStorage;

  Future<LoginPayloadDto> login(LoginDto dto) async {
    final LoginPayloadDto payload = await _client.postData<LoginPayloadDto>(
      '/auth/login',
      body: dto.toJson(),
      fromJson: (Object? json) =>
          LoginPayloadDto.fromJson(json as Map<String, dynamic>),
    );
    await _tokenStorage.saveTokens(payload.sessionTokens);
    return payload;
  }

  Future<RegisterPayloadDto> register(RegisterDto dto) async {
    return _client.postData<RegisterPayloadDto>(
      '/auth/register',
      body: dto.toJson(),
      fromJson: (Object? json) =>
          RegisterPayloadDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Logs out this session. The server call is best-effort: tokens are
  /// cleared even if it fails, so a stale session can never trap the user.
  Future<void> logout() async {
    final String? refreshToken = await _tokenStorage.readRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _client.postData<MessagePayloadDto>(
          '/auth/logout',
          body: RefreshTokenDto(refreshToken: refreshToken).toJson(),
          fromJson: (Object? json) =>
              MessagePayloadDto.fromJson(json as Map<String, dynamic>),
        );
      }
    } finally {
      await _tokenStorage.clear();
    }
  }

  Future<void> logoutAll() async {
    try {
      await _client.postData<MessagePayloadDto>(
        '/auth/logout-all',
        fromJson: (Object? json) =>
            MessagePayloadDto.fromJson(json as Map<String, dynamic>),
      );
    } finally {
      await _tokenStorage.clear();
    }
  }

  Future<AuthUserDto> me() async {
    return _client.getData<AuthUserDto>(
      '/auth/me',
      fromJson: (Object? json) =>
          AuthUserDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<MessagePayloadDto> forgotPassword(String email) async {
    return _client.postData<MessagePayloadDto>(
      '/auth/forgot-password',
      body: ForgotPasswordDto(email: email).toJson(),
      fromJson: (Object? json) =>
          MessagePayloadDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<MessagePayloadDto> resetPassword(ResetPasswordDto dto) async {
    return _client.postData<MessagePayloadDto>(
      '/auth/reset-password',
      body: dto.toJson(),
      fromJson: (Object? json) =>
          MessagePayloadDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<MessagePayloadDto> verifyEmail(String token) async {
    return _client.postData<MessagePayloadDto>(
      '/auth/verify-email',
      body: VerifyEmailDto(token: token).toJson(),
      fromJson: (Object? json) =>
          MessagePayloadDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<MessagePayloadDto> resendVerification(String email) async {
    return _client.postData<MessagePayloadDto>(
      '/auth/resend-verification',
      body: ResendVerificationDto(email: email).toJson(),
      fromJson: (Object? json) =>
          MessagePayloadDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
