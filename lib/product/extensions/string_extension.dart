import 'package:easy_localization/easy_localization.dart';

extension MyStringExtension on String {
  String locale() => this.tr();
  String withoutLocale() => this;
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
