import 'package:flutter/material.dart';

class LocaleConstant {
  static const supportedLocales = [
    trLocale,
    enLocale,
  ];
  static const trLocale = Locale("tr", "TR");
  static const enLocale = Locale("en", "US");
  static const langPath = 'assets/translations';
}
