// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationMetaDtoImpl _$$PaginationMetaDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PaginationMetaDtoImpl(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
  hasPrev: json['hasPrev'] as bool,
);

Map<String, dynamic> _$$PaginationMetaDtoImplToJson(
  _$PaginationMetaDtoImpl instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
  'hasNext': instance.hasNext,
  'hasPrev': instance.hasPrev,
};
