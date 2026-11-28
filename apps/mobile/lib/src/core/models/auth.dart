import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/enums.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class AuthUserDto with _$AuthUserDto {
  const factory AuthUserDto({
    required String id,
    required String email,
    required String fullName,
    String? phone,
    @JsonKey(unknownEnumValue: Role.unknown) required Role role,
    required bool emailVerified,
    DateTime? lastLoginAt,
    required DateTime createdAt,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);
}

/// Tokens returned by login and refresh. Access tokens live 15 minutes and
/// rotate on every refresh.
@freezed
class SessionTokensDto with _$SessionTokensDto {
  const factory SessionTokensDto({
    required String tokenType,
    required String accessToken,
    required int expiresIn,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
  }) = _SessionTokensDto;

  factory SessionTokensDto.fromJson(Map<String, dynamic> json) =>
      _$SessionTokensDtoFromJson(json);
}

@freezed
class LoginPayloadDto with _$LoginPayloadDto {
  const factory LoginPayloadDto({
    required String tokenType,
    required String accessToken,
    required int expiresIn,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
    required AuthUserDto user,
  }) = _LoginPayloadDto;

  const LoginPayloadDto._();

  /// The token half of the payload, for storage after login.
  SessionTokensDto get sessionTokens => SessionTokensDto(
        tokenType: tokenType,
        accessToken: accessToken,
        expiresIn: expiresIn,
        accessTokenExpiresAt: accessTokenExpiresAt,
        refreshToken: refreshToken,
        refreshTokenExpiresAt: refreshTokenExpiresAt,
      );

  factory LoginPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$LoginPayloadDtoFromJson(json);
}

@freezed
class RegisterPayloadDto with _$RegisterPayloadDto {
  const factory RegisterPayloadDto({
    required String message,
    required bool emailVerificationRequired,
  }) = _RegisterPayloadDto;

  factory RegisterPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterPayloadDtoFromJson(json);
}

@freezed
class MessagePayloadDto with _$MessagePayloadDto {
  const factory MessagePayloadDto({
    required String message,
  }) = _MessagePayloadDto;

  factory MessagePayloadDto.fromJson(Map<String, dynamic> json) =>
      _$MessagePayloadDtoFromJson(json);
}

// --- Request DTOs (sent to the API) ---

@freezed
class LoginDto with _$LoginDto {
  const factory LoginDto({
    required String email,
    required String password,
  }) = _LoginDto;

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}

@freezed
class RegisterDto with _$RegisterDto {
  const factory RegisterDto({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) = _RegisterDto;

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);
}

@freezed
class ForgotPasswordDto with _$ForgotPasswordDto {
  const factory ForgotPasswordDto({
    required String email,
  }) = _ForgotPasswordDto;

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordDtoFromJson(json);
}

@freezed
class ResetPasswordDto with _$ResetPasswordDto {
  const factory ResetPasswordDto({
    required String token,
    required String newPassword,
  }) = _ResetPasswordDto;

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDtoFromJson(json);
}

@freezed
class VerifyEmailDto with _$VerifyEmailDto {
  const factory VerifyEmailDto({
    required String token,
  }) = _VerifyEmailDto;

  factory VerifyEmailDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailDtoFromJson(json);
}

@freezed
class ResendVerificationDto with _$ResendVerificationDto {
  const factory ResendVerificationDto({
    required String email,
  }) = _ResendVerificationDto;

  factory ResendVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationDtoFromJson(json);
}

@freezed
class RefreshTokenDto with _$RefreshTokenDto {
  const factory RefreshTokenDto({
    required String refreshToken,
  }) = _RefreshTokenDto;

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDtoFromJson(json);
}
