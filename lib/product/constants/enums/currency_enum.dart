import 'package:hive_flutter/hive_flutter.dart';

import '../../database/core/hive_types.dart';
part 'currency_enum.g.dart';

@HiveType(typeId: HiveTypes.currencyEnumId)
enum CurrencyEnum {
  @HiveField(0)
  tl,
  @HiveField(1)
  usd
}

extension CurrencyEnumMixin on CurrencyEnum {
   String get getSymbol {
    switch (this) {
      case CurrencyEnum.tl:
        return '₺';
      case CurrencyEnum.usd:
        return '\$';
    }
  }
}
