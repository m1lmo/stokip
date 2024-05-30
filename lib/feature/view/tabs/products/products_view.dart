// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/project_paddings.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/navigator_manager.dart';
import 'package:stokip/product/widgets/custom_container.dart';
import 'package:stokip/product/widgets/search_container.dart';

class ProductsView extends StatefulWidget with NavigatorManager {
  const ProductsView({
    super.key,
  });

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late final TextEditingController searchEditingController;

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockCubit = BlocProvider.of<StockCubit>(context);

    final textEditingController = TextEditingController();
    return BlocProvider.value(
      value: stockCubit
        ..updateAppBarTitle(ProjectStrings.productsAppBarTitle)
        ..getProduct(),
      child: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                ProjectStrings.productsAppBarTitle,
              ),
              actions: [
                BlocBuilder<StockCubit, StockState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        showBottomSheet(
                          context: context,
                          builder: (context) {
                            return BlocProvider<StockCubit>.value(
                              value: stockCubit,
                              child: TextField(
                                controller: textEditingController,
                                onEditingComplete: () async {
                                  if (textEditingController.text.isEmpty) return;
                                  await context.read<StockCubit>().addProduct(
                                        id: state.productId,
                                        StockModel(
                                          id: state.productId,
                                          title: textEditingController.text,
                                          pPrice: 12,
                                          sPrice: 13,
                                          stockDetailModel: [],
                                        ),
                                      );
                                },
                              ),
                            );
                          },
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
                  SearchContainer(controller: searchEditingController),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContainer(text: '400m', title: 'Toplam'), // TODOLOCALIZATION
                      CustomContainer(text: 'Lüx', title: 'Trend'), // TODOLOCALIZATION
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContainer(text: r'2000$', title: 'Varlık'), // TODOLOCALIZATION
                      CustomContainer(text: 'Lüx', title: 'Tükeniyor'), // TODOLOCALIZATION
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
