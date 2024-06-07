import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobx/mobx.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';
part 'sales_view_model.g.dart';

class SalesViewModel = _SalesVievModelBase with _$SalesViewModel;

abstract class _SalesVievModelBase with Store {
  @observable
  ObservableList<FilterModel<SalesFilterEnum>> filters = ObservableList.of(SalesFilterEnum.values.map((e) => FilterModel<SalesFilterEnum>(filterType: e, isSelected: false)));
  late final SalesCubit blocProvider;
  late final CustomerCubit customerCubitProvider;
  late final StockCubit stockCubitProvider;
  late final SingleValueDropDownController? stockDropDownController;
  late final SingleValueDropDownController? customerDropDownController;
  late final SingleValueDropDownController? stockDetailDropDownController;

  @action
  void init(BuildContext context) {
    blocProvider = BlocProvider.of<SalesCubit>(context)..readId();
    customerCubitProvider = BlocProvider.of<CustomerCubit>(context);
    stockCubitProvider = BlocProvider.of<StockCubit>(context);
    stockDropDownController = SingleValueDropDownController();
    customerDropDownController = SingleValueDropDownController();
    stockDetailDropDownController = SingleValueDropDownController();
  }

  @action
  void sortFilters() {
    filters.replaceRange(0, filters.length, filters);
    filters.sort((a, b) {
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
  }
}
