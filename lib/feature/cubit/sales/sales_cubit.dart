// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';

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

  late final StockHiveOperation? stockDatabaseOperation;
  late final List<StockModel>? stocks;
  static final List<SalesModel> saless = [];
  final List<SalesModel> filteredSales = [];
  late final SharedManager sharedManager;
  final SaleHiveOperation saleDatabaseOperation = SaleHiveOperation();
  List<SalesModel> get currentSales => List<SalesModel>.from(saless);

  //initFor provider.value

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await saleDatabaseOperation.start();
    sharedManager = await SharedManager.getInstance;
    if (saleDatabaseOperation.box.isNotEmpty) {
      saless.addAll(saleDatabaseOperation.box.values);
    }
    getSales();
    // } catch (e) {
    //   print(e);
    // }
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

//todo bunun içinde isSelected değilse applyfilterı tekrar çağır ve diğer value ları kontrol ettir
  void applyFilter2(List<FilterModel<SalesFilterEnum>> values, FilterModel value) {
    print('a');
    switch (value.filterType) {
      case SalesFilterEnum.lastMonth:
        if (!value.isSelected) {
          filteredSales.removeWhere((element) => element.dateTime.month == DateTime.now().month - 1);
          values.map(
            (e) {
              if (e.isSelected) {
                return applyFilter2(values, e);
              }
            },
          );
          break;
        } else {
          filteredSales.addAll(
            saless.where(
              (element) {
                if (filteredSales.contains(element)) {
                  return false;
                } else {
                  return element.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 30)));
                }
              },
            ),
          );
          break;
        }
      case SalesFilterEnum.lastWeek:
        if (!value.isSelected) {
          filteredSales.removeWhere((element) => element.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7))));
          for (final filter in values) {
            if (filter.isSelected) {
              applyFilter2(values, filter);
            }
          }
          break;
        } else {
          filteredSales.addAll(
            saless.where(
              (element) {
                if (filteredSales.contains(element)) {
                  return false;
                } else {
                  return element.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7)));
                }
              },
            ),
          );
          break;
        }
      case SalesFilterEnum.today:
        if (!value.isSelected) {
          filteredSales.removeWhere((element) => element.dateTime.day == DateTime.now().day);
          values.map(
            (e) {
              if (e.isSelected) {
                return applyFilter2(values, e);
              }
            },
          );
          break;
        } else {
          filteredSales.addAll(
            saless.where(
              (element) {
                if (filteredSales.contains(element)) {
                  return false;
                } else {
                  return element.dateTime.day == DateTime.now().day;
                }
              },
            ),
          );
          break;
        }
      case SalesFilterEnum.yesterday:
        if (!value.isSelected) {
          filteredSales.removeWhere((element) => element.dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day);
          values.map(
            (e) {
              if (e.isSelected) {
                return applyFilter2(values, e);
              }
            },
          );
          break;
        } else {
          filteredSales.addAll(
            saless.where(
              (element) {
                if (filteredSales.contains(element)) {
                  return false;
                } else {
                  return element.dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day;
                }
              },
            ),
          );
          break;
        }

      default:
    }
    emit(state.copyWith(filteredSales: filteredSales));

    // void filterSales(
    //   List<FilterModel<SalesFilterEnum>?> filters,
    // ) {
    //   for (final filter in filters) {
    //     switch (filter?.filterType) {
    //       case SalesFilterEnum.lastMonth:
    //         if (!filter!.isSelected) {
    //           filteredSales.removeWhere((element) => element.dateTime.month == DateTime.now().month - 1);
    //         } else {
    //           filteredSales.addAll(
    //             saless.where((element) {
    //               if (filteredSales.contains(element)) {
    //                 return false;
    //               } else {
    //                 return element.dateTime.month == DateTime.now().month - 1;
    //               }
    //             }),
    //           );
    //         }
    //         emit(state.copyWith(filteredSales: filteredSales));
    //       case SalesFilterEnum.lastWeek:
    //         if (!filter!.isSelected) {

    //           filteredSales.removeWhere((element) => element.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7))));
    //         } else {
    //           filteredSales.addAll(
    //             saless.where((element) {
    //               if (filteredSales.contains(element)) {
    //                 return false;
    //               } else {
    //                 return element.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    //               }
    //             }),
    //           );
    //         }
    //         emit(state.copyWith(filteredSales: filteredSales));
    //       case SalesFilterEnum.today:
    //         if (!filter!.isSelected) {
    //           filteredSales.removeWhere((element) => element.dateTime.day == DateTime.now().day);
    //         } else {
    //           filteredSales.addAll(
    //             saless.where((element) {
    //               if (filteredSales.contains(element)) {
    //                 return false;
    //               } else {
    //                 return element.dateTime.day == DateTime.now().day;
    //               }
    //             }),
    //           );
    //         }
    //         emit(state.copyWith(filteredSales: filteredSales));
    //       case SalesFilterEnum.yesterday:
    //         if (!filter!.isSelected) {
    //           filteredSales.removeWhere((element) => element.dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day);
    //         } else {
    //           filteredSales.addAll(
    //             saless.where((element) {
    //               if (filteredSales.contains(element)) {
    //                 return false;
    //               } else {
    //                 return element.dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day;
    //               }
    //             }),
    //           );
    //         }
    //         emit(state.copyWith(filteredSales: filteredSales));
    //       default:
    //     }
    //   }
    // switch (filter?.filterType) {
    //   case SalesFilterEnum.lastMonth:
    //     if (filter!.isSelected) {
    //       filteredSales.clear();
    //     }
    //     filteredSales.addAll(saless.where((element) => element.dateTime.month == DateTime.now().month - 1));
    //     return emit(state.copyWith(filteredSales: filteredSales));
    //   case SalesFilterEnum.lastWeek:
    //     if (!filter!.isSelected) {
    //       filteredSales.clear();
    //     }
    //     filteredSales.addAll(saless.where((element) => element.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7)))));
    //     return emit(state.copyWith(filteredSales: filteredSales));
    //   case SalesFilterEnum.today:
    //     filteredSales.addAll(saless.where((element) => element.dateTime.day == DateTime.now().day));
    //     return emit(state.copyWith(filteredSales: filteredSales));
    //   case SalesFilterEnum.yesterday:
    //     filteredSales.addAll(saless.where((element) => element.dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day));
    //     return emit(state.copyWith(filteredSales: filteredSales));
    //   default:
    // }
  }

  void _applySelectedFilters(List<FilterModel<SalesFilterEnum>> values) {
    for (final filter in values) {
      if (filter.isSelected) {
        applyFilter(values, filter);
      }
    }
  }

  void _removeFromFilteredSales(bool Function(DateTime dateTime) func, List<FilterModel<SalesFilterEnum>> values) {
    filteredSales.removeWhere((element) => func(element.dateTime));
    _applySelectedFilters(values);
  }

  void _addToFilteredSales(bool Function(DateTime dateTime) func) {
    filteredSales.addAll(
      saless.where((element) {
        if (filteredSales.contains(element)) {
          return false;
        } else {
          return func(element.dateTime);
        }
      }),
    );
  }

  void applyFilter(List<FilterModel<SalesFilterEnum>> values, FilterModel value) {
    switch (value.filterType) {
      case SalesFilterEnum.lastMonth:
        if (!value.isSelected) {
          _removeFromFilteredSales((dateTime) => dateTime.isAfter(DateTime.now().subtract(const Duration(days: 30))), values);
        } else {
          _addToFilteredSales((dateTime) => dateTime.isAfter(DateTime.now().subtract(const Duration(days: 30))));
        }
      case SalesFilterEnum.lastWeek:
        if (!value.isSelected) {
          _removeFromFilteredSales((dateTime) => dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7))), values);
        } else {
          _addToFilteredSales((dateTime) => dateTime.isAfter(DateTime.now().subtract(const Duration(days: 7))));
        }
      case SalesFilterEnum.today:
        if (!value.isSelected) {
          _removeFromFilteredSales((dateTime) => dateTime.day == DateTime.now().day, values);
        } else {
          _addToFilteredSales((dateTime) => dateTime.day == DateTime.now().day);
        }
      case SalesFilterEnum.yesterday:
        if (!value.isSelected) {
          _removeFromFilteredSales((dateTime) => dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day, values);
        } else {
          _addToFilteredSales((dateTime) => dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day);
        }
      default:
    }
    if (values.every((element) => !element.isSelected)) {
      return emit(state.copyWith(filteredSales: currentSales));
    }

    emit(state.copyWith(filteredSales: List.from(filteredSales)));
  }

  void _filterSales() {}

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

  void updateMonthlySoldMeter(int month) {
    var totalMeter = 0.0;
    if (_monthlySales(month) == null) return;
    for (final sales in _monthlySales(month)!) {
      totalMeter += sales.quantity ?? 0;
    }
    return emit(state.copyWith(monthlySoldMeter: totalMeter));
  }

  void updateMonthlySalesAmount(int month) {
    var amount = 0.0;
    if (_monthlySales(month) == null) return;
    for (final sales in _monthlySales(month)!) {
      var currentAmount = sales.price ?? 0;
      currentAmount *= sales.quantity ?? 0;
      amount += currentAmount;
    }
    return emit(state.copyWith(monthlySoldAmount: amount));
  }

  // void totalSaledMeter() {
  //   var totalMeter = 0.0;
  //   if (state.sales == null) return;
  //   for (final sales in state.sales!) {
  //     totalMeter += sales.quantity ?? 0;
  //   }
  //   emit(state.copyWith(soldedMeterThisMonth: totalMeter));
  // }

  /// this method is for update trend product u have to call on the saleview
  /// cause the stocks sometimes is coming after this method when we add the init method
  void updateTrendProduct() {
    final grouppedSales = state.sales?.groupListsBy<int?>((element) => element.stockDetailModel?.itemId).values.toList();
    if (grouppedSales == null || grouppedSales.isEmpty) return;

    var maxSoldMeter = 0.0;
    StockDetailModel? trendProductDetail;

    for (final salesList in grouppedSales) {
      var totalSoldMeter = 0.0;
      for (final sales in salesList) {
        totalSoldMeter += sales.quantity ?? 0;
      }
      if (totalSoldMeter > maxSoldMeter) {
        maxSoldMeter = totalSoldMeter;
        trendProductDetail = salesList.first.stockDetailModel;
      }
    }
    if (stocks?.isEmpty ?? true) {
      return;
    }
    final trendProduct = stocks?.firstWhere((element) => element.id == trendProductDetail!.itemId);
    emit(state.copyWith(trendProduct: trendProduct));
  }

  void getSales() {
    if (saless.isEmpty) return;
    getTotalIncome;
    return emit(
      state.copyWith(
        sales: saless,
      ),
    );
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
        stockDatabaseOperation?.addOrUpdateItem(stock);
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

  String? getStockTitleById(int? id) {
    if (id == null) return null;
    final stock = stocks?.firstWhere((element) => element.id == id);
    return stock?.title;
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
