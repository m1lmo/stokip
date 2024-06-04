import 'package:stokip/product/constants/enums/currency_enum.dart';

/// extension on [CurrencyEnum]
extension CurrencyEnumExtension on CurrencyEnum {
  /// getter for currency symbol
  String get currencySymbol {
    switch (this) {
      case CurrencyEnum.usd:
        return r'$';
      case CurrencyEnum.tl:
        return '₺';
    }
  }
}
