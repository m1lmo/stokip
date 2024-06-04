import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    }
    getProduct();
  }

  Future<void> clearProducts() async {
    await databaseOperation.clear();
    lists.clear();
    emit(state.copyWith(products: currentStocks));
  }

  void addOrUpdateDetailedStock(int index, StockDetailModel model) {
    final updatedProducts = List<StockModel>.from(state.products ?? []);
    final sameStockIndex = updatedProducts[index].stockDetailModel.indexWhere((element) => element.title?.toLowerCase() == model.title?.toLowerCase());
    // final isStockOld = updatedProducts[index].stockDetailModel?.where((element) => element.title == model.title);
    if (sameStockIndex != -1) {
      updatedProducts[index].stockDetailModel[sameStockIndex].meter = (updatedProducts[index].stockDetailModel[sameStockIndex].meter ?? 0) + (model.meter ?? 0);
    } else {
      updatedProducts[index].stockDetailModel.add(model);
    }
    updateTotalMeter(index);
    _updateTotalTotalMeter();
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

  void updateAppBarTitle(String? text) {
    print(text);
    emit(state.copyWith(appBarTitle: text));
  }

  /// this method for update total meter in stock detail model
  void updateTotalMeter(int indexList) {
    var result = 0.0;

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
    print('asd');
    _updateTotalTotalMeter();
    emit(state.copyWith(products: lists));
    updateRunnigOutStock;
    getRunningOutStock;
    totalAmountOfMoney;
  }

  void readId() {
    final result = sharedManager.readId('stockid');
    print('result $result');
    return emit(state.copyWith(productId: result));
  }

  Future<void> writeIdToCache(
    int? id,
  ) async {
    await sharedManager.writeId(id ?? 0, 'stockid');
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
      await writeIdToCache(state.productId);
      lists.add(model);
      updateTotalMeter(lists.indexOf(lists.last));
      await databaseOperation.addOrUpdateItem(model);
    }
    emit(state.copyWith(products: List.from(currentStocks)));
    _updateTotalTotalMeter();
  }

  void get updateRunnigOutStock {
    if (state.runningOutStock == null) {
      emit(state.copyWith(runningOutStock: lists.first));
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
}
