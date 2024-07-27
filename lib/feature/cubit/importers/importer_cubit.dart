// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/feature/service/repository/importer_repository.dart';
import 'package:stokip/product/cache/storage_manager.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/importer_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';
import 'package:stokip/test_global.dart' as globals;

import 'package:stokip/product/widgets/c_notify.dart';

part 'importer_state.dart';

/// The ImporterCubit class is a state management class that extends the Cubit class.
class ImporterCubit extends Cubit<ImporterState> {
  ImporterCubit() : super(ImporterState());

  final List<ImporterModel> importers = [];
  final ImporterHiveOperation databaseOperation = ImporterHiveOperation();
  final DioHelper dioHelper = DioHelper.instance();
  late final ImporterRepository importerRepository;
  final secureStorage = StorageManager.instance();

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await databaseOperation.start();
    importerRepository = ImporterRepository(dioHelper.dio);
    if (!globals.globalInternetConnection && databaseOperation.box.isNotEmpty) {
      importers.addAll(databaseOperation.box.values);
      updateTotalBalanceUSD();
      emit(state.copyWith(importers: importers));
      return;
    } else {
      final data = await importerRepository.fetchData();
      if (data == null) return;
      for (final item in data) {
        if (item == null) continue;
        importers.add(item);
        updateTotalBalanceUSD();
        await databaseOperation.addOrUpdateItem(item);
      }
    }
    updateTotalBalanceUSD();
    emit(state.copyWith(importers: importers));
    // databaseOperation.box.deleteAll()
  }

  void get getImporters {
    if (importers.isEmpty) return;
    emit(state.copyWith(importers: importers));
  }

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

  void updateBalance(ImporterModel importer) {
    databaseOperation.addOrUpdateItem(importer);
    emit(state.copyWith(importers: List.from(importers)));
  }

  void updateTotalBalanceUSD() {
    final totalBalance = importers.fold<double>(0, (previusValue, element) {
      if (element.currency == CurrencyEnum.usd) return previusValue + (element.balance ?? 0);
      return previusValue;
    });
    return emit(state.copyWith(totalBalance: totalBalance));
  }

  Future<void> addImporter(BuildContext context, TickerProvider tickerProviderService, {required ImporterModel model}) async {
    final copyModel = model.copyWith(id: importers.length + 1);
    if (importers.isNotEmpty) {
      if (importers.where((element) => element.title?.toLowerCase() == copyModel.title?.toLowerCase()).isNotEmpty) {
        return CNotify(
          title: 'Hata',
          message: 'Bu isimde bir müşteri zaten var',
        ).show();
      }
    }
    final result = await importerRepository.postData(copyModel);
    if (!result) return;
    importers.add(copyModel);
    await databaseOperation.addOrUpdateItem(copyModel);
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
