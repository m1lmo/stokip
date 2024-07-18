import 'package:flutter/material.dart';
import 'package:stokip/feature/view/tabs/dashboard_view.dart';
import 'package:stokip/feature/view/tabs/products/products_view.dart';
import 'package:stokip/feature/view/tabs/sales/sales_view.dart';
import 'package:stokip/feature/view/tabs/current/current_view.dart';
import 'package:stokip/product/constants/enums/tabs_enum.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/constants/custom_icon.dart';

/// This extension is used to for the tabs
extension TabsExtension on Tabs {
  /// This method is used to get the page for the tabs
  Widget getPage() {
    switch (this) {
      case Tabs.dashboard:
        return const DashBoard();
      case Tabs.sales:
        return const SalesView();

      case Tabs.suppliers:
        return const CurrentView();

      case Tabs.products:
        return const ProductsView();
    }
  }

  /// This method is used to get the tab title
  String tabTitle() {
    switch (this) {
      case Tabs.dashboard:
        return ProjectStrings.dashBoardAppBarTitle;

      case Tabs.sales:
        return ProjectStrings.salesAppBarTitle;

      case Tabs.suppliers:
        return ProjectStrings.currentAppBarTitle;

      case Tabs.products:
        return ProjectStrings.productsAppBarTitle;
    }
  }

  /// This method is used to get the icon data for the tabs
  IconData getIconData() {
    switch (this) {
      case Tabs.dashboard:
        return CustomIcons.home;
      case Tabs.sales:
        return CustomIcons.sales;
      case Tabs.suppliers:
        return Icons.person_4_rounded;
      case Tabs.products:
        return CustomIcons.product3;
    }
  }
}
