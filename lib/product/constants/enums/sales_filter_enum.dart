import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/mixin/filter_mixin.dart';

enum SalesFilterEnum with FilterMixin { today, yesterday, lastWeek, lastMonth }

extension SalesFilterEnumExtension on SalesFilterEnum {
  String get name {
    switch (this) {
      case SalesFilterEnum.today:
        return ProjectStrings.filterToday;
      case SalesFilterEnum.yesterday:
        return ProjectStrings.filterYesterday;
      case SalesFilterEnum.lastWeek:
        return ProjectStrings.filterLastWeek;
      case SalesFilterEnum.lastMonth:
        return ProjectStrings.filterLastMonth;
    }
  }
}
