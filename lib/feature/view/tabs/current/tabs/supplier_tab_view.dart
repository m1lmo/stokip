import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/project_paddings.dart';
import 'package:stokip/product/extensions/currency_enum_extension.dart';
import 'package:stokip/product/widgets/custom_container.dart';
import 'package:stokip/product/widgets/custom_divider.dart';
import 'package:stokip/product/widgets/my_search_delegate.dart';
import 'package:stokip/product/widgets/search_container.dart';

part '../widgets/supplier_list_tile.dart';
part '../widgets/supplier_search_delegate.dart';

class SupplierTabView extends StatelessWidget {
  const SupplierTabView({required this.importerCubit, required this.searchController, required this.showBottomSheetPressed, super.key});
  final ImporterCubit importerCubit;
  final TextEditingController searchController;
  final VoidCallback showBottomSheetPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.mainPadding(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocSelector<ImporterCubit, ImporterState, int>(
                selector: (state) {
                  return state.importers?.length ?? 0;
                },
                builder: (context, state) {
                  return CustomContainer(text: state.toString(), title: 'Toplam Cari');
                },
              ),
              BlocSelector<ImporterCubit, ImporterState, double>(
                selector: (state) {
                  return state.totalBalance;
                },
                builder: (context, state) {
                  return CustomContainer(text: '$state\$', title: 'Borç Bakiye');
                },
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          BlocSelector<ImporterCubit, ImporterState, List<ImporterModel>>(
            selector: (state) {
              return state.importers ?? [];
            },
            builder: (context, state) {
              return SearchContainer(
                delegate: _SupplierSearchDelegate(items: state),
              );
            },
          ),
          BlocSelector<ImporterCubit, ImporterState, List<ImporterModel>?>(
            selector: (state) {
              return state.importers;
            },
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _ImporterListTile(importer: state![index]);
                  },
                ),
              );
            },
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
            child: Text('Add Supplier', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: ProjectColors2.primaryContainer)),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}
