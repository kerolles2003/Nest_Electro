// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) {
  return _AuthUserDto.fromJson(json);
}

/// @nodoc
mixin _$AuthUserDto {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get role => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserDtoCopyWith<AuthUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserDtoCopyWith<$Res> {
  factory $AuthUserDtoCopyWith(
    AuthUserDto value,
    $Res Function(AuthUserDto) then,
  ) = _$AuthUserDtoCopyWithImpl<$Res, AuthUserDto>;
  @useResult
  $Res call({
    String id,
    String email,
    String fullName,
    String? phone,
    @JsonKey(unknownEnumValue: Role.unknown) Role role,
    bool emailVerified,
    DateTime? lastLoginAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res, $Val extends AuthUserDto>
    implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? role = null,
    Object? emailVerified = null,
    Object? lastLoginAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as Role,
            emailVerified: null == emailVerified
                ? _value.emailVerified
                : emailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastLoginAt: freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthUserDtoImplCopyWith<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  factory _$$AuthUserDtoImplCopyWith(
    _$AuthUserDtoImpl value,
    $Res Function(_$AuthUserDtoImpl) then,
  ) = __$$AuthUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String fullName,
    String? phone,
    @JsonKey(unknownEnumValue: Role.unknown) Role role,
    bool emailVerified,
    DateTime? lastLoginAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AuthUserDtoImplCopyWithImpl<$Res>
    extends _$AuthUserDtoCopyWithImpl<$Res, _$AuthUserDtoImpl>
    implements _$$AuthUserDtoImplCopyWith<$Res> {
  __$$AuthUserDtoImplCopyWithImpl(
    _$AuthUserDtoImpl _value,
    $Res Function(_$AuthUserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? role = null,
    Object? emailVerified = null,
    Object? lastLoginAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$AuthUserDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as Role,
        emailVerified: null == emailVerified
            ? _value.emailVerified
            : emailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastLoginAt: freezed == lastLoginAt
            ? _value.lastLoginAt
            : lastLoginAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserDtoImpl implements _AuthUserDto {
  const _$AuthUserDtoImpl({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    @JsonKey(unknownEnumValue: Role.unknown) required this.role,
    required this.emailVerified,
    this.lastLoginAt,
    required this.createdAt,
  });

  factory _$AuthUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final String? phone;
  @override
  @JsonKey(unknownEnumValue: Role.unknown)
  final Role role;
  @override
  final bool emailVerified;
  @override
  final DateTime? lastLoginAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AuthUserDto(id: $id, email: $email, fullName: $fullName, phone: $phone, role: $role, emailVerified: $emailVerified, lastLoginAt: $lastLoginAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    fullName,
    phone,
    role,
    emailVerified,
    lastLoginAt,
    createdAt,
  );

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserDtoImplCopyWith<_$AuthUserDtoImpl> get copyWith =>
      __$$AuthUserDtoImplCopyWithImpl<_$AuthUserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserDtoImplToJson(this);
  }
}

abstract class _AuthUserDto implements AuthUserDto {
  const factory _AuthUserDto({
    required final String id,
    required final String email,
    required final String fullName,
    final String? phone,
    @JsonKey(unknownEnumValue: Role.unknown) required final Role role,
    required final bool emailVerified,
    final DateTime? lastLoginAt,
    required final DateTime createdAt,
  }) = _$AuthUserDtoImpl;

  factory _AuthUserDto.fromJson(Map<String, dynamic> json) =
      _$AuthUserDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get fullName;
  @override
  String? get phone;
  @override
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get role;
  @override
  bool get emailVerified;
  @override
  DateTime? get lastLoginAt;
  @override
  DateTime get createdAt;

  /// Create a copy of AuthUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserDtoImplCopyWith<_$AuthUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionTokensDto _$SessionTokensDtoFromJson(Map<String, dynamic> json) {
  return _SessionTokensDto.fromJson(json);
}

/// @nodoc
mixin _$SessionTokensDto {
  String get tokenType => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  DateTime get accessTokenExpiresAt => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  DateTime get refreshTokenExpiresAt => throw _privateConstructorUsedError;

  /// Serializes this SessionTokensDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionTokensDtoCopyWith<SessionTokensDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionTokensDtoCopyWith<$Res> {
  factory $SessionTokensDtoCopyWith(
    SessionTokensDto value,
    $Res Function(SessionTokensDto) then,
  ) = _$SessionTokensDtoCopyWithImpl<$Res, SessionTokensDto>;
  @useResult
  $Res call({
    String tokenType,
    String accessToken,
    int expiresIn,
    DateTime accessTokenExpiresAt,
    String refreshToken,
    DateTime refreshTokenExpiresAt,
  });
}

/// @nodoc
class _$SessionTokensDtoCopyWithImpl<$Res, $Val extends SessionTokensDto>
    implements $SessionTokensDtoCopyWith<$Res> {
  _$SessionTokensDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenType = null,
    Object? accessToken = null,
    Object? expiresIn = null,
    Object? accessTokenExpiresAt = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            tokenType: null == tokenType
                ? _value.tokenType
                : tokenType // ignore: cast_nullable_to_non_nullable
                      as String,
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresIn: null == expiresIn
                ? _value.expiresIn
                : expiresIn // ignore: cast_nullable_to_non_nullable
                      as int,
            accessTokenExpiresAt: null == accessTokenExpiresAt
                ? _value.accessTokenExpiresAt
                : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshTokenExpiresAt: null == refreshTokenExpiresAt
                ? _value.refreshTokenExpiresAt
                : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionTokensDtoImplCopyWith<$Res>
    implements $SessionTokensDtoCopyWith<$Res> {
  factory _$$SessionTokensDtoImplCopyWith(
    _$SessionTokensDtoImpl value,
    $Res Function(_$SessionTokensDtoImpl) then,
  ) = __$$SessionTokensDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tokenType,
    String accessToken,
    int expiresIn,
    DateTime accessTokenExpiresAt,
    String refreshToken,
    DateTime refreshTokenExpiresAt,
  });
}

/// @nodoc
class __$$SessionTokensDtoImplCopyWithImpl<$Res>
    extends _$SessionTokensDtoCopyWithImpl<$Res, _$SessionTokensDtoImpl>
    implements _$$SessionTokensDtoImplCopyWith<$Res> {
  __$$SessionTokensDtoImplCopyWithImpl(
    _$SessionTokensDtoImpl _value,
    $Res Function(_$SessionTokensDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenType = null,
    Object? accessToken = null,
    Object? expiresIn = null,
    Object? accessTokenExpiresAt = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresAt = null,
  }) {
    return _then(
      _$SessionTokensDtoImpl(
        tokenType: null == tokenType
            ? _value.tokenType
            : tokenType // ignore: cast_nullable_to_non_nullable
                  as String,
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresIn: null == expiresIn
            ? _value.expiresIn
            : expiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        accessTokenExpiresAt: null == accessTokenExpiresAt
            ? _value.accessTokenExpiresAt
            : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshTokenExpiresAt: null == refreshTokenExpiresAt
            ? _value.refreshTokenExpiresAt
            : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionTokensDtoImpl implements _SessionTokensDto {
  const _$SessionTokensDtoImpl({
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });

  factory _$SessionTokensDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionTokensDtoImplFromJson(json);

  @override
  final String tokenType;
  @override
  final String accessToken;
  @override
  final int expiresIn;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;
  @override
  final DateTime refreshTokenExpiresAt;

  @override
  String toString() {
    return 'SessionTokensDto(tokenType: $tokenType, accessToken: $accessToken, expiresIn: $expiresIn, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionTokensDtoImpl &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.accessTokenExpiresAt, accessTokenExpiresAt) ||
                other.accessTokenExpiresAt == accessTokenExpiresAt) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) ||
                other.refreshTokenExpiresAt == refreshTokenExpiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tokenType,
    accessToken,
    expiresIn,
    accessTokenExpiresAt,
    refreshToken,
    refreshTokenExpiresAt,
  );

  /// Create a copy of SessionTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionTokensDtoImplCopyWith<_$SessionTokensDtoImpl> get copyWith =>
      __$$SessionTokensDtoImplCopyWithImpl<_$SessionTokensDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionTokensDtoImplToJson(this);
  }
}

abstract class _SessionTokensDto implements SessionTokensDto {
  const factory _SessionTokensDto({
    required final String tokenType,
    required final String accessToken,
    required final int expiresIn,
    required final DateTime accessTokenExpiresAt,
    required final String refreshToken,
    required final DateTime refreshTokenExpiresAt,
  }) = _$SessionTokensDtoImpl;

  factory _SessionTokensDto.fromJson(Map<String, dynamic> json) =
      _$SessionTokensDtoImpl.fromJson;

  @override
  String get tokenType;
  @override
  String get accessToken;
  @override
  int get expiresIn;
  @override
  DateTime get accessTokenExpiresAt;
  @override
  String get refreshToken;
  @override
  DateTime get refreshTokenExpiresAt;

  /// Create a copy of SessionTokensDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionTokensDtoImplCopyWith<_$SessionTokensDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginPayloadDto _$LoginPayloadDtoFromJson(Map<String, dynamic> json) {
  return _LoginPayloadDto.fromJson(json);
}

/// @nodoc
mixin _$LoginPayloadDto {
  String get tokenType => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  DateTime get accessTokenExpiresAt => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  DateTime get refreshTokenExpiresAt => throw _privateConstructorUsedError;
  AuthUserDto get user => throw _privateConstructorUsedError;

  /// Serializes this LoginPayloadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginPayloadDtoCopyWith<LoginPayloadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginPayloadDtoCopyWith<$Res> {
  factory $LoginPayloadDtoCopyWith(
    LoginPayloadDto value,
    $Res Function(LoginPayloadDto) then,
  ) = _$LoginPayloadDtoCopyWithImpl<$Res, LoginPayloadDto>;
  @useResult
  $Res call({
    String tokenType,
    String accessToken,
    int expiresIn,
    DateTime accessTokenExpiresAt,
    String refreshToken,
    DateTime refreshTokenExpiresAt,
    AuthUserDto user,
  });

  $AuthUserDtoCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginPayloadDtoCopyWithImpl<$Res, $Val extends LoginPayloadDto>
    implements $LoginPayloadDtoCopyWith<$Res> {
  _$LoginPayloadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenType = null,
    Object? accessToken = null,
    Object? expiresIn = null,
    Object? accessTokenExpiresAt = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresAt = null,
    Object? user = null,
  }) {
    return _then(
      _value.copyWith(
            tokenType: null == tokenType
                ? _value.tokenType
                : tokenType // ignore: cast_nullable_to_non_nullable
                      as String,
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresIn: null == expiresIn
                ? _value.expiresIn
                : expiresIn // ignore: cast_nullable_to_non_nullable
                      as int,
            accessTokenExpiresAt: null == accessTokenExpiresAt
                ? _value.accessTokenExpiresAt
                : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshTokenExpiresAt: null == refreshTokenExpiresAt
                ? _value.refreshTokenExpiresAt
                : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as AuthUserDto,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserDtoCopyWith<$Res> get user {
    return $AuthUserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginPayloadDtoImplCopyWith<$Res>
    implements $LoginPayloadDtoCopyWith<$Res> {
  factory _$$LoginPayloadDtoImplCopyWith(
    _$LoginPayloadDtoImpl value,
    $Res Function(_$LoginPayloadDtoImpl) then,
  ) = __$$LoginPayloadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tokenType,
    String accessToken,
    int expiresIn,
    DateTime accessTokenExpiresAt,
    String refreshToken,
    DateTime refreshTokenExpiresAt,
    AuthUserDto user,
  });

  @override
  $AuthUserDtoCopyWith<$Res> get user;
}

/// @nodoc
class __$$LoginPayloadDtoImplCopyWithImpl<$Res>
    extends _$LoginPayloadDtoCopyWithImpl<$Res, _$LoginPayloadDtoImpl>
    implements _$$LoginPayloadDtoImplCopyWith<$Res> {
  __$$LoginPayloadDtoImplCopyWithImpl(
    _$LoginPayloadDtoImpl _value,
    $Res Function(_$LoginPayloadDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenType = null,
    Object? accessToken = null,
    Object? expiresIn = null,
    Object? accessTokenExpiresAt = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresAt = null,
    Object? user = null,
  }) {
    return _then(
      _$LoginPayloadDtoImpl(
        tokenType: null == tokenType
            ? _value.tokenType
            : tokenType // ignore: cast_nullable_to_non_nullable
                  as String,
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresIn: null == expiresIn
            ? _value.expiresIn
            : expiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        accessTokenExpiresAt: null == accessTokenExpiresAt
            ? _value.accessTokenExpiresAt
            : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshTokenExpiresAt: null == refreshTokenExpiresAt
            ? _value.refreshTokenExpiresAt
            : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as AuthUserDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginPayloadDtoImpl implements _LoginPayloadDto {
  const _$LoginPayloadDtoImpl({
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
    required this.user,
  });

  factory _$LoginPayloadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginPayloadDtoImplFromJson(json);

  @override
  final String tokenType;
  @override
  final String accessToken;
  @override
  final int expiresIn;
  @override
  final DateTime accessTokenExpiresAt;
  @override
  final String refreshToken;
  @override
  final DateTime refreshTokenExpiresAt;
  @override
  final AuthUserDto user;

  @override
  String toString() {
    return 'LoginPayloadDto(tokenType: $tokenType, accessToken: $accessToken, expiresIn: $expiresIn, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginPayloadDtoImpl &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.accessTokenExpiresAt, accessTokenExpiresAt) ||
                other.accessTokenExpiresAt == accessTokenExpiresAt) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) ||
                other.refreshTokenExpiresAt == refreshTokenExpiresAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tokenType,
    accessToken,
    expiresIn,
    accessTokenExpiresAt,
    refreshToken,
    refreshTokenExpiresAt,
    user,
  );

  /// Create a copy of LoginPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginPayloadDtoImplCopyWith<_$LoginPayloadDtoImpl> get copyWith =>
      __$$LoginPayloadDtoImplCopyWithImpl<_$LoginPayloadDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginPayloadDtoImplToJson(this);
  }
}

abstract class _LoginPayloadDto implements LoginPayloadDto {
  const factory _LoginPayloadDto({
    required final String tokenType,
    required final String accessToken,
    required final int expiresIn,
    required final DateTime accessTokenExpiresAt,
    required final String refreshToken,
    required final DateTime refreshTokenExpiresAt,
    required final AuthUserDto user,
  }) = _$LoginPayloadDtoImpl;

  factory _LoginPayloadDto.fromJson(Map<String, dynamic> json) =
      _$LoginPayloadDtoImpl.fromJson;

  @override
  String get tokenType;
  @override
  String get accessToken;
  @override
  int get expiresIn;
  @override
  DateTime get accessTokenExpiresAt;
  @override
  String get refreshToken;
  @override
  DateTime get refreshTokenExpiresAt;
  @override
  AuthUserDto get user;

  /// Create a copy of LoginPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginPayloadDtoImplCopyWith<_$LoginPayloadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterPayloadDto _$RegisterPayloadDtoFromJson(Map<String, dynamic> json) {
  return _RegisterPayloadDto.fromJson(json);
}

/// @nodoc
mixin _$RegisterPayloadDto {
  String get message => throw _privateConstructorUsedError;
  bool get emailVerificationRequired => throw _privateConstructorUsedError;

  /// Serializes this RegisterPayloadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterPayloadDtoCopyWith<RegisterPayloadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterPayloadDtoCopyWith<$Res> {
  factory $RegisterPayloadDtoCopyWith(
    RegisterPayloadDto value,
    $Res Function(RegisterPayloadDto) then,
  ) = _$RegisterPayloadDtoCopyWithImpl<$Res, RegisterPayloadDto>;
  @useResult
  $Res call({String message, bool emailVerificationRequired});
}

/// @nodoc
class _$RegisterPayloadDtoCopyWithImpl<$Res, $Val extends RegisterPayloadDto>
    implements $RegisterPayloadDtoCopyWith<$Res> {
  _$RegisterPayloadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? emailVerificationRequired = null,
  }) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            emailVerificationRequired: null == emailVerificationRequired
                ? _value.emailVerificationRequired
                : emailVerificationRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterPayloadDtoImplCopyWith<$Res>
    implements $RegisterPayloadDtoCopyWith<$Res> {
  factory _$$RegisterPayloadDtoImplCopyWith(
    _$RegisterPayloadDtoImpl value,
    $Res Function(_$RegisterPayloadDtoImpl) then,
  ) = __$$RegisterPayloadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, bool emailVerificationRequired});
}

/// @nodoc
class __$$RegisterPayloadDtoImplCopyWithImpl<$Res>
    extends _$RegisterPayloadDtoCopyWithImpl<$Res, _$RegisterPayloadDtoImpl>
    implements _$$RegisterPayloadDtoImplCopyWith<$Res> {
  __$$RegisterPayloadDtoImplCopyWithImpl(
    _$RegisterPayloadDtoImpl _value,
    $Res Function(_$RegisterPayloadDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? emailVerificationRequired = null,
  }) {
    return _then(
      _$RegisterPayloadDtoImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        emailVerificationRequired: null == emailVerificationRequired
            ? _value.emailVerificationRequired
            : emailVerificationRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterPayloadDtoImpl implements _RegisterPayloadDto {
  const _$RegisterPayloadDtoImpl({
    required this.message,
    required this.emailVerificationRequired,
  });

  factory _$RegisterPayloadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterPayloadDtoImplFromJson(json);

  @override
  final String message;
  @override
  final bool emailVerificationRequired;

  @override
  String toString() {
    return 'RegisterPayloadDto(message: $message, emailVerificationRequired: $emailVerificationRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterPayloadDtoImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(
                  other.emailVerificationRequired,
                  emailVerificationRequired,
                ) ||
                other.emailVerificationRequired == emailVerificationRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, message, emailVerificationRequired);

  /// Create a copy of RegisterPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterPayloadDtoImplCopyWith<_$RegisterPayloadDtoImpl> get copyWith =>
      __$$RegisterPayloadDtoImplCopyWithImpl<_$RegisterPayloadDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterPayloadDtoImplToJson(this);
  }
}

abstract class _RegisterPayloadDto implements RegisterPayloadDto {
  const factory _RegisterPayloadDto({
    required final String message,
    required final bool emailVerificationRequired,
  }) = _$RegisterPayloadDtoImpl;

  factory _RegisterPayloadDto.fromJson(Map<String, dynamic> json) =
      _$RegisterPayloadDtoImpl.fromJson;

  @override
  String get message;
  @override
  bool get emailVerificationRequired;

  /// Create a copy of RegisterPayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterPayloadDtoImplCopyWith<_$RegisterPayloadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessagePayloadDto _$MessagePayloadDtoFromJson(Map<String, dynamic> json) {
  return _MessagePayloadDto.fromJson(json);
}

/// @nodoc
mixin _$MessagePayloadDto {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this MessagePayloadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessagePayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessagePayloadDtoCopyWith<MessagePayloadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagePayloadDtoCopyWith<$Res> {
  factory $MessagePayloadDtoCopyWith(
    MessagePayloadDto value,
    $Res Function(MessagePayloadDto) then,
  ) = _$MessagePayloadDtoCopyWithImpl<$Res, MessagePayloadDto>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$MessagePayloadDtoCopyWithImpl<$Res, $Val extends MessagePayloadDto>
    implements $MessagePayloadDtoCopyWith<$Res> {
  _$MessagePayloadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessagePayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessagePayloadDtoImplCopyWith<$Res>
    implements $MessagePayloadDtoCopyWith<$Res> {
  factory _$$MessagePayloadDtoImplCopyWith(
    _$MessagePayloadDtoImpl value,
    $Res Function(_$MessagePayloadDtoImpl) then,
  ) = __$$MessagePayloadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$MessagePayloadDtoImplCopyWithImpl<$Res>
    extends _$MessagePayloadDtoCopyWithImpl<$Res, _$MessagePayloadDtoImpl>
    implements _$$MessagePayloadDtoImplCopyWith<$Res> {
  __$$MessagePayloadDtoImplCopyWithImpl(
    _$MessagePayloadDtoImpl _value,
    $Res Function(_$MessagePayloadDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessagePayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$MessagePayloadDtoImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessagePayloadDtoImpl implements _MessagePayloadDto {
  const _$MessagePayloadDtoImpl({required this.message});

  factory _$MessagePayloadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessagePayloadDtoImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'MessagePayloadDto(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessagePayloadDtoImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MessagePayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessagePayloadDtoImplCopyWith<_$MessagePayloadDtoImpl> get copyWith =>
      __$$MessagePayloadDtoImplCopyWithImpl<_$MessagePayloadDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessagePayloadDtoImplToJson(this);
  }
}

abstract class _MessagePayloadDto implements MessagePayloadDto {
  const factory _MessagePayloadDto({required final String message}) =
      _$MessagePayloadDtoImpl;

  factory _MessagePayloadDto.fromJson(Map<String, dynamic> json) =
      _$MessagePayloadDtoImpl.fromJson;

  @override
  String get message;

  /// Create a copy of MessagePayloadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessagePayloadDtoImplCopyWith<_$MessagePayloadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) {
  return _LoginDto.fromJson(json);
}

/// @nodoc
mixin _$LoginDto {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginDtoCopyWith<LoginDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginDtoCopyWith<$Res> {
  factory $LoginDtoCopyWith(LoginDto value, $Res Function(LoginDto) then) =
      _$LoginDtoCopyWithImpl<$Res, LoginDto>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LoginDtoCopyWithImpl<$Res, $Val extends LoginDto>
    implements $LoginDtoCopyWith<$Res> {
  _$LoginDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginDtoImplCopyWith<$Res>
    implements $LoginDtoCopyWith<$Res> {
  factory _$$LoginDtoImplCopyWith(
    _$LoginDtoImpl value,
    $Res Function(_$LoginDtoImpl) then,
  ) = __$$LoginDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginDtoImplCopyWithImpl<$Res>
    extends _$LoginDtoCopyWithImpl<$Res, _$LoginDtoImpl>
    implements _$$LoginDtoImplCopyWith<$Res> {
  __$$LoginDtoImplCopyWithImpl(
    _$LoginDtoImpl _value,
    $Res Function(_$LoginDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$LoginDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginDtoImpl implements _LoginDto {
  const _$LoginDtoImpl({required this.email, required this.password});

  factory _$LoginDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginDto(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginDtoImplCopyWith<_$LoginDtoImpl> get copyWith =>
      __$$LoginDtoImplCopyWithImpl<_$LoginDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginDtoImplToJson(this);
  }
}

abstract class _LoginDto implements LoginDto {
  const factory _LoginDto({
    required final String email,
    required final String password,
  }) = _$LoginDtoImpl;

  factory _LoginDto.fromJson(Map<String, dynamic> json) =
      _$LoginDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LoginDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginDtoImplCopyWith<_$LoginDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) {
  return _RegisterDto.fromJson(json);
}

/// @nodoc
mixin _$RegisterDto {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this RegisterDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterDtoCopyWith<RegisterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterDtoCopyWith<$Res> {
  factory $RegisterDtoCopyWith(
    RegisterDto value,
    $Res Function(RegisterDto) then,
  ) = _$RegisterDtoCopyWithImpl<$Res, RegisterDto>;
  @useResult
  $Res call({String email, String password, String fullName, String? phone});
}

/// @nodoc
class _$RegisterDtoCopyWithImpl<$Res, $Val extends RegisterDto>
    implements $RegisterDtoCopyWith<$Res> {
  _$RegisterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phone = freezed,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterDtoImplCopyWith<$Res>
    implements $RegisterDtoCopyWith<$Res> {
  factory _$$RegisterDtoImplCopyWith(
    _$RegisterDtoImpl value,
    $Res Function(_$RegisterDtoImpl) then,
  ) = __$$RegisterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password, String fullName, String? phone});
}

/// @nodoc
class __$$RegisterDtoImplCopyWithImpl<$Res>
    extends _$RegisterDtoCopyWithImpl<$Res, _$RegisterDtoImpl>
    implements _$$RegisterDtoImplCopyWith<$Res> {
  __$$RegisterDtoImplCopyWithImpl(
    _$RegisterDtoImpl _value,
    $Res Function(_$RegisterDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phone = freezed,
  }) {
    return _then(
      _$RegisterDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterDtoImpl implements _RegisterDto {
  const _$RegisterDtoImpl({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
  });

  factory _$RegisterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String fullName;
  @override
  final String? phone;

  @override
  String toString() {
    return 'RegisterDto(email: $email, password: $password, fullName: $fullName, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, fullName, phone);

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterDtoImplCopyWith<_$RegisterDtoImpl> get copyWith =>
      __$$RegisterDtoImplCopyWithImpl<_$RegisterDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterDtoImplToJson(this);
  }
}

abstract class _RegisterDto implements RegisterDto {
  const factory _RegisterDto({
    required final String email,
    required final String password,
    required final String fullName,
    final String? phone,
  }) = _$RegisterDtoImpl;

  factory _RegisterDto.fromJson(Map<String, dynamic> json) =
      _$RegisterDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  String get fullName;
  @override
  String? get phone;

  /// Create a copy of RegisterDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterDtoImplCopyWith<_$RegisterDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ForgotPasswordDto _$ForgotPasswordDtoFromJson(Map<String, dynamic> json) {
  return _ForgotPasswordDto.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordDto {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ForgotPasswordDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordDtoCopyWith<ForgotPasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordDtoCopyWith<$Res> {
  factory $ForgotPasswordDtoCopyWith(
    ForgotPasswordDto value,
    $Res Function(ForgotPasswordDto) then,
  ) = _$ForgotPasswordDtoCopyWithImpl<$Res, ForgotPasswordDto>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$ForgotPasswordDtoCopyWithImpl<$Res, $Val extends ForgotPasswordDto>
    implements $ForgotPasswordDtoCopyWith<$Res> {
  _$ForgotPasswordDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgotPasswordDtoImplCopyWith<$Res>
    implements $ForgotPasswordDtoCopyWith<$Res> {
  factory _$$ForgotPasswordDtoImplCopyWith(
    _$ForgotPasswordDtoImpl value,
    $Res Function(_$ForgotPasswordDtoImpl) then,
  ) = __$$ForgotPasswordDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ForgotPasswordDtoImplCopyWithImpl<$Res>
    extends _$ForgotPasswordDtoCopyWithImpl<$Res, _$ForgotPasswordDtoImpl>
    implements _$$ForgotPasswordDtoImplCopyWith<$Res> {
  __$$ForgotPasswordDtoImplCopyWithImpl(
    _$ForgotPasswordDtoImpl _value,
    $Res Function(_$ForgotPasswordDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgotPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$ForgotPasswordDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordDtoImpl implements _ForgotPasswordDto {
  const _$ForgotPasswordDtoImpl({required this.email});

  factory _$ForgotPasswordDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordDtoImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'ForgotPasswordDto(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordDtoImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ForgotPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordDtoImplCopyWith<_$ForgotPasswordDtoImpl> get copyWith =>
      __$$ForgotPasswordDtoImplCopyWithImpl<_$ForgotPasswordDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordDtoImplToJson(this);
  }
}

abstract class _ForgotPasswordDto implements ForgotPasswordDto {
  const factory _ForgotPasswordDto({required final String email}) =
      _$ForgotPasswordDtoImpl;

  factory _ForgotPasswordDto.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordDtoImpl.fromJson;

  @override
  String get email;

  /// Create a copy of ForgotPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordDtoImplCopyWith<_$ForgotPasswordDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResetPasswordDto _$ResetPasswordDtoFromJson(Map<String, dynamic> json) {
  return _ResetPasswordDto.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordDto {
  String get token => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this ResetPasswordDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResetPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPasswordDtoCopyWith<ResetPasswordDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordDtoCopyWith<$Res> {
  factory $ResetPasswordDtoCopyWith(
    ResetPasswordDto value,
    $Res Function(ResetPasswordDto) then,
  ) = _$ResetPasswordDtoCopyWithImpl<$Res, ResetPasswordDto>;
  @useResult
  $Res call({String token, String newPassword});
}

/// @nodoc
class _$ResetPasswordDtoCopyWithImpl<$Res, $Val extends ResetPasswordDto>
    implements $ResetPasswordDtoCopyWith<$Res> {
  _$ResetPasswordDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null, Object? newPassword = null}) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            newPassword: null == newPassword
                ? _value.newPassword
                : newPassword // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResetPasswordDtoImplCopyWith<$Res>
    implements $ResetPasswordDtoCopyWith<$Res> {
  factory _$$ResetPasswordDtoImplCopyWith(
    _$ResetPasswordDtoImpl value,
    $Res Function(_$ResetPasswordDtoImpl) then,
  ) = __$$ResetPasswordDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String newPassword});
}

/// @nodoc
class __$$ResetPasswordDtoImplCopyWithImpl<$Res>
    extends _$ResetPasswordDtoCopyWithImpl<$Res, _$ResetPasswordDtoImpl>
    implements _$$ResetPasswordDtoImplCopyWith<$Res> {
  __$$ResetPasswordDtoImplCopyWithImpl(
    _$ResetPasswordDtoImpl _value,
    $Res Function(_$ResetPasswordDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResetPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null, Object? newPassword = null}) {
    return _then(
      _$ResetPasswordDtoImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPasswordDtoImpl implements _ResetPasswordDto {
  const _$ResetPasswordDtoImpl({
    required this.token,
    required this.newPassword,
  });

  factory _$ResetPasswordDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordDtoImplFromJson(json);

  @override
  final String token;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'ResetPasswordDto(token: $token, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordDtoImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, newPassword);

  /// Create a copy of ResetPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordDtoImplCopyWith<_$ResetPasswordDtoImpl> get copyWith =>
      __$$ResetPasswordDtoImplCopyWithImpl<_$ResetPasswordDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordDtoImplToJson(this);
  }
}

abstract class _ResetPasswordDto implements ResetPasswordDto {
  const factory _ResetPasswordDto({
    required final String token,
    required final String newPassword,
  }) = _$ResetPasswordDtoImpl;

  factory _ResetPasswordDto.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordDtoImpl.fromJson;

  @override
  String get token;
  @override
  String get newPassword;

  /// Create a copy of ResetPasswordDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordDtoImplCopyWith<_$ResetPasswordDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyEmailDto _$VerifyEmailDtoFromJson(Map<String, dynamic> json) {
  return _VerifyEmailDto.fromJson(json);
}

/// @nodoc
mixin _$VerifyEmailDto {
  String get token => throw _privateConstructorUsedError;

  /// Serializes this VerifyEmailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyEmailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyEmailDtoCopyWith<VerifyEmailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyEmailDtoCopyWith<$Res> {
  factory $VerifyEmailDtoCopyWith(
    VerifyEmailDto value,
    $Res Function(VerifyEmailDto) then,
  ) = _$VerifyEmailDtoCopyWithImpl<$Res, VerifyEmailDto>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$VerifyEmailDtoCopyWithImpl<$Res, $Val extends VerifyEmailDto>
    implements $VerifyEmailDtoCopyWith<$Res> {
  _$VerifyEmailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyEmailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null}) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerifyEmailDtoImplCopyWith<$Res>
    implements $VerifyEmailDtoCopyWith<$Res> {
  factory _$$VerifyEmailDtoImplCopyWith(
    _$VerifyEmailDtoImpl value,
    $Res Function(_$VerifyEmailDtoImpl) then,
  ) = __$$VerifyEmailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$VerifyEmailDtoImplCopyWithImpl<$Res>
    extends _$VerifyEmailDtoCopyWithImpl<$Res, _$VerifyEmailDtoImpl>
    implements _$$VerifyEmailDtoImplCopyWith<$Res> {
  __$$VerifyEmailDtoImplCopyWithImpl(
    _$VerifyEmailDtoImpl _value,
    $Res Function(_$VerifyEmailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyEmailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null}) {
    return _then(
      _$VerifyEmailDtoImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyEmailDtoImpl implements _VerifyEmailDto {
  const _$VerifyEmailDtoImpl({required this.token});

  factory _$VerifyEmailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyEmailDtoImplFromJson(json);

  @override
  final String token;

  @override
  String toString() {
    return 'VerifyEmailDto(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailDtoImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of VerifyEmailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailDtoImplCopyWith<_$VerifyEmailDtoImpl> get copyWith =>
      __$$VerifyEmailDtoImplCopyWithImpl<_$VerifyEmailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyEmailDtoImplToJson(this);
  }
}

abstract class _VerifyEmailDto implements VerifyEmailDto {
  const factory _VerifyEmailDto({required final String token}) =
      _$VerifyEmailDtoImpl;

  factory _VerifyEmailDto.fromJson(Map<String, dynamic> json) =
      _$VerifyEmailDtoImpl.fromJson;

  @override
  String get token;

  /// Create a copy of VerifyEmailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailDtoImplCopyWith<_$VerifyEmailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResendVerificationDto _$ResendVerificationDtoFromJson(
  Map<String, dynamic> json,
) {
  return _ResendVerificationDto.fromJson(json);
}

/// @nodoc
mixin _$ResendVerificationDto {
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ResendVerificationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResendVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResendVerificationDtoCopyWith<ResendVerificationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResendVerificationDtoCopyWith<$Res> {
  factory $ResendVerificationDtoCopyWith(
    ResendVerificationDto value,
    $Res Function(ResendVerificationDto) then,
  ) = _$ResendVerificationDtoCopyWithImpl<$Res, ResendVerificationDto>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$ResendVerificationDtoCopyWithImpl<
  $Res,
  $Val extends ResendVerificationDto
>
    implements $ResendVerificationDtoCopyWith<$Res> {
  _$ResendVerificationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResendVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResendVerificationDtoImplCopyWith<$Res>
    implements $ResendVerificationDtoCopyWith<$Res> {
  factory _$$ResendVerificationDtoImplCopyWith(
    _$ResendVerificationDtoImpl value,
    $Res Function(_$ResendVerificationDtoImpl) then,
  ) = __$$ResendVerificationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ResendVerificationDtoImplCopyWithImpl<$Res>
    extends
        _$ResendVerificationDtoCopyWithImpl<$Res, _$ResendVerificationDtoImpl>
    implements _$$ResendVerificationDtoImplCopyWith<$Res> {
  __$$ResendVerificationDtoImplCopyWithImpl(
    _$ResendVerificationDtoImpl _value,
    $Res Function(_$ResendVerificationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResendVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$ResendVerificationDtoImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResendVerificationDtoImpl implements _ResendVerificationDto {
  const _$ResendVerificationDtoImpl({required this.email});

  factory _$ResendVerificationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResendVerificationDtoImplFromJson(json);

  @override
  final String email;

  @override
  String toString() {
    return 'ResendVerificationDto(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResendVerificationDtoImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ResendVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResendVerificationDtoImplCopyWith<_$ResendVerificationDtoImpl>
  get copyWith =>
      __$$ResendVerificationDtoImplCopyWithImpl<_$ResendVerificationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ResendVerificationDtoImplToJson(this);
  }
}

abstract class _ResendVerificationDto implements ResendVerificationDto {
  const factory _ResendVerificationDto({required final String email}) =
      _$ResendVerificationDtoImpl;

  factory _ResendVerificationDto.fromJson(Map<String, dynamic> json) =
      _$ResendVerificationDtoImpl.fromJson;

  @override
  String get email;

  /// Create a copy of ResendVerificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResendVerificationDtoImplCopyWith<_$ResendVerificationDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RefreshTokenDto _$RefreshTokenDtoFromJson(Map<String, dynamic> json) {
  return _RefreshTokenDto.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenDto {
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshTokenDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshTokenDtoCopyWith<RefreshTokenDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenDtoCopyWith<$Res> {
  factory $RefreshTokenDtoCopyWith(
    RefreshTokenDto value,
    $Res Function(RefreshTokenDto) then,
  ) = _$RefreshTokenDtoCopyWithImpl<$Res, RefreshTokenDto>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class _$RefreshTokenDtoCopyWithImpl<$Res, $Val extends RefreshTokenDto>
    implements $RefreshTokenDtoCopyWith<$Res> {
  _$RefreshTokenDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _value.copyWith(
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefreshTokenDtoImplCopyWith<$Res>
    implements $RefreshTokenDtoCopyWith<$Res> {
  factory _$$RefreshTokenDtoImplCopyWith(
    _$RefreshTokenDtoImpl value,
    $Res Function(_$RefreshTokenDtoImpl) then,
  ) = __$$RefreshTokenDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$RefreshTokenDtoImplCopyWithImpl<$Res>
    extends _$RefreshTokenDtoCopyWithImpl<$Res, _$RefreshTokenDtoImpl>
    implements _$$RefreshTokenDtoImplCopyWith<$Res> {
  __$$RefreshTokenDtoImplCopyWithImpl(
    _$RefreshTokenDtoImpl _value,
    $Res Function(_$RefreshTokenDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RefreshTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _$RefreshTokenDtoImpl(
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenDtoImpl implements _RefreshTokenDto {
  const _$RefreshTokenDtoImpl({required this.refreshToken});

  factory _$RefreshTokenDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenDtoImplFromJson(json);

  @override
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshTokenDto(refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenDtoImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of RefreshTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenDtoImplCopyWith<_$RefreshTokenDtoImpl> get copyWith =>
      __$$RefreshTokenDtoImplCopyWithImpl<_$RefreshTokenDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenDtoImplToJson(this);
  }
}

abstract class _RefreshTokenDto implements RefreshTokenDto {
  const factory _RefreshTokenDto({required final String refreshToken}) =
      _$RefreshTokenDtoImpl;

  factory _RefreshTokenDto.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenDtoImpl.fromJson;

  @override
  String get refreshToken;

  /// Create a copy of RefreshTokenDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshTokenDtoImplCopyWith<_$RefreshTokenDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
