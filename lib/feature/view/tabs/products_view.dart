// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/view/products_detail_view.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/navigator_manager.dart';

class ProductsView extends StatelessWidget with NavigatorManager {
  const ProductsView({
    super.key,
  });

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
              title: Text(state.appBarTitle ?? ProjectStrings.productsAppBarTitle),
              actions: [
                BlocBuilder<StockCubit, StockState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        context.read<StockCubit>().clearProducts();
                      },
                      icon: const Icon(Icons.search),
                    );
                  },
                ),
                BlocBuilder<StockCubit, StockState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        showBottomSheet<Widget?>(
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
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                      vertical: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: context.general.isKeyBoardOpen
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(ProjectStrings.productsTotal),
                                    Text(
                                      '${state.products?.length}',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.025,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(ProjectStrings.stockTotal),
                                    Text(
                                      '${state.totalMeter} Metre',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.025,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: BlocBuilder<StockCubit, StockState>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.products?.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              navigateToPage(
                                context,
                                ProductsDetailView(
                                  index: index,
                                  stockCubit: stockCubit,
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                leading: Text('${state.products?[index].totalMeter}'),
                                title: Text(state.products?[index].title ?? ''),
                                subtitle: Text(
                                  state.products?[index].id.toString() ?? '',
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    context.read<StockCubit>().removeProduct(index);
                                  },
                                  icon: const Icon(IconData(0xf4c4)),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
