// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/view/products_detail/products_detail_view.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/project_paddings.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/extensions/currency_enum_extension.dart';
import 'package:stokip/product/extensions/string_extension.dart';
import 'package:stokip/product/navigator_manager.dart';
import 'package:stokip/product/widgets/custom_bottom_sheet.dart';
import 'package:stokip/product/widgets/custom_container.dart';
import 'package:stokip/product/widgets/search_container.dart';
part './widgets/bottom_sheet_child.dart';
part './widgets/product_data_container.dart';

class ProductsView extends StatefulWidget with NavigatorManager {
  const ProductsView({
    super.key,
  });

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> with NavigatorManager {
  late final TextEditingController searchEditingController;
  late final TextEditingController textEditingController;
  late final TextEditingController productNameEditingController;
  late final TextEditingController pPriceEditingController;
  late final TextEditingController sPriceEditingController;
  late final StockCubit blocProvider;
  late final SalesCubit salesCubit;

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
    textEditingController = TextEditingController();
    productNameEditingController = TextEditingController();
    pPriceEditingController = TextEditingController();
    sPriceEditingController = TextEditingController();
    blocProvider = BlocProvider.of<StockCubit>(context)..readId();
    salesCubit = BlocProvider.of<SalesCubit>(context);
  }

  @override
  void dispose() {
    super.dispose();
    searchEditingController.dispose();
    textEditingController.dispose();
    productNameEditingController.dispose();
    pPriceEditingController.dispose();
    sPriceEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: blocProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ProjectStrings.productsAppBarTitle,
          ),
          actions: [
            BlocSelector<StockCubit, StockState, int>(
              selector: (state) {
                return state.productId;
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    CustomBottomSheet.show(
                      context,
                      title: 'add product', // TODOLOCALIZATION
                      child: _BottomSheetChild(
                        textEditingController: productNameEditingController,
                        pPriceEditingController: pPriceEditingController,
                        sPriceEditingController: sPriceEditingController,
                        onPressed: () {
                          blocProvider.addProduct(
                            StockModel(
                              id: state,
                              title: productNameEditingController.text.toCapitalized(),
                              pPrice: double.tryParse(pPriceEditingController.text) ?? 0,
                              sPrice: double.tryParse(sPriceEditingController.text) ?? 0,
                              stockDetailModel: [],
                            ),
                          );
                          productNameEditingController.clear();
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: ProjectPaddings.mainPadding(),
          child: Column(
            children: [
              // SearchContainer(controller: searchEditingController, items: blocProvider.state.products),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocSelector<StockCubit, StockState, double>(
                    selector: (state) {
                      return state.totalMeter ?? 0;
                    },
                    builder: (context, state) {
                      return CustomContainer(text: '${state.toInt()}m', title: 'Toplam');
                    },
                  ), // TODOLOCALIZATION
                  BlocSelector<SalesCubit, SalesState, StockModel?>(
                    selector: (state) {
                      return state.trendProduct;
                    },
                    builder: (context, state) {
                      return CustomContainer(text: '${state?.title}', title: 'Trend');
                    },
                  ), // TODOLOCALIZATION
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocSelector<StockCubit, StockState, double>(
                    selector: (state) {
                      return state.totalAmount ?? 0;
                    },
                    builder: (context, state) {
                      return CustomContainer(text: '$state\$', title: 'Varlık');
                    },
                  ), // TODOLOCALIZATION
                  BlocSelector<StockCubit, StockState, String>(
                    selector: (state) {
                      return state.runningOutStock?.title ?? '';
                    },
                    builder: (context, state) {
                      return CustomContainer(text: state, title: 'Tükeniyor');
                    },
                  ), // TODOLOCALIZATION
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: BlocSelector<StockCubit, StockState, List<StockModel>?>(
                  selector: (state) {
                    return state.products;
                  },
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: _ProductDataContainer(
                            stock: state?[index],
                            onPressed: () {
                              if (state?[index] == null) return;
                              // blocProvider.updateStockDetails(state![index].stockDetailModel);
                              navigateToPage(
                                context,
                                ProductsDetailView(
                                  stockModel: state![index],
                                  stockCubit: blocProvider,
                                  salesCubit: salesCubit,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
