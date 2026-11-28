import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';
part 'money.g.dart';

/// Money in integer minor units (piastres). `formatted` is the authoritative
/// display string from the API — never re-derive it client-side.
@freezed
class MoneyDto with _$MoneyDto {
  const factory MoneyDto({
    required int amount,
    required String currency,
    required String formatted,
  }) = _MoneyDto;

  const MoneyDto._();

  /// Amount in whole EGP (e.g. 38000 piastres -> 380.0). For display prefer
  /// [formatted]; this is for arithmetic and sorting only.
  double get asPounds => amount / 100;

  factory MoneyDto.fromJson(Map<String, dynamic> json) =>
      _$MoneyDtoFromJson(json);
}
