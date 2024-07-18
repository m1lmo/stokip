import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/product/cache/shared_manager.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/stock_hive_operation.dart';

import 'package:stokip/feature/model/stock_model.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit() : super(StockState(products: lists));

  static final List<StockModel> lists = [];
  late final SharedManager sharedManager;
  final StockHiveOperation databaseOperation = StockHiveOperation();

  List<StockModel> get currentStocks => List<StockModel>.from(lists);

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await databaseOperation.start();
    sharedManager = await SharedManager.getInstance;
    if (databaseOperation.box.isNotEmpty) {
      lists.addAll(databaseOperation.box.values);
      emit(state.copyWith(products: currentStocks));
    }
    getProduct();
  }

  Future<void> clearProducts() async {
    await databaseOperation.clear();
    lists.clear();
    emit(state.copyWith(products: currentStocks));
  }

  void addOrUpdateDetailedStock(StockDetailModel model) {
    final index = state.products?.indexWhere((element) => element.id == model.itemId);
    if (index == null) return;
    final updatedProducts = List<StockModel>.from(state.products ?? []);
    final sameStockIndex = updatedProducts[index].stockDetailModel.indexWhere((element) => element.title?.toLowerCase() == model.title?.toLowerCase());
    // final isStockOld = updatedProducts[index].stockDetailModel?.where((element) => element.title == model.title);
    if (sameStockIndex != -1) {
      updatedProducts[index].stockDetailModel[sameStockIndex].meter = (updatedProducts[index].stockDetailModel[sameStockIndex].meter ?? 0) + (model.meter ?? 0);
    } else {
      updatedProducts[index].stockDetailModel.add(model);
      emit(state.copyWith(productDetailId: state.productDetailId + 1));
    }
    updateTotalMeter(index);
    _updateTotalTotalMeter();
    writeIdToCache(state.productDetailId, 'stockdetailid');
    databaseOperation.addOrUpdateItem(updatedProducts[index]); //todo bunu methoda çıkar
    emit(state.copyWith(products: updatedProducts));
  }

  /// this method for update total meter in stock model
  void _updateTotalTotalMeter() {
    var result = 0.0;
    for (final totalStocks in lists) {
      if (totalStocks.totalMeter is num) {
        result += totalStocks.totalMeter ?? 0;
      }
    }
    return emit(state.copyWith(totalMeter: result));
  }

  /// this method for update total meter in stock detail model
  void updateTotalMeter(int itemId) {
    var result = 0.0;
    final indexList = lists.indexWhere((element) => element.id == itemId);
    for (final detailStock in lists[indexList].stockDetailModel) {
      if (detailStock.meter is num) {
        result += detailStock.meter ?? 0;
      }
    }
    lists[indexList].totalMeter = result;
    emit(state.copyWith(products: currentStocks));
  }

  void removeProduct(int index) {
    databaseOperation.remove(lists[index]);

    lists.removeAt(index);
    emit(state.copyWith(products: currentStocks));
  }

  void getProduct() {
    _updateTotalTotalMeter();
    emit(state.copyWith(products: lists));
    updateRunnigOutStock;
    getRunningOutStock;
    totalAmountOfMoney;
    updateRunningOutStockDetail;
  }

  void readId() {
    final result = sharedManager.readId('stockid');
    final result2 = sharedManager.readId('stockdetailid');
    return emit(state.copyWith(productId: result, productDetailId: result2));
  }

  Future<void> writeIdToCache(
    int? id,
    String key,
  ) async {
    await sharedManager.writeId(id ?? 0, key);
  }

  /// this is for add product to list and update total meter
  Future<void> addProduct(
    StockModel model,
  ) async {
    final indexOfSameProduct = lists.indexWhere((element) => element.title?.toLowerCase() == model.title?.toLowerCase());
    if (indexOfSameProduct != -1) {
      lists[indexOfSameProduct].totalMeter = lists[indexOfSameProduct].totalMeter ?? 0 + (model.totalMeter ?? 0);
      updateTotalMeter(lists.indexOf(lists[indexOfSameProduct]));
      await databaseOperation.addOrUpdateItem(lists[indexOfSameProduct]);
    } else {
      emit(state.copyWith(productId: state.productId + 1));
      await writeIdToCache(state.productId, 'stockid');
      lists.add(model);
      updateTotalMeter(lists.indexOf(lists.last));
      await databaseOperation.addOrUpdateItem(model);
    }
    emit(state.copyWith(products: List.from(currentStocks)));
    _updateTotalTotalMeter();
  }

  void get updateRunnigOutStock {
    if (state.runningOutStock == null) {
      if (lists.isEmpty) return;
      emit(state.copyWith(runningOutStock: lists.first));
    }
  }

  void get updateRunningOutStockDetail {
    if (state.runningOutStockDetail == null) {
      emit(state.copyWith(runningOutStockDetail: state.runningOutStock?.stockDetailModel.first));
    }
  }

  void get totalAmountOfMoney {
    var result = 0.0;
    for (final stock in lists) {
      if (stock.pPrice is double) {
        result += stock.pPrice! * (stock.totalMeter ?? 0);
      }
    }
    emit(state.copyWith(totalAmount: result));
  }

  void get getRunningOutStock {
    for (final stock in lists) {
      if (stock.totalMeter! < (state.runningOutStock!.totalMeter!) && stock.totalMeter! > 0) {
        emit(state.copyWith(runningOutStock: stock));
      }
    }
  }

  void getRunningOutStockDetail(int stockId) {
    final index = lists.indexWhere((element) => element.id == stockId);
    if (lists[index].stockDetailModel.isEmpty) {
      return emit(state.copyWith(runningOutStockDetail: StockDetailModel(itemDetailId: -1, itemId: -1)));
    }
    emit(state.copyWith(runningOutStockDetail: lists[index].stockDetailModel.first));
    for (final stockDetail in lists[index].stockDetailModel) {
      if (stockDetail.meter! < (state.runningOutStockDetail!.meter!) && stockDetail.meter! > 0) {
        emit(state.copyWith(runningOutStockDetail: stockDetail));
      } else {}
    }
  }

  void updateTrendStock(List<SalesModel>? sales, StockModel stock) {
    var mostSaled = <SalesModel>[];
    if (sales == null) return;
    final salesForStockId = sales.where((element) => element.stockDetailModel?.itemId == stock.id).toList();
    for (final sale in salesForStockId) {
      final sale2 = salesForStockId.where((element) => element.stockDetailModel?.itemDetailId == sale.stockDetailModel?.itemDetailId).toList();
      if (sale2.length > mostSaled.length) {
        mostSaled = List.from(sale2);
      }
      // print(allSalesSpecified.length);
    }
    if (mostSaled.isEmpty) return emit(state.copyWith(trendStockDetail: StockDetailModel(itemDetailId: -1, itemId: -1)));
    emit(state.copyWith(trendStockDetail: mostSaled.first.stockDetailModel));
  }

  int? getTotalSale(List<SalesModel>? sales, StockDetailModel stockDetailModel) {
    if (sales == null) return null;
    final salesForStockId = sales.where((element) => element.stockDetailModel?.itemId == stockDetailModel.itemId).toList();
    final salesForStockDetailId = salesForStockId.where((element) => element.stockDetailModel?.itemDetailId == stockDetailModel.itemDetailId).toList();

    return salesForStockDetailId.length;
  }
}
