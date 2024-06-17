// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:stokip/feature/localization/locale_keys.g.dart';
import 'package:stokip/product/extensions/string_extension.dart';

class ProjectStrings {
  ProjectStrings._();
  static String pickItem = LocaleKeys.common_pickItem.locale();
  static String pickDetailItem = LocaleKeys.common_pickDetailItem.locale();
  static String oldLogs = LocaleKeys.common_oldLogs.locale();
  static String meter = LocaleKeys.common_meter.locale();
  static String pay = LocaleKeys.common_pay.locale();
  static String search = 'Ara';

  static String productsAppBarTitle = LocaleKeys.products_appBarTitle.locale();
  static String productsTotal = LocaleKeys.products_total.locale();

  static String stockTotal = LocaleKeys.stocks_total.locale();

  static String salesPriceHint = LocaleKeys.sales_priceHint.locale();
  static String salesAppBarTitle = LocaleKeys.sales_appBarTitle.locale();
  static String salesCustomerLabelTitle = 'Müşteri';
  static String salesStockLabelTitle = 'Ürün';
  static String salesStockDetailLabelTitle = 'Renk';

  static String dashBoardAppBarTitle = LocaleKeys.dashboard_appBarTitle.locale();
  static String dashboardMonthlyGraph = LocaleKeys.dashboard_monthlyGraph.locale();

  static String currentAppBarTitle = LocaleKeys.current_appBarTitle.locale();

  static String suppliersAppBarTitle = LocaleKeys.suppliers_appBarTitle.locale();
  static String suppliersNameHint = LocaleKeys.suppliers_nameHint.locale();
  static String suppliersPurchases = LocaleKeys.suppliers_purchases.locale();
  static String suppliersPayments = LocaleKeys.suppliers_payments.locale();
  static String suppliersPaymentSuccess = LocaleKeys.suppliers_paymentSuccess.locale();
  static String suppliersPayAlertTitle = LocaleKeys.suppliers_payAlertTitle.locale();
  static String suppliersCompletePayment = LocaleKeys.suppliers_completePayment.locale();
  static String suppliersDenyPayment = LocaleKeys.suppliers_denyPayment.locale();
  static String suppliersHintItem = LocaleKeys.suppliers_hintItem.locale();
  static String suppliersHintDetailItem = LocaleKeys.suppliers_hintDetailItem.locale();
  static String suppliersHintQuantityMeter = LocaleKeys.suppliers_hintQuantityMeter.locale();
  static String suppliersHintPurchasePrice = LocaleKeys.suppliers_hintPurchasePrice.locale();
}
