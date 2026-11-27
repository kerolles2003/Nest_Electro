// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoneyDtoImpl _$$MoneyDtoImplFromJson(Map<String, dynamic> json) =>
    _$MoneyDtoImpl(
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      formatted: json['formatted'] as String,
    );

Map<String, dynamic> _$$MoneyDtoImplToJson(_$MoneyDtoImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'formatted': instance.formatted,
    };
