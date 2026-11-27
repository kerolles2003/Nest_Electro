// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) {
  return _UserProfileDto.fromJson(json);
}

/// @nodoc
mixin _$UserProfileDto {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: Role.unknown)
  Role get role => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileDtoCopyWith<UserProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileDtoCopyWith<$Res> {
  factory $UserProfileDtoCopyWith(
    UserProfileDto value,
    $Res Function(UserProfileDto) then,
  ) = _$UserProfileDtoCopyWithImpl<$Res, UserProfileDto>;
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
class _$UserProfileDtoCopyWithImpl<$Res, $Val extends UserProfileDto>
    implements $UserProfileDtoCopyWith<$Res> {
  _$UserProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileDto
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
abstract class _$$UserProfileDtoImplCopyWith<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  factory _$$UserProfileDtoImplCopyWith(
    _$UserProfileDtoImpl value,
    $Res Function(_$UserProfileDtoImpl) then,
  ) = __$$UserProfileDtoImplCopyWithImpl<$Res>;
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
class __$$UserProfileDtoImplCopyWithImpl<$Res>
    extends _$UserProfileDtoCopyWithImpl<$Res, _$UserProfileDtoImpl>
    implements _$$UserProfileDtoImplCopyWith<$Res> {
  __$$UserProfileDtoImplCopyWithImpl(
    _$UserProfileDtoImpl _value,
    $Res Function(_$UserProfileDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileDto
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
      _$UserProfileDtoImpl(
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
class _$UserProfileDtoImpl implements _UserProfileDto {
  const _$UserProfileDtoImpl({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    @JsonKey(unknownEnumValue: Role.unknown) required this.role,
    required this.emailVerified,
    this.lastLoginAt,
    required this.createdAt,
  });

  factory _$UserProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileDtoImplFromJson(json);

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
    return 'UserProfileDto(id: $id, email: $email, fullName: $fullName, phone: $phone, role: $role, emailVerified: $emailVerified, lastLoginAt: $lastLoginAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileDtoImpl &&
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

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileDtoImplCopyWith<_$UserProfileDtoImpl> get copyWith =>
      __$$UserProfileDtoImplCopyWithImpl<_$UserProfileDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileDtoImplToJson(this);
  }
}

abstract class _UserProfileDto implements UserProfileDto {
  const factory _UserProfileDto({
    required final String id,
    required final String email,
    required final String fullName,
    final String? phone,
    @JsonKey(unknownEnumValue: Role.unknown) required final Role role,
    required final bool emailVerified,
    final DateTime? lastLoginAt,
    required final DateTime createdAt,
  }) = _$UserProfileDtoImpl;

  factory _UserProfileDto.fromJson(Map<String, dynamic> json) =
      _$UserProfileDtoImpl.fromJson;

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

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileDtoImplCopyWith<_$UserProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateProfileDto _$UpdateProfileDtoFromJson(Map<String, dynamic> json) {
  return _UpdateProfileDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateProfileDto {
  String? get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this UpdateProfileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateProfileDtoCopyWith<UpdateProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileDtoCopyWith<$Res> {
  factory $UpdateProfileDtoCopyWith(
    UpdateProfileDto value,
    $Res Function(UpdateProfileDto) then,
  ) = _$UpdateProfileDtoCopyWithImpl<$Res, UpdateProfileDto>;
  @useResult
  $Res call({String? fullName, String? phone});
}

/// @nodoc
class _$UpdateProfileDtoCopyWithImpl<$Res, $Val extends UpdateProfileDto>
    implements $UpdateProfileDtoCopyWith<$Res> {
  _$UpdateProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fullName = freezed, Object? phone = freezed}) {
    return _then(
      _value.copyWith(
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$UpdateProfileDtoImplCopyWith<$Res>
    implements $UpdateProfileDtoCopyWith<$Res> {
  factory _$$UpdateProfileDtoImplCopyWith(
    _$UpdateProfileDtoImpl value,
    $Res Function(_$UpdateProfileDtoImpl) then,
  ) = __$$UpdateProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? fullName, String? phone});
}

/// @nodoc
class __$$UpdateProfileDtoImplCopyWithImpl<$Res>
    extends _$UpdateProfileDtoCopyWithImpl<$Res, _$UpdateProfileDtoImpl>
    implements _$$UpdateProfileDtoImplCopyWith<$Res> {
  __$$UpdateProfileDtoImplCopyWithImpl(
    _$UpdateProfileDtoImpl _value,
    $Res Function(_$UpdateProfileDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fullName = freezed, Object? phone = freezed}) {
    return _then(
      _$UpdateProfileDtoImpl(
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$UpdateProfileDtoImpl implements _UpdateProfileDto {
  const _$UpdateProfileDtoImpl({this.fullName, this.phone});

  factory _$UpdateProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProfileDtoImplFromJson(json);

  @override
  final String? fullName;
  @override
  final String? phone;

  @override
  String toString() {
    return 'UpdateProfileDto(fullName: $fullName, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileDtoImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, phone);

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileDtoImplCopyWith<_$UpdateProfileDtoImpl> get copyWith =>
      __$$UpdateProfileDtoImplCopyWithImpl<_$UpdateProfileDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProfileDtoImplToJson(this);
  }
}

abstract class _UpdateProfileDto implements UpdateProfileDto {
  const factory _UpdateProfileDto({
    final String? fullName,
    final String? phone,
  }) = _$UpdateProfileDtoImpl;

  factory _UpdateProfileDto.fromJson(Map<String, dynamic> json) =
      _$UpdateProfileDtoImpl.fromJson;

  @override
  String? get fullName;
  @override
  String? get phone;

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProfileDtoImplCopyWith<_$UpdateProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) {
  return _AddressDto.fromJson(json);
}

/// @nodoc
mixin _$AddressDto {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get street => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get governorate => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AddressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressDtoCopyWith<AddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressDtoCopyWith<$Res> {
  factory $AddressDtoCopyWith(
    AddressDto value,
    $Res Function(AddressDto) then,
  ) = _$AddressDtoCopyWithImpl<$Res, AddressDto>;
  @useResult
  $Res call({
    String id,
    String label,
    String fullName,
    String phone,
    String street,
    String city,
    String governorate,
    String postalCode,
    bool isDefault,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$AddressDtoCopyWithImpl<$Res, $Val extends AddressDto>
    implements $AddressDtoCopyWith<$Res> {
  _$AddressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            street: null == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            governorate: null == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String,
            postalCode: null == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressDtoImplCopyWith<$Res>
    implements $AddressDtoCopyWith<$Res> {
  factory _$$AddressDtoImplCopyWith(
    _$AddressDtoImpl value,
    $Res Function(_$AddressDtoImpl) then,
  ) = __$$AddressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    String fullName,
    String phone,
    String street,
    String city,
    String governorate,
    String postalCode,
    bool isDefault,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$AddressDtoImplCopyWithImpl<$Res>
    extends _$AddressDtoCopyWithImpl<$Res, _$AddressDtoImpl>
    implements _$$AddressDtoImplCopyWith<$Res> {
  __$$AddressDtoImplCopyWithImpl(
    _$AddressDtoImpl _value,
    $Res Function(_$AddressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AddressDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        street: null == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        governorate: null == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String,
        postalCode: null == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressDtoImpl implements _AddressDto {
  const _$AddressDtoImpl({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.governorate,
    required this.postalCode,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$AddressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String street;
  @override
  final String city;
  @override
  final String governorate;
  @override
  final String postalCode;
  @override
  final bool isDefault;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AddressDto(id: $id, label: $label, fullName: $fullName, phone: $phone, street: $street, city: $city, governorate: $governorate, postalCode: $postalCode, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    fullName,
    phone,
    street,
    city,
    governorate,
    postalCode,
    isDefault,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressDtoImplCopyWith<_$AddressDtoImpl> get copyWith =>
      __$$AddressDtoImplCopyWithImpl<_$AddressDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressDtoImplToJson(this);
  }
}

abstract class _AddressDto implements AddressDto {
  const factory _AddressDto({
    required final String id,
    required final String label,
    required final String fullName,
    required final String phone,
    required final String street,
    required final String city,
    required final String governorate,
    required final String postalCode,
    required final bool isDefault,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$AddressDtoImpl;

  factory _AddressDto.fromJson(Map<String, dynamic> json) =
      _$AddressDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get street;
  @override
  String get city;
  @override
  String get governorate;
  @override
  String get postalCode;
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AddressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressDtoImplCopyWith<_$AddressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateAddressDto _$CreateAddressDtoFromJson(Map<String, dynamic> json) {
  return _CreateAddressDto.fromJson(json);
}

/// @nodoc
mixin _$CreateAddressDto {
  String get label => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get street => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get governorate => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  bool? get isDefault => throw _privateConstructorUsedError;

  /// Serializes this CreateAddressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateAddressDtoCopyWith<CreateAddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateAddressDtoCopyWith<$Res> {
  factory $CreateAddressDtoCopyWith(
    CreateAddressDto value,
    $Res Function(CreateAddressDto) then,
  ) = _$CreateAddressDtoCopyWithImpl<$Res, CreateAddressDto>;
  @useResult
  $Res call({
    String label,
    String fullName,
    String phone,
    String street,
    String city,
    String governorate,
    String? postalCode,
    bool? isDefault,
  });
}

/// @nodoc
class _$CreateAddressDtoCopyWithImpl<$Res, $Val extends CreateAddressDto>
    implements $CreateAddressDtoCopyWith<$Res> {
  _$CreateAddressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = freezed,
    Object? isDefault = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            street: null == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            governorate: null == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDefault: freezed == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateAddressDtoImplCopyWith<$Res>
    implements $CreateAddressDtoCopyWith<$Res> {
  factory _$$CreateAddressDtoImplCopyWith(
    _$CreateAddressDtoImpl value,
    $Res Function(_$CreateAddressDtoImpl) then,
  ) = __$$CreateAddressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    String fullName,
    String phone,
    String street,
    String city,
    String governorate,
    String? postalCode,
    bool? isDefault,
  });
}

/// @nodoc
class __$$CreateAddressDtoImplCopyWithImpl<$Res>
    extends _$CreateAddressDtoCopyWithImpl<$Res, _$CreateAddressDtoImpl>
    implements _$$CreateAddressDtoImplCopyWith<$Res> {
  __$$CreateAddressDtoImplCopyWithImpl(
    _$CreateAddressDtoImpl _value,
    $Res Function(_$CreateAddressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? fullName = null,
    Object? phone = null,
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = freezed,
    Object? isDefault = freezed,
  }) {
    return _then(
      _$CreateAddressDtoImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        street: null == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        governorate: null == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDefault: freezed == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateAddressDtoImpl implements _CreateAddressDto {
  const _$CreateAddressDtoImpl({
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.governorate,
    this.postalCode,
    this.isDefault,
  });

  factory _$CreateAddressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateAddressDtoImplFromJson(json);

  @override
  final String label;
  @override
  final String fullName;
  @override
  final String phone;
  @override
  final String street;
  @override
  final String city;
  @override
  final String governorate;
  @override
  final String? postalCode;
  @override
  final bool? isDefault;

  @override
  String toString() {
    return 'CreateAddressDto(label: $label, fullName: $fullName, phone: $phone, street: $street, city: $city, governorate: $governorate, postalCode: $postalCode, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateAddressDtoImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    label,
    fullName,
    phone,
    street,
    city,
    governorate,
    postalCode,
    isDefault,
  );

  /// Create a copy of CreateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateAddressDtoImplCopyWith<_$CreateAddressDtoImpl> get copyWith =>
      __$$CreateAddressDtoImplCopyWithImpl<_$CreateAddressDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateAddressDtoImplToJson(this);
  }
}

abstract class _CreateAddressDto implements CreateAddressDto {
  const factory _CreateAddressDto({
    required final String label,
    required final String fullName,
    required final String phone,
    required final String street,
    required final String city,
    required final String governorate,
    final String? postalCode,
    final bool? isDefault,
  }) = _$CreateAddressDtoImpl;

  factory _CreateAddressDto.fromJson(Map<String, dynamic> json) =
      _$CreateAddressDtoImpl.fromJson;

  @override
  String get label;
  @override
  String get fullName;
  @override
  String get phone;
  @override
  String get street;
  @override
  String get city;
  @override
  String get governorate;
  @override
  String? get postalCode;
  @override
  bool? get isDefault;

  /// Create a copy of CreateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateAddressDtoImplCopyWith<_$CreateAddressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateAddressDto _$UpdateAddressDtoFromJson(Map<String, dynamic> json) {
  return _UpdateAddressDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateAddressDto {
  String? get label => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get street => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get governorate => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;

  /// Serializes this UpdateAddressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateAddressDtoCopyWith<UpdateAddressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateAddressDtoCopyWith<$Res> {
  factory $UpdateAddressDtoCopyWith(
    UpdateAddressDto value,
    $Res Function(UpdateAddressDto) then,
  ) = _$UpdateAddressDtoCopyWithImpl<$Res, UpdateAddressDto>;
  @useResult
  $Res call({
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? governorate,
    String? postalCode,
  });
}

/// @nodoc
class _$UpdateAddressDtoCopyWithImpl<$Res, $Val extends UpdateAddressDto>
    implements $UpdateAddressDtoCopyWith<$Res> {
  _$UpdateAddressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? governorate = freezed,
    Object? postalCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            street: freezed == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            governorate: freezed == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateAddressDtoImplCopyWith<$Res>
    implements $UpdateAddressDtoCopyWith<$Res> {
  factory _$$UpdateAddressDtoImplCopyWith(
    _$UpdateAddressDtoImpl value,
    $Res Function(_$UpdateAddressDtoImpl) then,
  ) = __$$UpdateAddressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? governorate,
    String? postalCode,
  });
}

/// @nodoc
class __$$UpdateAddressDtoImplCopyWithImpl<$Res>
    extends _$UpdateAddressDtoCopyWithImpl<$Res, _$UpdateAddressDtoImpl>
    implements _$$UpdateAddressDtoImplCopyWith<$Res> {
  __$$UpdateAddressDtoImplCopyWithImpl(
    _$UpdateAddressDtoImpl _value,
    $Res Function(_$UpdateAddressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? governorate = freezed,
    Object? postalCode = freezed,
  }) {
    return _then(
      _$UpdateAddressDtoImpl(
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        street: freezed == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        governorate: freezed == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateAddressDtoImpl implements _UpdateAddressDto {
  const _$UpdateAddressDtoImpl({
    this.label,
    this.fullName,
    this.phone,
    this.street,
    this.city,
    this.governorate,
    this.postalCode,
  });

  factory _$UpdateAddressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateAddressDtoImplFromJson(json);

  @override
  final String? label;
  @override
  final String? fullName;
  @override
  final String? phone;
  @override
  final String? street;
  @override
  final String? city;
  @override
  final String? governorate;
  @override
  final String? postalCode;

  @override
  String toString() {
    return 'UpdateAddressDto(label: $label, fullName: $fullName, phone: $phone, street: $street, city: $city, governorate: $governorate, postalCode: $postalCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAddressDtoImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    label,
    fullName,
    phone,
    street,
    city,
    governorate,
    postalCode,
  );

  /// Create a copy of UpdateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAddressDtoImplCopyWith<_$UpdateAddressDtoImpl> get copyWith =>
      __$$UpdateAddressDtoImplCopyWithImpl<_$UpdateAddressDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateAddressDtoImplToJson(this);
  }
}

abstract class _UpdateAddressDto implements UpdateAddressDto {
  const factory _UpdateAddressDto({
    final String? label,
    final String? fullName,
    final String? phone,
    final String? street,
    final String? city,
    final String? governorate,
    final String? postalCode,
  }) = _$UpdateAddressDtoImpl;

  factory _UpdateAddressDto.fromJson(Map<String, dynamic> json) =
      _$UpdateAddressDtoImpl.fromJson;

  @override
  String? get label;
  @override
  String? get fullName;
  @override
  String? get phone;
  @override
  String? get street;
  @override
  String? get city;
  @override
  String? get governorate;
  @override
  String? get postalCode;

  /// Create a copy of UpdateAddressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAddressDtoImplCopyWith<_$UpdateAddressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
