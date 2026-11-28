// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryRefDtoImpl _$$CategoryRefDtoImplFromJson(Map<String, dynamic> json) =>
    _$CategoryRefDtoImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$CategoryRefDtoImplToJson(
  _$CategoryRefDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
};

_$CategoryDtoImpl _$$CategoryDtoImplFromJson(Map<String, dynamic> json) =>
    _$CategoryDtoImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      parentId: json['parentId'] as String?,
      depth: (json['depth'] as num).toInt(),
      image: json['image'] == null
          ? null
          : ProductImageDto.fromJson(json['image'] as Map<String, dynamic>),
      productCount: (json['productCount'] as num).toInt(),
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$$CategoryDtoImplToJson(_$CategoryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'parentId': instance.parentId,
      'depth': instance.depth,
      'image': instance.image,
      'productCount': instance.productCount,
      'sortOrder': instance.sortOrder,
    };

_$CategoryDetailDtoImpl _$$CategoryDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryDetailDtoImpl(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  parentId: json['parentId'] as String?,
  depth: (json['depth'] as num).toInt(),
  image: json['image'] == null
      ? null
      : ProductImageDto.fromJson(json['image'] as Map<String, dynamic>),
  productCount: (json['productCount'] as num).toInt(),
  sortOrder: (json['sortOrder'] as num).toInt(),
  breadcrumb: (json['breadcrumb'] as List<dynamic>)
      .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CategoryDetailDtoImplToJson(
  _$CategoryDetailDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'description': instance.description,
  'parentId': instance.parentId,
  'depth': instance.depth,
  'image': instance.image,
  'productCount': instance.productCount,
  'sortOrder': instance.sortOrder,
  'breadcrumb': instance.breadcrumb,
};

_$CategoryTreeNodeDtoImpl _$$CategoryTreeNodeDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryTreeNodeDtoImpl(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  parentId: json['parentId'] as String?,
  depth: (json['depth'] as num).toInt(),
  image: json['image'] == null
      ? null
      : ProductImageDto.fromJson(json['image'] as Map<String, dynamic>),
  productCount: (json['productCount'] as num).toInt(),
  sortOrder: (json['sortOrder'] as num).toInt(),
  children: (json['children'] as List<dynamic>)
      .map((e) => CategoryTreeNodeDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CategoryTreeNodeDtoImplToJson(
  _$CategoryTreeNodeDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'description': instance.description,
  'parentId': instance.parentId,
  'depth': instance.depth,
  'image': instance.image,
  'productCount': instance.productCount,
  'sortOrder': instance.sortOrder,
  'children': instance.children,
};
