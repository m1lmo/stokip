import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobx/mobx.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';
part 'sales_view_model.g.dart';

class SalesViewModel = _SalesVievModelBase with _$SalesViewModel;

abstract class _SalesVievModelBase with Store {
  @observable
  ObservableList<FilterModel<SalesFilterEnum>> filters = ObservableList.of(SalesFilterEnum.values.map((e) => FilterModel<SalesFilterEnum>(filterType: e, isSelected: false)));
  late final SalesCubit blocProvider;
  late final CustomerCubit customerCubitProvider;
  late final StockCubit stockCubitProvider;
  final stockDropDownController = SingleValueDropDownController();
  final customerDropDownController = SingleValueDropDownController();
  final stockDetailDropDownController = SingleValueDropDownController();
  final currencyDropDownController = SingleValueDropDownController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  @action
  void init(BuildContext context) {
    blocProvider = BlocProvider.of<SalesCubit>(context);
    customerCubitProvider = BlocProvider.of<CustomerCubit>(context);
    stockCubitProvider = BlocProvider.of<StockCubit>(context);
  }

  void dispose() {
    stockDropDownController.dispose();
    customerDropDownController.dispose();
    stockDetailDropDownController.dispose();
    currencyDropDownController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  @action
  void sortFilters() {
    filters
      ..replaceRange(0, filters.length, filters)
      ..sort((a, b) {
        if (a.isSelected && !b.isSelected) {
          return -1;
        } else if (!a.isSelected && b.isSelected) {
          return 1;
        } else {
          return 0;
        }
      });
  }

  @action
  void selectFilter(FilterModel<SalesFilterEnum> filter) {
    final index = filters.indexWhere((element) => element == filter);
    filters[index].isSelected = !filters[index].isSelected;
    sortFilters();
    blocProvider.applyFilter(filters, filter);
  }

  @action
  void addSale() {
    final saleModel = SalesModel(
      customer: customerDropDownController.dropDownValue?.value as CustomerModel?,
      itemName: stockDropDownController.dropDownValue?.value?.title as String,
      dateTime: DateTime.now(),
      stockDetailModel: stockDetailDropDownController.dropDownValue?.value as StockDetailModel,
      quantity: double.tryParse(quantityController.text),
      price: double.tryParse(priceController.text),
      currency: currencyDropDownController.dropDownValue!.value as CurrencyEnum,
    );
    if (saleModel.customer == null || saleModel.stockDetailModel == null || saleModel.quantity == null || saleModel.price == null) return;
    blocProvider.addSale(model: saleModel);
    customerCubitProvider.updateCustomerBalance(saleModel.customer!, saleModel.price! * saleModel.quantity!);
    stockCubitProvider.updateTotalMeter(itemId: (stockDropDownController.dropDownValue!.value as StockModel).id);
  }
}
