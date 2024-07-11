import 'package:flutter/material.dart';
import 'package:stokip/product/constants/enums/current_tabs_enum.dart';
import 'package:stokip/product/widgets/custom_icon.dart';

extension CurrentTabExtension on CurrentTabsEnum {
  String get tabTitle {
    switch (this) {
      case CurrentTabsEnum.customer:
        return 'Customer';
      case CurrentTabsEnum.supplier:
        return 'Supplier';
    }
  }

  Widget get getIcon {
    switch (this) {
      case CurrentTabsEnum.customer:
        return const Center(
          child: Icon(
            CustomIcons.customer,
          ),
        );
      case CurrentTabsEnum.supplier:
        return const Center(
          child: Icon(
            CustomIcons.seller,
          ),
        );
    }
  }
}
