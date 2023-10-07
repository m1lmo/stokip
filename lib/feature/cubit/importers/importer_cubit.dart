// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/importer_hive_operation.dart';

import '../../model/stock_model.dart';

part 'importer_state.dart';

/// The ImporterCubit class is a state management class that extends the Cubit class.
class ImporterCubit extends Cubit<ImporterState> {
  /// The line `ImporterCubit() : super(ImporterState());` is the constructor of the `ImporterCubit`
  /// class. It calls the constructor of the superclass `Cubit` and passes an instance of
  /// `ImporterState` as the initial state of the `ImporterCubit`. This sets the initial state of the
  /// `ImporterCubit` to an instance of `ImporterState`.
  ImporterCubit() : super(ImporterState());

  /// The line `static final List<ImporterModel> importers = [];` is declaring a static final list
  /// variable named `importers` of type `ImporterModel`. This list will store instances of the
  /// `ImporterModel` class. The `static` keyword means that the variable belongs to the class itself,
  /// rather than an instance of the class. The `final` keyword means that the variable cannot be
  /// reassigned once it is initialized. In this case, the list is initialized as an empty list.
  static final List<ImporterModel> importers = [];

  /// The line `static final List<PurchasesModel> purchases = [];` is declaring a static final list
  /// variable named `purchases` of type `PurchasesModel`. This list will store instances of the
  /// `PurchasesModel` class.  static final List<PurchasesModel> purchases = [];

  /// The line `late final SharedManager sharedManager;` is declaring a late final variable named
  /// `sharedManager` of type `SharedManager`.

  /// The line `final ImporterHiveOperation databaseOperation = ImporterHiveOperation();` is creating an
  /// instance of the `ImporterHiveOperation` class and assigning it to the variable
  /// `databaseOperation`. This instance will be used to perform operations related to the importers
  /// data in the Hive database.
  final ImporterHiveOperation databaseOperation = ImporterHiveOperation();

  /// The `init` method is an asynchronous method that is used to initialize the databaseOperations init on ImporterCubit.
  /// It is marked with the `async` keyword, which means it can perform asynchronous operations. The
  /// method returns a `Future<void>`, indicating that it does not return a value.
  /// u should start this at homeview otherwise cache wont work
  Future<void> get init async {
    try {
      await DatabaseHiveManager().start();
      await databaseOperation.start();
      if (databaseOperation.box.isEmpty) return;
      importers
        ..addAll(databaseOperation.box.values)
        ..sort(
          (a, b) => a.id.compareTo(b.id),
        );
      emit(state.copyWith(importers: importers));
      emit(state.copyWith(importerId: importers.last.id));
    } catch (e) {
      print(e);
    }
  }

  void get getImporters {
    if (importers.isEmpty) return;
    emit(state.copyWith(importers: importers));
  }

  void updateSelectedCurrency(CurrencyEnum newCurrency) {
    emit(state.copyWith(selectedCurrency: newCurrency));
  }

  // void addOrUpdatePurchase(int index, PurchasesModel model) {
  //   List<ImporterModel>? updatedPurchase = List.from(state.importers ?? []);
  //   updatedPurchase[index].purchases.add(model);
  //   print(updatedPurchase[index]);
  //   databaseOperation.addOrUpdateItem(updatedPurchase[index]);
  //   emit(state.copyWith(importers: updatedPurchase));
  // }

  Text getPurchasedDate(int index, int indexOfPurchases) {
    final reversedPurchaseDate = state.importers?[index].purchases.reversed.toList();
    final times = reversedPurchaseDate?[indexOfPurchases].purchasedDate;
    return Text('${times?.day} ${times?.month} ${times?.year}');
  }

  double getPurchaseByMonth(int month) {
    var purchasedByMonth = 0.0;
    if (_getMonthlyPurchases(month) == null) return purchasedByMonth;
    for (var abc in _getMonthlyPurchases(month)!) {
      purchasedByMonth += abc.totalAmount ?? 0;
    }
    return purchasedByMonth;
  }

  List<PurchasesModel>? _getMonthlyPurchases(int currentMonth) {
    final _currentPurchase = state.importers?.expand((element) => element.purchases).toList();
    final currentMonthPurchases =
        _currentPurchase?.where((element) => element.purchasedDate.month == currentMonth).toList();
    return currentMonthPurchases;
  }

  double updateMonthlyPurchasesAmount(int month) {
    var totalAmount = 0.0;
    if (_getMonthlyPurchases(month) == null) return totalAmount;
    for (var purchases in _getMonthlyPurchases(month)!) {
      totalAmount += purchases.totalAmount ?? 0;
    }
    return totalAmount;
  }

  double getPurchasesMeterByMonth(int month) {
    var purchasedMeterByMonth = 0.0;

    if (_getMonthlyPurchases(month) == null) return purchasedMeterByMonth;
    for (var abc in _getMonthlyPurchases(month)!) {
      purchasedMeterByMonth += abc.meter ?? 0;
    }
    return purchasedMeterByMonth;
  }

  double get allPurchases {
    double totalMeter = 0.0;
    if (state.importers == null) return totalMeter;
    for (var abc in state.importers!) {
      for (var purchases in abc.purchases) {
        totalMeter += purchases.meter ?? 0;
      }
    }
    return totalMeter;
  }

  /// The function adds purchase logs with specified details to a list.
  ///
  /// Args:
  ///   index (int): The index parameter is an integer that represents the position at which the
  /// purchase log will be added in a list or array.
  ///   title (String): The title parameter is a String that represents the title of the purchase log.
  ///   detailTitle (String): The `detailTitle` parameter is a string that represents the title or
  /// description of the purchase log.
  ///   meter (double): The "meter" parameter is a double value that represents the quantity or amount
  /// of the purchase. It could be the number of items purchased, the length of a material purchased, or
  /// any other unit of measurement relevant to the purchase.
  ///   price (double): The price parameter is a double data type, which means it can store decimal
  /// numbers. It represents the price of the purchase.
  void addPurchaseLogs(int index, String title, String detailTitle, double meter, double price) {
    final totalAmount = meter * price;
    final displayResult = PurchasesModel(
      id: state.salesId,
      purchasedDate: DateTime.now(),
      title: title,
      detailTitle: detailTitle,
      meter: meter,
      totalAmount: totalAmount,
    );
    importers[index].purchases.add(displayResult);
    updateBalance(index, totalAmount);
    databaseOperation.addOrUpdateItem(importers[index]);
    emit(state.copyWith(importers: List.from(importers)));
  }

  void updateBalance(int index, double totalAmount) {
    importers[index].balance = (importers[index].balance ?? 0) + totalAmount;
    emit(state.copyWith(importers: List.from(importers)));
  }

  void paymentToIndexedSupplier(int index, double payment) {
    importers[index].balance = (importers[index].balance ?? 0) - payment;
    emit(state.copyWith(importers: List.from(importers)));
  }

  /// The `addToStocksPurchaseDetail` method is a helper method in the `ImporterCubit` class. It is
  /// used to create a `StockDetailModel` object based on the provided parameters.

  StockDetailModel addToStocksPurchaseDetail(
      int index, int stockIndex, String title, double meter) {
    final result = StockDetailModel(title: title, meter: meter);
    return result;
  }

  void addPaymentLogs(int index, double price) {
    final paymentModel = PaymentModel(price: price, payedTime: DateTime.now());
    importers[index].payments.add(paymentModel);
    databaseOperation.addOrUpdateItem(importers[index]);
    emit(state.copyWith(importers: List.from(importers)));
  }

  /// The function performs an add or update operation with the given id, title, and currency.
  ///
  /// Args:
  ///   id (int): The id parameter is an integer that represents the unique identifier for the item
  /// being added or updated.
  ///   title (String): The title parameter is a String that represents the title of the item being
  /// added or updated.
  ///   currency (CurrencyEnum): The currency parameter is of type CurrencyEnum, which is an enumeration
  /// representing different currencies.
  void performAddOrUpdate(int id, String title, CurrencyEnum currency) {
    emit(state.copyWith(importerId: id + 1));
    final importerModel = ImporterModel(
        id: state.importerId, title: title, currency: currency, purchases: [], payments: []);
    importers.add(importerModel);
    databaseOperation.addOrUpdateItem(importerModel);
    emit(state.copyWith(importers: List.from(importers)));
  }

  /// The function adds or updates an item in a list with the given id, title, and currency.
  ///
  /// Args:
  ///   id (int): The unique identifier for the item in the list.
  ///   title (String): The title parameter is a string that represents the title of an item.
  ///   currency (CurrencyEnum): The currency parameter is of type CurrencyEnum, which is an enumeration
  /// representing different currencies.
  void addOrUpdateToList(int id, String title, CurrencyEnum currency) {
    performAddOrUpdate(id, title, currency);

    emit(state.copyWith(importers: List.from(importers)));
  }

  /// The function saves a file to the local storage.
  ///
  /// Args:
  ///   file (XFile): The `file` parameter is of type `XFile?`, which means it can either be `null` or
  /// an instance of the `XFile` class.
  ///   index (int): The index parameter is an integer that represents the position or order of the file
  /// being saved. It is used to determine where the file should be saved in the local storage.
  void saveFileToLocale(XFile? file, int index) {
    if (file == null) return;
    importers[index].customerPhoto = File(file.path).readAsBytesSync();
    databaseOperation.addOrUpdateItem(importers[index]);
    emit(state.copyWith(importers: List.from(importers)));
  }
}
