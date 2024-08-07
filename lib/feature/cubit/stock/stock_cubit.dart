import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/service/repository/stock_repository.dart';
import 'package:stokip/product/cache/storage_manager.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/stock_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';
import 'package:stokip/test_global.dart' as globals;

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit() : super(StockState(products: lists));

  static final List<StockModel> lists = [];
  final secureStorage = StorageManager.instance();
  final StockHiveOperation databaseOperation = StockHiveOperation();
  final dioHelper = DioHelper.instance();
  late final StockRepository stockRepository;

  List<StockModel> get currentStocks => List<StockModel>.from(lists);
  Future<void> get init async {
    await DatabaseHiveManager().start();
    await databaseOperation.start();
    stockRepository = StockRepository(dioHelper.dio);
    if (databaseOperation.box.isNotEmpty && !globals.globalInternetConnection) {
      lists.addAll(databaseOperation.box.values);
      emit(state.copyWith(products: currentStocks));
    } else {
      final data = await stockRepository.fetchData();
      if (data == null) return;
      for (final item in data) {
        if (item == null) continue;
        lists.add(item);
        updateTotalMeter(stock: item);
        // await databaseOperation.addOrUpdateItem(item);
      }
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
    stockRepository.postData(updatedProducts[index]);
    if (sameStockIndex != -1) {
      updatedProducts[index].stockDetailModel[sameStockIndex].meter = (updatedProducts[index].stockDetailModel[sameStockIndex].meter ?? 0) + (model.meter ?? 0);
    } else {
      final copyModel = model.copyWith(itemDetailId: updatedProducts[index].stockDetailModel.length + 1);

      updatedProducts[index].stockDetailModel.add(copyModel);
      // emit(state.copyWith(productDetailId: state.productDetailId + 1));
    }
    updateTotalMeter(stock: updatedProducts[index]);
    _updateTotalTotalMeter();
    databaseOperation.addOrUpdateItem(updatedProducts[index]);
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
  void updateTotalMeter({StockModel? stock, int? itemId}) {
    var result = 0.0;
    if (stock == null) {
      final indexList = lists.indexWhere((element) => element.id == itemId);
      for (final detailStock in lists[indexList].stockDetailModel) {
        if (detailStock.meter is num) {
          result += detailStock.meter ?? 0;
        }
      }
      lists[indexList].totalMeter = result;
      emit(state.copyWith(products: currentStocks));
    } else {
      for (final detailStock in stock.stockDetailModel) {
        if (detailStock.meter is num) {
          result += detailStock.meter ?? 0;
        }
      }
      stock.totalMeter = result;
      emit(state.copyWith(products: currentStocks));
    }
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

  /// this is for add product to list and update total meter
  Future<void> addProduct(
    StockModel model,
  ) async {
    final copyModel = model.copyWith(id: lists.length + 1);
    final indexOfSameProduct = lists.indexWhere((element) => element.title?.toLowerCase() == model.title?.toLowerCase());
    stockRepository.postData(copyModel); // todo
    if (indexOfSameProduct != -1) {
      lists[indexOfSameProduct].totalMeter = lists[indexOfSameProduct].totalMeter ?? 0 + (model.totalMeter ?? 0);
      updateTotalMeter(stock: lists[indexOfSameProduct]);
      await databaseOperation.addOrUpdateItem(lists[indexOfSameProduct]);
    } else {
      // emit(state.copyWith(productId: state.productId + 1));
      lists.add(copyModel);
      updateTotalMeter(stock: lists.last);
      await databaseOperation.addOrUpdateItem(copyModel);
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
      if ((stock.totalMeter ?? 0) < (state.runningOutStock!.totalMeter!) && stock.totalMeter! > 0) {
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
