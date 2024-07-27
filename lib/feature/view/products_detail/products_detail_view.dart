// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/view/tabs/products/products_view.dart';
import 'package:stokip/product/constants/custom_icon.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/project_paddings.dart';
import 'package:stokip/product/extensions/currency_enum_extension.dart';
import 'package:stokip/product/extensions/string_extension.dart';
import 'package:stokip/product/widgets/custom_bottom_sheet.dart';
import 'package:stokip/product/widgets/custom_container.dart';
import 'package:stokip/product/widgets/custom_divider.dart';

part './widgets/bottom_sheet_child.dart';
part './widgets/merged_custom_container.dart';
part './widgets/product_detail_data_container.dart';
// part './widgets/data_column_bg.dart';

class ProductsDetailView extends StatefulWidget {
  const ProductsDetailView({
    required this.stockCubit,
    required this.salesCubit,
    required this.stockModel,
    super.key,
  });

  final StockCubit stockCubit;
  final SalesCubit salesCubit;
  final StockModel stockModel;

  @override
  State<ProductsDetailView> createState() => _ProductsDetailViewState();
}

class _ProductsDetailViewState extends State<ProductsDetailView> {
  late final TextEditingController searchController;
  late final TextEditingController productDetailController;
  late final TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
    productDetailController = TextEditingController();
    quantityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: widget.stockCubit
            ..getRunningOutStockDetail(widget.stockModel.id)
            ..updateTrendStock(widget.salesCubit.state.sales, widget.stockModel),
        ),
        BlocProvider.value(
          value: widget.salesCubit..getSales(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.stockModel.title?.toTitleCase()}'),
          actions: [
          IconButton(
                  onPressed: () {
                    CustomBottomSheet.show(
                      context,
                      title: 'Ürün Ekle',
                      child: BottomSheetChild(
                        onPressed: () {
                          widget.stockCubit.addOrUpdateDetailedStock(
                            StockDetailModel(
                              itemId: widget.stockModel.id,
                              title: productDetailController.text,
                              meter: double.tryParse(quantityController.text),
                            ),
                          );
                          widget.stockCubit.getProduct();
                        },
                        productDetailController: productDetailController,
                        quantityController: quantityController,
                      ),
                    );
                  },
                  icon: const Icon(CustomIcons.add),
  
            ),
          ],
        ),
        body: Padding(
          padding: ProjectPaddings.mainPadding(),
          child: Column(
            children: [
              // SearchContainer(controller: searchController), //todo flag
              SizedBox(
                height: 2.h,
              ),
              MergedCustomContainer(
                stockModel: widget.stockModel,
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(text: '${widget.stockModel.totalMeter}m', title: 'Toplam'),
                  BlocSelector<StockCubit, StockState, StockDetailModel>(
                    selector: (state) {
                      return state.trendStockDetail ?? StockDetailModel(itemDetailId: -1, itemId: -1);
                    },
                    builder: (context, state) {
                      return CustomContainer(text: (state.title) ?? '', title: 'Trend');
                    },
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomContainer(text: r'300$', title: 'Kar'),
                  BlocSelector<StockCubit, StockState, StockDetailModel>(
                    selector: (state) {
                      return state.runningOutStockDetail ?? StockDetailModel(itemDetailId: -1, itemId: -1);
                    },
                    builder: (context, state) {
                      return CustomContainer(text: (state.title) ?? '', title: 'Tükeniyor');
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: BlocBuilder<StockCubit, StockState>(
                  builder: (context, state) {
                    final index = state.products!.indexWhere((element) => element.id == widget.stockModel.id);
                    return ListView.builder(
                      itemCount: state.products![index].stockDetailModel.length,
                      itemBuilder: (context, detailIndex) {
                        final item = state.products![index].stockDetailModel[detailIndex];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: ProductDetailDataContainer(
                            stockDetail: item,
                            onPressed: () {},
                            totalSale: widget.stockCubit.getTotalSale(widget.salesCubit.currentSales, item),
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
