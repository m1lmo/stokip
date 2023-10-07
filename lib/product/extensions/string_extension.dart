import 'package:easy_localization/easy_localization.dart';

extension MyStringExtension on String {
  String locale() => this.tr();
  String withoutLocale() => this;
}
