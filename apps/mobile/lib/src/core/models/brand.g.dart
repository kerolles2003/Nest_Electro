// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandRefDtoImpl _$$BrandRefDtoImplFromJson(Map<String, dynamic> json) =>
    _$BrandRefDtoImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$BrandRefDtoImplToJson(_$BrandRefDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };

_$BrandDtoImpl _$$BrandDtoImplFromJson(Map<String, dynamic> json) =>
    _$BrandDtoImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      logo: json['logo'] == null
          ? null
          : ProductImageDto.fromJson(json['logo'] as Map<String, dynamic>),
      website: json['website'] as String,
      productCount: (json['productCount'] as num).toInt(),
    );

Map<String, dynamic> _$$BrandDtoImplToJson(_$BrandDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'logo': instance.logo,
      'website': instance.website,
      'productCount': instance.productCount,
    };
