import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
