import 'package:flutter/material.dart';
import 'package:stokip/feature/view/tabs/dashboard_view.dart';
import 'package:stokip/feature/view/tabs/products_view.dart';
import 'package:stokip/feature/view/tabs/sales_view.dart';
import 'package:stokip/feature/view/tabs/suppliers_view.dart';
import 'package:stokip/product/constants/project_strings.dart';

enum Tabs { dashboard, sales, suppliers, products }

extension TabsExtension on Tabs {
  Widget getPage() {
    switch (this) {
      case Tabs.dashboard:
        return const DashBoard();
      case Tabs.sales:
        return const SalesView();

      case Tabs.suppliers:
        return const SuppliersView();

      case Tabs.products:
        return const ProductsView();
    }
  }

  String tabTitle() {
    switch (this) {
      case Tabs.dashboard:
        return ProjectStrings.dashBoardAppBarTitle;
      case Tabs.sales:
        return ProjectStrings.salesAppBarTitle;

      case Tabs.suppliers:
        return ProjectStrings.suppliersAppBarTitle;

      case Tabs.products:
        return ProjectStrings.productsAppBarTitle;
    }
  }
}
