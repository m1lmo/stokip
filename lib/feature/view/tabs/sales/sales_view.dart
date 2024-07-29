// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/view/tabs/sales/sales_view_model.dart';
import 'package:stokip/feature/view/tabs/sales/widgets/sale_delegate.dart';
import 'package:stokip/product/constants/custom_icon.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/extensions/currency_enum_extension.dart';
import 'package:stokip/product/extensions/string_extension.dart';
import 'package:stokip/product/widgets/custom_bottom_sheet.dart';
import 'package:stokip/product/widgets/custom_container.dart';
import 'package:stokip/product/widgets/data_container.dart';
import 'package:stokip/product/widgets/my_filter_chip.dart';
import 'package:stokip/product/widgets/search_container.dart';

part 'widgets/bottom_sheet_child.dart';

class SalesView extends StatefulWidget {
  const SalesView({
    super.key,
  });

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  final salesViewModel = SalesViewModel();
  late final TextEditingController searchTextEditingController;
  late final TextEditingController titleTextEditingController;

  @override
  void initState() {
    super.initState();
    searchTextEditingController = TextEditingController();
    titleTextEditingController = TextEditingController();

    salesViewModel.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    searchTextEditingController.dispose();
    titleTextEditingController.dispose();
    salesViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: salesViewModel.customerCubitProvider,
        ),
        BlocProvider.value(
          value: salesViewModel.blocProvider
            ..updateMonthlySoldMeter(DateTime.now().month)
            ..getTotalIncome
            ..updateTopCustomer(DateTime.now().month)
            ..updateTrendProduct(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(ProjectStrings.salesAppBarTitle),
          actions: [
            BlocSelector<StockCubit, StockState, List<StockModel>>(
              selector: (productState) {
                return productState.products ?? [];
              },
              builder: (context, productState) {
                return BlocSelector<CustomerCubit, CustomerState, List<CustomerModel>>(
                  selector: (customerState) {
                    return customerState.customers ?? [];
                  },
                  builder: (context, customerState) {
                    return IconButton(
                      onPressed: () {
                        CustomBottomSheet.show(
                          context,
                          child: _BottomSheetChild(
                            customers: customerState,
                            stocks: productState,
                            customerDropDownController: salesViewModel.customerDropDownController,
                            stockDropDownController: salesViewModel.stockDropDownController,
                            stockDetailDropDownController: salesViewModel.stockDetailDropDownController,
                            currencyDropDownController: salesViewModel.currencyDropDownController,
                            quantityController: salesViewModel.quantityController,
                            priceController: salesViewModel.priceController,
                            onSave: salesViewModel.addSale,
                          ),
                          title: 'Satış Ekle',
                        );
                      },
                      icon: const Icon(CustomIcons.add),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: 80.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocSelector<SalesCubit, SalesState, double>(
                        selector: (state) {
                          return state.totalIncome ?? 0.0;
                        },
                        builder: (context, state) {
                          return CustomContainer(text: '$state\$', title: 'Toplam Gelir');
                        },
                      ),
                      BlocSelector<SalesCubit, SalesState, StockModel?>(
                        selector: (state) {
                          return state.trendProduct;
                        },
                        builder: (context, state) {
                          return CustomContainer(text: state?.title?.toTitleCase() ?? '--', title: 'En Çok Satan');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocSelector<SalesCubit, SalesState, double>(
                        selector: (state) {
                          return state.monthlySoldMeter;
                        },
                        builder: (context, state) {
                          return CustomContainer(text: '${state}m', title: 'Bu Ay Satılan');
                        },
                      ),
                      BlocSelector<SalesCubit, SalesState, CustomerModel?>(
                        selector: (state) {
                          return state.topCustomer;
                        },
                        builder: (context, state) {
                          return CustomContainer(text: state?.title?.toTitleCase() ?? '', title: 'En Çok Alan');
                        },
                      ), //todo change this
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Observer(
                    builder: (_) {
                      return Wrap(
                        runSpacing: 1.h,
                        spacing: 2.w,
                        children: salesViewModel.filters
                            .map(
                              (e) => MyFilterChip<FilterModel<SalesFilterEnum>>(
                                value: e,
                                // groupValue: salesViewModel.activeFilters,
                                onChanged: (value) {
                                  if (value == null) return;
                                  salesViewModel.selectFilter(value);
                                },
                                title: e.filterType.name,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  BlocSelector<SalesCubit, SalesState, List<SalesModel>>(
                    selector: (state) {
                      // salesViewModel.blocProvider.filterSales(null);
                      return state.filteredSales ?? state.sales ?? [];
                    },
                    builder: (context, state) {
                      return Container(
                        child: SearchContainer<SalesModel>(
                          delegate: SaleDelegate(
                            salesViewModel.blocProvider,
                            items: state,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: BlocSelector<SalesCubit, SalesState, List<SalesModel>?>(
                      selector: (state) {
                        return state.filteredSales ?? state.sales;
                      },
                      builder: (context, state) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: state?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: DataContainer(
                                data: state![index],
                                saleBloc: salesViewModel.blocProvider,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
