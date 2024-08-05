import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/project_paddings.dart';
import 'package:stokip/product/extensions/currency_enum_extension.dart';
import 'package:stokip/product/extensions/string_extension.dart';
import 'package:stokip/product/navigator_manager.dart';
import 'package:stokip/product/widgets/custom_container.dart';
import 'package:stokip/product/widgets/custom_divider.dart';
import 'package:stokip/product/widgets/my_search_delegate.dart';
import 'package:stokip/product/widgets/search_container.dart';

part '../widgets/customer_list_tile.dart';
part '../widgets/customer_search_delegate.dart';

final class CustomerTabView extends StatelessWidget {
  const CustomerTabView({required this.controller, required this.customerCubit, required this.showBottomSheetPressed, required this.currentListTileOnTap, super.key});
  final TextEditingController controller;
  final CustomerCubit customerCubit;
  final VoidCallback showBottomSheetPressed;
  final VoidCallback currentListTileOnTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.mainPadding(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocSelector<CustomerCubit, CustomerState, int>(
                selector: (state) {
                  return state.customers?.length ?? 0;
                },
                builder: (context, state) {
                  return CustomContainer(text: '$state', title: 'Toplam Cari');
                },
              ),
              BlocSelector<CustomerCubit, CustomerState, double>(
                selector: (state) {
                  return state.totalBalance ?? 0;
                },
                builder: (context, state) {
                  return CustomContainer(text: '$state\$', title: 'Alacak Bakiye');
                },
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          BlocSelector<CustomerCubit, CustomerState, List<CustomerModel>>(
            selector: (state) {
              return state.customers ?? [];
            },
            builder: (context, state) {
              return SearchContainer(
                delegate: _CustomerSearchDelegate(items: state),
              );
            },
          ),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: BlocSelector<CustomerCubit, CustomerState, List<CustomerModel>?>(
              selector: (state) {
                return state.customers;
              },
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _CustomerListTile(
                      customer: state![index],
                      onTap: currentListTileOnTap,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
            onPressed: showBottomSheetPressed,
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                ),
              ),
              backgroundColor: WidgetStateProperty.all(ProjectColors2.formBackground),
            ),
            child: Text('Add Customer', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ProjectColors2.primaryContainer)),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}
