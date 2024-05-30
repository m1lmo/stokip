import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../product/cache/shared_manager.dart';
import '../../../product/database/core/database_hive_manager.dart';
import '../../../product/database/operation/stock_hive_operation.dart';

import '../../model/stock_model.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit() : super(StockState(products: lists));

  static final List<StockModel>? lists = [];
  late final SharedManager sharedManager;
  final StockHiveOperation databaseOperation = StockHiveOperation();

  List<StockModel> get currentStocks => List<StockModel>.from(lists ?? []);

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await databaseOperation.start();
    sharedManager = await SharedManager.getInstance;

    if (databaseOperation.box.isNotEmpty) {
      lists?.addAll(databaseOperation.box.values);
    }
    getProduct();
  }

  Future<void> clearProducts() async {
    await databaseOperation.clear();
    lists?.clear();
    emit(state.copyWith(products: currentStocks));
  }

  void addOrUpdateDetailedStock(int index, StockDetailModel model) {
    List<StockModel> updatedProducts = List.from(state.products ?? []);
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

  void _updateTotalTotalMeter() {
    var result = 0.0;
    for (final totalStocks in lists ?? []) {
      if (totalStocks.totalMeter is num) {
        result += totalStocks.totalMeter as double? ?? 0;
      }
    }
    return emit(state.copyWith(totalMeter: result));
  }

  void updateAppBarTitle(String? text) {
    print(text);
    emit(state.copyWith(appBarTitle: text));
  }

  /// this is for update model meter variable
  void updateTotalMeter(int indexList) {
    var result = 0.0;

    for (final detailStock in lists?[indexList].stockDetailModel ?? []) {
      if (detailStock.meter is num) {
        result += detailStock.meter as double? ?? 0;
      }
    }

    lists?[indexList].totalMeter = result;
    emit(state.copyWith(products: currentStocks));
  }

  void removeProduct(int index) {
    databaseOperation.remove(lists![index]);

    lists?.removeAt(index);
    emit(state.copyWith(products: currentStocks));
  }

  void getProduct() {
    if (lists == null) return;
    print('asd');
    _updateTotalTotalMeter();
    emit(state.copyWith(products: lists));
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

  Future<void> addProduct(StockModel model, {int? id}) async {
    final indexOfSameProduct = lists?.indexWhere((element) => element.title?.toLowerCase() == model.title?.toLowerCase());
    if (indexOfSameProduct != -1 && indexOfSameProduct != null) {
      lists?[indexOfSameProduct].totalMeter = lists?[indexOfSameProduct].totalMeter ?? 0 + (model.totalMeter ?? 0);
      updateTotalMeter(lists!.indexOf(lists![indexOfSameProduct]));
      await databaseOperation.addOrUpdateItem(lists![indexOfSameProduct]);
    } else {
      emit(state.copyWith(productId: id! + 1));
      writeIdToCache((state.productId));
      lists?.add(model);
      updateTotalMeter(lists!.indexOf(lists!.last));
      await databaseOperation.addOrUpdateItem(model);
    }

    emit(state.copyWith(productId: state.productId, products: List.from(currentStocks)));
    _updateTotalTotalMeter();
  }
}
