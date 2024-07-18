// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/product/cache/shared_manager.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/importer_hive_operation.dart';

import 'package:stokip/product/widgets/c_notify.dart';

part 'importer_state.dart';

/// The ImporterCubit class is a state management class that extends the Cubit class.
class ImporterCubit extends Cubit<ImporterState> {
  ImporterCubit() : super(ImporterState());

  final List<ImporterModel> importers = [];

  late final SharedManager sharedManager;

  final ImporterHiveOperation databaseOperation = ImporterHiveOperation();

  Future<void> get init async {
    try {
      await DatabaseHiveManager().start();
      await databaseOperation.start();
      sharedManager = await SharedManager.getInstance;
      readId();
      if (databaseOperation.box.isEmpty) return;
      importers
        ..addAll(databaseOperation.box.values)
        ..sort(
          (a, b) => a.id.compareTo(b.id),
        );
      updateTotalBalanceUSD();
      emit(state.copyWith(importers: importers, importerId: importers.last.id));
    } catch (e) {
      // databaseOperation.box.deleteAll()
      print(e);
    }
  }

  void get getImporters {
    if (importers.isEmpty) return;
    emit(state.copyWith(importers: importers));
  }

  void readId() {
    final result = sharedManager.readId('importerid');
    emit(state.copyWith(importerId: result));
  }

  Future<void> writeIdToCache() async {
    await sharedManager.writeId(state.importerId + 1, 'importerid');
    return emit(state.copyWith(importerId: state.importerId + 1));
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
    for (final abc in _getMonthlyPurchases(month)!) {
      purchasedByMonth += abc.totalAmount ?? 0;
    }
    return purchasedByMonth;
  }

  List<PurchasesModel>? _getMonthlyPurchases(int currentMonth) {
    final currentPurchase = state.importers?.expand((element) => element.purchases).toList();
    final currentMonthPurchases = currentPurchase?.where((element) => element.purchasedDate.month == currentMonth).toList();
    return currentMonthPurchases;
  }

  double updateMonthlyPurchasesAmount(int month) {
    var totalAmount = 0.0;
    if (_getMonthlyPurchases(month) == null) return totalAmount;
    for (final purchases in _getMonthlyPurchases(month)!) {
      totalAmount += purchases.totalAmount ?? 0;
    }
    return totalAmount;
  }

  double getPurchasesMeterByMonth(int month) {
    var purchasedMeterByMonth = 0.0;

    if (_getMonthlyPurchases(month) == null) return purchasedMeterByMonth;
    for (final abc in _getMonthlyPurchases(month)!) {
      purchasedMeterByMonth += abc.meter ?? 0;
    }
    return purchasedMeterByMonth;
  }

  double get allPurchases {
    var totalMeter = 0.0;
    if (state.importers == null) return totalMeter;
    for (final abc in state.importers!) {
      for (final purchases in abc.purchases) {
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

  // StockDetailModel addToStocksPurchaseDetail(int index, int stockIndex, String title, double meter) {
  //   final result = StockDetailModel(title: title, meter: meter,itemId:);
  //   return result;
  // }

  void addPaymentLogs(int index, double price) {
    final paymentModel = PaymentModel(price: price, payedTime: DateTime.now());
    importers[index].payments.add(paymentModel);
    databaseOperation.addOrUpdateItem(importers[index]);
    emit(state.copyWith(importers: List.from(importers)));
  }

  void updateTotalBalanceUSD() {
    final totalBalance = importers.fold<double>(0, (previusValue, element) {
      if (element.currency == CurrencyEnum.usd) return previusValue + (element.balance ?? 0);
      return previusValue;
    });
    // final totalBalance = importers.fold<double>(0, (previousValue, element) {
    //   if (element.currency == CurrencyEnum.usd) return previousValue + (element.balance ?? 0);
    //   return previousValue;
    // });
    return emit(state.copyWith(totalBalance: totalBalance));
  }

  void addImporter(BuildContext context, TickerProvider tickerProviderService, {required ImporterModel model}) {
    if (importers.isNotEmpty) {
      if (importers.where((element) => element.title?.toLowerCase() == model.title?.toLowerCase()).isNotEmpty) {
        return CNotify(
          title: 'Hata',
          message: 'Bu isimde bir müşteri zaten var',
        ).show();
      }
    }
    importers.add(model);
    writeIdToCache();
    databaseOperation.addOrUpdateItem(model);
    updateTotalBalanceUSD();
    emit(state.copyWith(importers: List.from(importers)));
  }

  void saveFileToLocale(XFile? file, int index) {
    if (file == null) return;
    importers[index].customerPhoto = File(file.path).readAsBytesSync();
    databaseOperation.addOrUpdateItem(importers[index]);
    emit(state.copyWith(importers: List.from(importers)));
  }
}
