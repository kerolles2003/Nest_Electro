// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserDtoImpl _$$AuthUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserDtoImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      role: $enumDecode(
        _$RoleEnumMap,
        json['role'],
        unknownValue: Role.unknown,
      ),
      emailVerified: json['emailVerified'] as bool,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AuthUserDtoImplToJson(_$AuthUserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'role': _$RoleEnumMap[instance.role]!,
      'emailVerified': instance.emailVerified,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$RoleEnumMap = {
  Role.customer: 'CUSTOMER',
  Role.admin: 'ADMIN',
  Role.superAdmin: 'SUPER_ADMIN',
  Role.unknown: 'unknown',
};

_$SessionTokensDtoImpl _$$SessionTokensDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SessionTokensDtoImpl(
  tokenType: json['tokenType'] as String,
  accessToken: json['accessToken'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
  accessTokenExpiresAt: DateTime.parse(json['accessTokenExpiresAt'] as String),
  refreshToken: json['refreshToken'] as String,
  refreshTokenExpiresAt: DateTime.parse(
    json['refreshTokenExpiresAt'] as String,
  ),
);

Map<String, dynamic> _$$SessionTokensDtoImplToJson(
  _$SessionTokensDtoImpl instance,
) => <String, dynamic>{
  'tokenType': instance.tokenType,
  'accessToken': instance.accessToken,
  'expiresIn': instance.expiresIn,
  'accessTokenExpiresAt': instance.accessTokenExpiresAt.toIso8601String(),
  'refreshToken': instance.refreshToken,
  'refreshTokenExpiresAt': instance.refreshTokenExpiresAt.toIso8601String(),
};

_$LoginPayloadDtoImpl _$$LoginPayloadDtoImplFromJson(
  Map<String, dynamic> json,
) => _$LoginPayloadDtoImpl(
  tokenType: json['tokenType'] as String,
  accessToken: json['accessToken'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
  accessTokenExpiresAt: DateTime.parse(json['accessTokenExpiresAt'] as String),
  refreshToken: json['refreshToken'] as String,
  refreshTokenExpiresAt: DateTime.parse(
    json['refreshTokenExpiresAt'] as String,
  ),
  user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$LoginPayloadDtoImplToJson(
  _$LoginPayloadDtoImpl instance,
) => <String, dynamic>{
  'tokenType': instance.tokenType,
  'accessToken': instance.accessToken,
  'expiresIn': instance.expiresIn,
  'accessTokenExpiresAt': instance.accessTokenExpiresAt.toIso8601String(),
  'refreshToken': instance.refreshToken,
  'refreshTokenExpiresAt': instance.refreshTokenExpiresAt.toIso8601String(),
  'user': instance.user,
};

_$RegisterPayloadDtoImpl _$$RegisterPayloadDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterPayloadDtoImpl(
  message: json['message'] as String,
  emailVerificationRequired: json['emailVerificationRequired'] as bool,
);

Map<String, dynamic> _$$RegisterPayloadDtoImplToJson(
  _$RegisterPayloadDtoImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'emailVerificationRequired': instance.emailVerificationRequired,
};

_$MessagePayloadDtoImpl _$$MessagePayloadDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessagePayloadDtoImpl(message: json['message'] as String);

Map<String, dynamic> _$$MessagePayloadDtoImplToJson(
  _$MessagePayloadDtoImpl instance,
) => <String, dynamic>{'message': instance.message};

_$LoginDtoImpl _$$LoginDtoImplFromJson(Map<String, dynamic> json) =>
    _$LoginDtoImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginDtoImplToJson(_$LoginDtoImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$RegisterDtoImpl _$$RegisterDtoImplFromJson(Map<String, dynamic> json) =>
    _$RegisterDtoImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$RegisterDtoImplToJson(_$RegisterDtoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'phone': instance.phone,
    };

_$ForgotPasswordDtoImpl _$$ForgotPasswordDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ForgotPasswordDtoImpl(email: json['email'] as String);

Map<String, dynamic> _$$ForgotPasswordDtoImplToJson(
  _$ForgotPasswordDtoImpl instance,
) => <String, dynamic>{'email': instance.email};

_$ResetPasswordDtoImpl _$$ResetPasswordDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ResetPasswordDtoImpl(
  token: json['token'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$ResetPasswordDtoImplToJson(
  _$ResetPasswordDtoImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'newPassword': instance.newPassword,
};

_$VerifyEmailDtoImpl _$$VerifyEmailDtoImplFromJson(Map<String, dynamic> json) =>
    _$VerifyEmailDtoImpl(token: json['token'] as String);

Map<String, dynamic> _$$VerifyEmailDtoImplToJson(
  _$VerifyEmailDtoImpl instance,
) => <String, dynamic>{'token': instance.token};

_$ResendVerificationDtoImpl _$$ResendVerificationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ResendVerificationDtoImpl(email: json['email'] as String);

Map<String, dynamic> _$$ResendVerificationDtoImplToJson(
  _$ResendVerificationDtoImpl instance,
) => <String, dynamic>{'email': instance.email};

_$RefreshTokenDtoImpl _$$RefreshTokenDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenDtoImpl(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$$RefreshTokenDtoImplToJson(
  _$RefreshTokenDtoImpl instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};
