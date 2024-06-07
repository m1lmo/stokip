// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';

import 'package:stokip/product/database/operation/stock_hive_operation.dart';

import 'package:stokip/product/cache/shared_manager.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/sales_hive_operation.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';

part 'sales_state.dart';

// enum StockStatus{
//   OutOfStock,
//   ZeroStock,
//   InStock
// }
// mixin StockStatusMixin{
//   Future<dynamic> display(BuildContext context){
//     switch (this) {
//       case StockStatus.OutOfStock:
//       return showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           child: Text('Stok Yetersiz'),
//         );
//       },
//     );
//     case StockStatus.ZeroStock:
//     return

//     }
//   }
// }

//   StockStatus isOutOfStock(StockDetailModel model, double? sold) {
//      final remainingStock =  model.meter! - (sold ?? 0) ;
//    if (remainingStock < 0) {
//     return StockStatus.OutOfStock;
//   } else if (remainingStock == 0) {
//     return StockStatus.ZeroStock;
//   } else {
//     return StockStatus.InStock;
//   }
// }

class SalesCubit extends Cubit<SalesState> {
  SalesCubit({
    this.stockDatabaseOperation,
    this.stocks,
  }) : super(SalesState());
  SalesCubit.s({
    this.stockDatabaseOperation,
    this.stocks,
  }) : super(
          SalesState(
            sales: saless,
          ),
        );

  late final StockHiveOperation? stockDatabaseOperation;
  late final List<StockModel>? stocks;
  static final List<SalesModel> saless = [];
  late final SharedManager sharedManager;
  final SaleHiveOperation saleDatabaseOperation = SaleHiveOperation();
  List<SalesModel> get currentSales => List<SalesModel>.from(saless);

  int? get selectedSoldItemIndex => stocks!.indexWhere((element) => element.title == state.selectedItemOnSales);
  //initFor provider.value

  Future<void> get init async {
    try {
      await DatabaseHiveManager().start();
      await saleDatabaseOperation.start();
      sharedManager = await SharedManager.getInstance;

      if (saleDatabaseOperation.box.isNotEmpty) {
        saless.addAll(saleDatabaseOperation.box.values);
      }
      getSales();
    } catch (e) {
      print(e);
    }
  }

  List<SalesModel>? _monthlySales(int currentMonth) {
    return state.sales?.where((sale) {
      return sale.dateTime.month == currentMonth;
    }).toList();
  }

  void readId() {
    final result = sharedManager.readId('salesid');
    emit(state.copyWith(salesId: result ?? 0));
  }

  Future<void> writeIdToCache(int? id) async {
    await sharedManager.writeId(id ?? 0, 'salesid');
  }

  Text getSoldTime(int index) {
    final reversedSales = state.sales?.reversed.toList();
    final times = reversedSales?[index].dateTime;
    return Text('${times?.day} ${times?.month} ${times?.year}');
  }

  List<SalesModel>? getSalesByMonth(int month) {
    final reversedCurrentMonthSales = _monthlySales(month)?.reversed.toList();
    return reversedCurrentMonthSales;
  }

  double getTotalSoldMeterByMonth(int month) {
    var totalMeter = 0.0;
    if (_monthlySales(month) == null) return totalMeter;
    for (final sales in _monthlySales(month)!) {
      totalMeter += sales.quantity ?? 0;
    }
    return totalMeter;
  }

  double updateMonthlySalesAmount(int month) {
    var amount = 0.0;
    if (_monthlySales(month) == null) return amount;
    for (final sales in _monthlySales(month)!) {
      var currentAmount = sales.price ?? 0;
      currentAmount *= sales.quantity ?? 0;
      amount += currentAmount;
    }
    return amount;
  }

  void updateSelectedItem(String newText) {
    emit(state.copyWith(selectedItemOnSales: newText));
  }

  void updateSelectedSpecificItem(String specItem) {
    emit(state.copyWith(selectedSpecific: specItem));
  }

  void updateCurrency(CurrencyEnum currency) {
    emit(state.copyWith(currency: currency));
  }

  void getSales() {
    if (saless.isEmpty) return;
    getTotalIncome;
    return emit(state.copyWith(sales: saless));
  }

  void addSale({
    required SalesModel model,
  }) {
    if ((model.stockDetailModel?.meter ?? 0) == 0) return; //TODO SHOW NOTIFY
    _updateStocks(model);
    saleDatabaseOperation.addOrUpdateItem(model);
    writeIdToCache(state.salesId + 1);

    saless.add(model);
    emit(state.copyWith(sales: currentSales));
  }

  void _updateStocks(SalesModel model) {
    if (stocks == null) return;
    for (final stock in stocks!) {
      if (stock.id != model.stockDetailModel?.itemId) continue;
      for (final detail in stock.stockDetailModel) {
        if (detail.itemDetailId != model.stockDetailModel?.itemDetailId) continue;
        detail.meter = detail.meter! - model.quantity!;
      }
    }
  }
  // void _addSaleLogs(SalesModel model, int currentId) {
  //   saleDatabaseOperation.addOrUpdateItem(model);
  //   saless.add(model);
  //   emit(state.copyWith(sales: currentSales, salesId: currentId));
  // }

  // bool _isOutOfStock(StockDetailModel model, double? sold) {
  //   return model.meter! - (sold ?? 0) < 0 ? true : false;
  // }

  // int? _findIndexForColor(int index, String? color) {
  //   return stocks?[index].stockDetailModel.indexWhere((element) => element.title == color) ?? 0;
  // }

  // StockDetailModel? getStockAtIndex(int index, int indexOfDetail) {
  //   return stocks?[index].stockDetailModel.elementAt(indexOfDetail);
  // }

  // void _performSale(int index, String? color, double solded, int id, double amount, CurrencyEnum currency) {
  //   emit(state.copyWith(salesId: id + 1));
  //   final salesModel = SalesModel(id: state.salesId, dateTime: DateTime.now(), title: '${state.selectedItemOnSales} $color', meter: solded, price: amount, currency: currency);
  //   _addSaleLogs(salesModel, state.salesId);
  //   final indexOfStock = getStockAtIndex(index, _findIndexForColor(index, color) ?? 0);

  //   if (indexOfStock != null) {
  //     indexOfStock.meter = indexOfStock.meter! - solded;
  //     stockDatabaseOperation?.addOrUpdateItem(stocks![index]);
  //   }
  // }
  // void sold(int index, String? color, double solded, BuildContext context, double price, CurrencyEnum currency) {
  //   final indexMatchedColor = _findIndexForColor(index, color);
  //   if (indexMatchedColor == null) return;
  //   final indexOfStockDetail = getStockAtIndex(index, indexMatchedColor);
  //   if (indexOfStockDetail == null) return;
  //   if (_isOutOfStock(indexOfStockDetail, solded)) {
  //     showOutOfDialog(context);
  //     return;
  //   } else {
  //     readId();
  //     writeIdToCache(state.salesId + 1);
  //     _performSale(index, color, solded, state.salesId, price, currency);
  //   }
  // }

  // // void sold(int index, String? color, double solded, BuildContext context, double price, CurrencyEnum currency) {
  // //   final indexMatchedColor = _findIndexForColor(index, color);
  // //   if (indexMatchedColor == null) return;
  // //   final indexOfStockDetail = getStockAtIndex(index, indexMatchedColor);
  // //   if (indexOfStockDetail == null) return;
  // //   if (_isOutOfStock(indexOfStockDetail, solded)) {
  // //     showOutOfDialog(context);
  // //     return;
  // //   } else {
  // //     readId();
  // //     writeIdToCache(state.salesId + 1);
  // //     _performSale(index, color, solded, state.salesId, price, currency);
  // //   }
  // // }

  void get getTotalIncome {
    var totalIncome = 0.0;
    if (state.sales == null) return;
    for (final sales in state.sales!) {
      totalIncome += sales.price ?? 0;
    }
    emit(state.copyWith(totalIncome: totalIncome));
  }

  Future<dynamic> showOutOfDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: Text('Stok Yetersiz'),
        );
      },
    );
  }
}
