// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/model/filter_model.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProjectStrings.salesAppBarTitle),
        actions: [
          IconButton(
            onPressed: () {},
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(text: r'400$', title: 'Toplam Bakiye'),
                    CustomContainer(text: r'400$', title: 'Toplam Bakiye'),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(text: r'400$', title: 'Toplam Bakiye'),
                    CustomContainer(text: r'400$', title: 'Toplam Bakiye'),
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
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: DataContainer(
                          data: SalesModel(
                            id: 0,
                            dateTime: DateTime.now(),
                            title: 'Lüx Süet - Yeşil',
                            meter: 10,
                            price: 100,
                            currency: CurrencyEnum.tl,
                          ),
                        ),
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
    );
  }
}
