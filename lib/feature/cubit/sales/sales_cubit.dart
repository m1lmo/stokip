// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/service/repository/sale_repository.dart';
import 'package:stokip/product/cache/storage_manager.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/sales_hive_operation.dart';
import 'package:stokip/product/database/operation/stock_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';
import 'package:stokip/product/widgets/c_notify.dart';
import 'package:stokip/test_global.dart';

part 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit({
    this.stockDatabaseOperation,
    this.stocks,
  }) : super(SalesState());

  late final StockHiveOperation? stockDatabaseOperation;
  late final List<StockModel>? stocks;
  final List<SalesModel> saless = [];
  final List<SalesModel> filteredSales = [];
  final dioHelper = DioHelper.instance();
  late final SaleRepository saleRepository;
  final SaleHiveOperation saleDatabaseOperation = SaleHiveOperation();
  final secureStorage = StorageManager.instance();
  List<SalesModel> get currentSales => List<SalesModel>.from(saless);

  //initFor provider.value

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await saleDatabaseOperation.start();
    saleRepository = SaleRepository(dioHelper.dio);
    if (saleDatabaseOperation.box.isNotEmpty && !globalInternetConnection) {
      saless.addAll(saleDatabaseOperation.box.values);
    } else {
      final data = await saleRepository.fetchData();
      if (data == null) return;
      for (final item in data) {
        if (item == null) continue;
        saless.add(item);
        await saleDatabaseOperation.addOrUpdateItem(item);
      }
    }
    getSales();
  }

  List<SalesModel>? _monthlySales(int currentMonth) {
    return state.sales?.where((sale) {
      return sale.dateTime.month == currentMonth;
    }).toList();
  }

  Text getSoldTime(int index) {
    final reversedSales = state.sales?.reversed.toList();
    final times = reversedSales?[index].dateTime;
    return Text('${times?.day} ${times?.month} ${times?.year}');
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

  void updateTopCustomer(int month) {
    final grouppedSales = _monthlySales(month)?.groupListsBy((element) => element.customer?.title).values.toList();
    if (grouppedSales == null || grouppedSales.isEmpty) return;
    var maxSoldMeter = 0.0;
    CustomerModel? topCustomer;
    for (final salesList in grouppedSales) {
      var totalSoldMeter = 0.0;
      for (final sales in salesList) {
        totalSoldMeter += sales.quantity ?? 0;
      }
      if (totalSoldMeter > maxSoldMeter) {
        maxSoldMeter = totalSoldMeter;
        topCustomer = salesList.first.customer;
      }
    }
    emit(state.copyWith(topCustomer: topCustomer));
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
    final trendProduct = stocks?.firstWhere((element) => element.id == trendProductDetail?.itemId);
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

  Future<void> addSale({
    required SalesModel model,
  }) async {
    print('itemid: ' '${model.stockDetailModel?.itemId}');
    if ((model.stockDetailModel?.meter ?? 0) == 0) return CNotify(message: 'Ürünün stoğu yetersiz', title: 'Stok Yetersiz').show();
    final copyModel = model.copyWith(id: saless.length + 1);
    final isOkay = await saleRepository.postData(copyModel);
    if (!isOkay) return;
    saleDatabaseOperation.addOrUpdateItem(copyModel);
    saless.add(copyModel);
    _updateStocks(model);
    emit(state.copyWith(sales: currentSales));
  }

  void _updateStocks(SalesModel model) {
    if (stocks == null) return;
    for (final stock in stocks!) {
      if (stock.title != model.itemName) continue;
      for (final detail in stock.stockDetailModel) {
        if (detail.title?.toLowerCase() != model.stockDetailModel?.title?.toLowerCase()) continue;
        detail.meter = detail.meter! - model.quantity!;
        // stockDatabaseOperation?.addOrUpdateItem(stock);
      }
    }
  }

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

  double highestSale() {
    var highest = 0.0;
    if (state.sales == null) return highest;
    for (final sales in state.sales!) {
      if (sales.quantity! > highest) {
        highest = sales.quantity!;
      }
    }
    return highest;
  }

  double? getAverageSales() {
    var total = 0.0;
    if (state.sales == null) return total;
    for (final sales in state.sales!) {
      total += sales.quantity ?? 0;
    }
    return total / state.sales!.length;
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
