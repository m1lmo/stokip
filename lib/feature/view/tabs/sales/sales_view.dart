// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/view/tabs/sales/sales_view_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';

import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/widgets/custom_container.dart';

import 'package:stokip/product/widgets/custom_icon.dart';
import 'package:stokip/product/widgets/data_container.dart';
import 'package:stokip/product/widgets/my_filter_chip.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

  @override
  void initState() {
    super.initState();
    searchTextEditingController = TextEditingController();
    salesViewModel.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: salesViewModel.blocProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ProjectStrings.salesAppBarTitle),
          actions: [
            IconButton(
              onPressed: () {
                salesViewModel.blocProvider.sold(
                  0,
                  'yeşil',
                  40,
                  context,
                  4,
                  CurrencyEnum.usd,
                );
              },
              icon: const Icon(CustomIcons.add),
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
                          salesViewModel.blocProvider.getTotalIncome;
                          return state.totalIncome ?? 0.0;
                        },
                        builder: (context, state) {
                          return CustomContainer(text: '$state\$', title: 'Toplam Gelir');
                        },
                      ),
                      const CustomContainer(text: 'Lüx', title: 'En Çok Satan'),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContainer(text: '400m', title: 'Bu Ay Satılan'),
                      CustomContainer(text: 'Omer Koca', title: 'En Çok Alan'),
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
                  SearchContainer(
                    controller: searchTextEditingController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: BlocSelector<SalesCubit, SalesState, List<SalesModel>?>(
                      selector: (state) {
                        return state.sales;
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
