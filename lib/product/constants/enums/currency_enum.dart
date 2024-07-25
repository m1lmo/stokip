import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stokip/product/database/core/hive_types.dart';
part 'currency_enum.g.dart';

@HiveType(typeId: HiveTypes.currencyEnumId)
enum CurrencyEnum {
  @HiveField(0)
  @JsonValue('tl')
  tl,
  @HiveField(1)
  @JsonValue('usd')
  usd,
  @HiveField(2)
  @JsonValue('')
  nullValue
}
