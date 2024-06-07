// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/project_strings.dart';

class ProductsDetailView extends StatelessWidget {
  const ProductsDetailView({
    required this.index,
    required this.stockCubit,
    super.key,
  });

  final int index;
  final StockCubit stockCubit;

  @override
  Widget build(BuildContext context) {
    final detailTitleTextController = TextEditingController();
    final detailMeterTextController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: stockCubit,
        ),
        BlocProvider(
          create: (context) => SalesCubit(),
        ),
      ],
      child: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: BlocBuilder<StockCubit, StockState>(
                builder: (context, state) {
                  return Text(state.products![index].title!);
                },
              ),
              leading: BlocBuilder<StockCubit, StockState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: const Icon(Icons.navigate_before),
                  );
                },
              ),
              actions: [
                BlocBuilder<StockCubit, StockState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        _showModal(
                          context,
                          index,
                          detailTitleTextController,
                          detailMeterTextController,
                        );
                      },
                      icon: const Icon(Icons.add),
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<StockCubit, StockState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.products?[index].stockDetailModel.length ?? 0,
                  itemBuilder: (context, indexOfDetails) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          state.products?[index].stockDetailModel[indexOfDetails].title ?? '',
                        ), //şimdiki
                        trailing: Text(
                          '${state.products?[index].stockDetailModel[indexOfDetails].meter} ${ProjectStrings.meter}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void _showModal(
  BuildContext context,
  int index,
  TextEditingController detailTitleController,
  TextEditingController detailMeterController,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return BlocProvider<StockCubit>.value(
        value: BlocProvider.of<StockCubit>(context),
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: ProjectStrings.pickDetailItem,
                          ),
                          controller: detailTitleController,
                          onEditingComplete: () {
                            context.read<StockCubit>().addOrUpdateDetailedStock(
                                  index,
                                  StockDetailModel(
                                    title: detailTitleController.text,
                                    itemDetailId: 0,
                                    itemId: 0,
                                    meter: 12,
                                  ),
                                );
                            context.read<StockCubit>().getProduct();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: detailMeterController,
                          decoration: InputDecoration(
                            hintText: ProjectStrings.meter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    final meterControllerToDouble = double.tryParse(detailMeterController.text);
                    context.read<StockCubit>().addOrUpdateDetailedStock(
                          index,
                          StockDetailModel(
                            itemDetailId: 0,
                            itemId: 0,
                            title: detailTitleController.text,
                            meter: meterControllerToDouble,
                          ),
                        );
                    context.read<StockCubit>().getProduct();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
