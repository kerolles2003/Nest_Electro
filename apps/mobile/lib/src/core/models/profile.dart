import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nest_electro/src/core/models/enums.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// Egyptian governorates accepted by the API for addresses
/// (CreateAddressDto.governorate enum, OpenAPI).
const List<String> egyptGovernorates = <String>[
  'Cairo',
  'Giza',
  'Alexandria',
  'Dakahlia',
  'Red Sea',
  'Beheira',
  'Fayoum',
  'Gharbia',
  'Ismailia',
  'Menofia',
  'Minya',
  'Qaliubiya',
  'New Valley',
  'Suez',
  'Aswan',
  'Assiut',
  'Beni Suef',
  'Port Said',
  'Damietta',
  'Sharkia',
  'South Sinai',
  'Kafr El Sheikh',
  'Matrouh',
  'Luxor',
  'Qena',
  'North Sinai',
  'Sohag',
];

@freezed
class UserProfileDto with _$UserProfileDto {
  const factory UserProfileDto({
    required String id,
    required String email,
    required String fullName,
    String? phone,
    @JsonKey(unknownEnumValue: Role.unknown) required Role role,
    required bool emailVerified,
    DateTime? lastLoginAt,
    required DateTime createdAt,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);
}

@freezed
class UpdateProfileDto with _$UpdateProfileDto {
  const factory UpdateProfileDto({
    String? fullName,
    String? phone,
  }) = _UpdateProfileDto;

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);
}

@freezed
class AddressDto with _$AddressDto {
  const factory AddressDto({
    required String id,
    required String label,
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String governorate,
    required String postalCode,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AddressDto;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);
}

@freezed
class CreateAddressDto with _$CreateAddressDto {
  const factory CreateAddressDto({
    required String label,
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String governorate,
    String? postalCode,
    bool? isDefault,
  }) = _CreateAddressDto;

  factory CreateAddressDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressDtoFromJson(json);
}

@freezed
class UpdateAddressDto with _$UpdateAddressDto {
  const factory UpdateAddressDto({
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? governorate,
    String? postalCode,
  }) = _UpdateAddressDto;

  factory UpdateAddressDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAddressDtoFromJson(json);
}
