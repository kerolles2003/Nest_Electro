// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileDtoImpl _$$UserProfileDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileDtoImpl(
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

Map<String, dynamic> _$$UserProfileDtoImplToJson(
  _$UserProfileDtoImpl instance,
) => <String, dynamic>{
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

_$UpdateProfileDtoImpl _$$UpdateProfileDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateProfileDtoImpl(
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$$UpdateProfileDtoImplToJson(
  _$UpdateProfileDtoImpl instance,
) => <String, dynamic>{'fullName': instance.fullName, 'phone': instance.phone};

_$AddressDtoImpl _$$AddressDtoImplFromJson(Map<String, dynamic> json) =>
    _$AddressDtoImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      governorate: json['governorate'] as String,
      postalCode: json['postalCode'] as String,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AddressDtoImplToJson(_$AddressDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'street': instance.street,
      'city': instance.city,
      'governorate': instance.governorate,
      'postalCode': instance.postalCode,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CreateAddressDtoImpl _$$CreateAddressDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateAddressDtoImpl(
  label: json['label'] as String,
  fullName: json['fullName'] as String,
  phone: json['phone'] as String,
  street: json['street'] as String,
  city: json['city'] as String,
  governorate: json['governorate'] as String,
  postalCode: json['postalCode'] as String?,
  isDefault: json['isDefault'] as bool?,
);

Map<String, dynamic> _$$CreateAddressDtoImplToJson(
  _$CreateAddressDtoImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'street': instance.street,
  'city': instance.city,
  'governorate': instance.governorate,
  'postalCode': instance.postalCode,
  'isDefault': instance.isDefault,
};

_$UpdateAddressDtoImpl _$$UpdateAddressDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateAddressDtoImpl(
  label: json['label'] as String?,
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  street: json['street'] as String?,
  city: json['city'] as String?,
  governorate: json['governorate'] as String?,
  postalCode: json['postalCode'] as String?,
);

Map<String, dynamic> _$$UpdateAddressDtoImplToJson(
  _$UpdateAddressDtoImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'street': instance.street,
  'city': instance.city,
  'governorate': instance.governorate,
  'postalCode': instance.postalCode,
};
