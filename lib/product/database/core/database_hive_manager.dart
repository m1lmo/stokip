import 'package:hive_flutter/hive_flutter.dart';
import 'package:stokip/feature/model/customer_model.dart';

import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';

abstract class IDataBaseManager {
  Future<void> start();
  Future<void> _open();
  void _initialDataBase();
}

final class DatabaseHiveManager extends IDataBaseManager {
  @override
  Future<void> start() async {
    try {
      await _open();
      _initialDataBase();
    } catch (e) {
      print(e);
    }
  }

  /// now open your database connection
  /// you can use noe [hive]
  @override
  Future<void> _open() => Hive.initFlutter();

  /// registeration of Your model here must before start
  @override
  void _initialDataBase() {
    if (Hive.isAdapterRegistered(HiveTypes.stockModelId)) return;
    Hive.registerAdapter(StockModelAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.stockDetailModelId)) return;
    Hive.registerAdapter(StockDetailModelAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.salesModelId)) return;
    Hive.registerAdapter(SalesModelAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.importerModelId)) return;
    Hive.registerAdapter(ImporterModelAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.currencyEnumId)) return;
    Hive.registerAdapter(CurrencyEnumAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.purchasesModelId)) return;
    Hive.registerAdapter(PurchasesModelAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.paymentModelId)) return;
    Hive.registerAdapter(PaymentModelAdapter());
    if (Hive.isAdapterRegistered(HiveTypes.customerModelId)) return;
    Hive.registerAdapter(CustomerModelAdapter());
  }
}
