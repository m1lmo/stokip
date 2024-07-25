// import 'package:json_annotation/json_annotation.dart';
// import 'package:kartal/kartal.dart';
// import 'package:stokip/product/constants/enums/currency_enum.dart';

// class CurrencyEnumConverter implements JsonConverter<CurrencyEnum?, String?> {
//   /// Create a new instance of [CurrencyEnumConverter].
//   const CurrencyEnumConverter();

//   @override
//   CurrencyEnum? fromJson(String? json) {
//     if (json == null) return null;

//     return CurrencyEnum.values.firstWhereOrNull((element) => element.name == json);
//   }

//   @override
//   String? toJson(CurrencyEnum? object) {
//     if (object == null) return null;

//     return object.name;
//   }
// }
