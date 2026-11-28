// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginationMetaDto _$PaginationMetaDtoFromJson(Map<String, dynamic> json) {
  return _PaginationMetaDto.fromJson(json);
}

/// @nodoc
mixin _$PaginationMetaDto {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;
  bool get hasPrev => throw _privateConstructorUsedError;

  /// Serializes this PaginationMetaDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationMetaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationMetaDtoCopyWith<PaginationMetaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationMetaDtoCopyWith<$Res> {
  factory $PaginationMetaDtoCopyWith(
    PaginationMetaDto value,
    $Res Function(PaginationMetaDto) then,
  ) = _$PaginationMetaDtoCopyWithImpl<$Res, PaginationMetaDto>;
  @useResult
  $Res call({
    int page,
    int limit,
    int total,
    int totalPages,
    bool hasNext,
    bool hasPrev,
  });
}

/// @nodoc
class _$PaginationMetaDtoCopyWithImpl<$Res, $Val extends PaginationMetaDto>
    implements $PaginationMetaDtoCopyWith<$Res> {
  _$PaginationMetaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationMetaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            hasNext: null == hasNext
                ? _value.hasNext
                : hasNext // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasPrev: null == hasPrev
                ? _value.hasPrev
                : hasPrev // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginationMetaDtoImplCopyWith<$Res>
    implements $PaginationMetaDtoCopyWith<$Res> {
  factory _$$PaginationMetaDtoImplCopyWith(
    _$PaginationMetaDtoImpl value,
    $Res Function(_$PaginationMetaDtoImpl) then,
  ) = __$$PaginationMetaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    int limit,
    int total,
    int totalPages,
    bool hasNext,
    bool hasPrev,
  });
}

/// @nodoc
class __$$PaginationMetaDtoImplCopyWithImpl<$Res>
    extends _$PaginationMetaDtoCopyWithImpl<$Res, _$PaginationMetaDtoImpl>
    implements _$$PaginationMetaDtoImplCopyWith<$Res> {
  __$$PaginationMetaDtoImplCopyWithImpl(
    _$PaginationMetaDtoImpl _value,
    $Res Function(_$PaginationMetaDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginationMetaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(
      _$PaginationMetaDtoImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNext: null == hasNext
            ? _value.hasNext
            : hasNext // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasPrev: null == hasPrev
            ? _value.hasPrev
            : hasPrev // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationMetaDtoImpl implements _PaginationMetaDto {
  const _$PaginationMetaDtoImpl({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory _$PaginationMetaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationMetaDtoImplFromJson(json);

  @override
  final int page;
  @override
  final int limit;
  @override
  final int total;
  @override
  final int totalPages;
  @override
  final bool hasNext;
  @override
  final bool hasPrev;

  @override
  String toString() {
    return 'PaginationMetaDto(page: $page, limit: $limit, total: $total, totalPages: $totalPages, hasNext: $hasNext, hasPrev: $hasPrev)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationMetaDtoImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrev, hasPrev) || other.hasPrev == hasPrev));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    limit,
    total,
    totalPages,
    hasNext,
    hasPrev,
  );

  /// Create a copy of PaginationMetaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationMetaDtoImplCopyWith<_$PaginationMetaDtoImpl> get copyWith =>
      __$$PaginationMetaDtoImplCopyWithImpl<_$PaginationMetaDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationMetaDtoImplToJson(this);
  }
}

abstract class _PaginationMetaDto implements PaginationMetaDto {
  const factory _PaginationMetaDto({
    required final int page,
    required final int limit,
    required final int total,
    required final int totalPages,
    required final bool hasNext,
    required final bool hasPrev,
  }) = _$PaginationMetaDtoImpl;

  factory _PaginationMetaDto.fromJson(Map<String, dynamic> json) =
      _$PaginationMetaDtoImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  int get totalPages;
  @override
  bool get hasNext;
  @override
  bool get hasPrev;

  /// Create a copy of PaginationMetaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationMetaDtoImplCopyWith<_$PaginationMetaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
