// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/project_input_Decorations.dart';

class PurchasesView extends StatelessWidget {
  const PurchasesView({
    Key? key,
    required this.index,
    required this.importerState,
    required this.importerCubit,
    required this.stockCubit,
  }) : super(key: key);
  final int index;
  final ImporterState importerState;
  final ImporterCubit importerCubit;
  final StockCubit stockCubit;

  List<PurchasesModel>? get getStocksFromTheImporter {
    return importerState.importers?[index].purchases;
  }

  List<PaymentModel>? get getPaymentsFromTheImporter {
    return importerState.importers?[index].payments;
  }

  @override
  Widget build(BuildContext context) {
    final titleEditingController = TextEditingController();
    final priceEditingController = TextEditingController();
    final meterEditingController = TextEditingController();
    final detailEditingController = TextEditingController();
    final paymentEditingController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ImporterCubit>.value(
          value: importerCubit,
        ),
        BlocProvider<StockCubit>.value(
          value: stockCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ImporterCubit, ImporterState>(
            builder: (context, state) {
              return Text('${state.importers?[index].title}');
            },
          ),
          actions: [
            BlocBuilder<ImporterCubit, ImporterState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: _MySearchDelegate(
                        importerCubit: importerCubit,
                        importerState: state,
                        importerIndex: index,
                        navigateBackButton: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                );
              },
            ),
            BlocBuilder<ImporterCubit, ImporterState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    _showModal(
                      context,
                      index,
                      titleController: titleEditingController,
                      priceController: priceEditingController,
                      meterController: meterEditingController,
                      detailTitleController: detailEditingController,
                    );
                  },
                  icon: const Icon(Icons.add),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            showDialog<AlertDialog?>(
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: importerCubit,
                  child: AlertDialog(
                    title: Text('Ödeme Yaptığınız Değeri Giriniz'),
                    actions: [
                      BlocBuilder<ImporterCubit, ImporterState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () {
                              context.read<ImporterCubit>().paymentToIndexedSupplier(
                                    index,
                                    double.parse(paymentEditingController.text),
                                  );
                              context.read<ImporterCubit>().addPaymentLogs(
                                  index, double.tryParse(paymentEditingController.text) ?? 0);
                              Navigator.of(context).pop();
                            },
                            child: const Text('İşlemi Tamamla'),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Vazgeç',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    content: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      controller: paymentEditingController,
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.blue.shade200,
          child: Text(
            'Ödeme Yap',
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: BlocBuilder<ImporterCubit, ImporterState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alışlar',
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: getStocksFromTheImporter?.length ?? 0,
                    itemBuilder: (BuildContext context, int _index) {
                      final reversedList = getStocksFromTheImporter?.reversed.toList();
                      return ListTile(
                        title: Text('${reversedList?[_index].title}'
                            ' '
                            '${reversedList?[_index].detailTitle} ${reversedList?[_index].meter} metre'),
                        trailing: context.read<ImporterCubit>().getPurchasedDate(index, _index),
                        subtitle: Text(
                          '${reversedList?[_index].totalAmount} ${state.importers![index].currency?.getSymbol}',
                        ),
                      );
                    },
                  ),
                ),
                Text('Ödemeler'),
                Expanded(
                  child: ListView.builder(
                    itemCount: getPaymentsFromTheImporter?.length ?? 0,
                    itemBuilder: (BuildContext context, int _index) {
                      final reversedList = getPaymentsFromTheImporter?.reversed.toList();
                      return ListTile(
                        title: Text(
                            '${reversedList?[_index].price} ${state.importers![index].currency?.getSymbol} ödeme yapıldı'),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

void _showModal(
  BuildContext context,
  int index, {
  TextEditingController? titleController,
  TextEditingController? detailTitleController,
  TextEditingController? meterController,
  TextEditingController? priceController,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ImporterCubit>.value(
            value: BlocProvider.of<ImporterCubit>(context),
          ),
          BlocProvider.value(
            value: BlocProvider.of<StockCubit>(context)..readId(),
          ),
        ],
        child: BlocBuilder<ImporterCubit, ImporterState>(
          builder: (context, importerState) {
            return BlocBuilder<StockCubit, StockState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration:
                            ProjectInputDecorations.suppliersAdd('Lütfen Ürün Adını Giriniz'),
                        controller: titleController,
                      ),
                      TextField(
                        decoration:
                            ProjectInputDecorations.suppliersAdd('Lütfen Ürün Rengini Giriniz'),
                        controller: detailTitleController,
                      ),
                      TextField(
                        decoration:
                            ProjectInputDecorations.suppliersAdd('Kaç metre aldığınızı giriniz'),
                        controller: meterController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      TextField(
                        decoration:
                            ProjectInputDecorations.suppliersAdd('Ürün alış fiyatını giriniz'),
                        controller: priceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      IconButton(
                        onPressed: () {
                          if (detailTitleController == null) return;
                          if (meterController == null) return;
                          // context.read<ImporterCubit>().addOrUpdatePurchase(
                          //       index,
                          //       StockModel(
                          //           id: state.productId,
                          //           title: titleController?.text,
                          //           stockDetailModel: [],
                          //           purchaseDate: DateTime.now(),
                          //           pPrice: double.tryParse(priceController?.text ?? '0')),
                          //     );
                          if (importerState.importers == null) return;
                          context.read<ImporterCubit>().addPurchaseLogs(
                                index,
                                titleController?.text ?? '',
                                detailTitleController.text,
                                double.tryParse(meterController.text) ?? 0,
                                double.tryParse(priceController?.text ?? '0') ?? 0,
                              );
                          context.read<StockCubit>().addProduct(
                                id: state.productId,
                                StockModel(
                                  id: state.productId,
                                  title: titleController?.text,
                                  stockDetailModel: [],
                                ),
                              );
                          context.read<StockCubit>().addOrUpdateDetailedStock(
                                state.products!.indexWhere(
                                  (element) => element.title == titleController?.text,
                                ),
                                context.read<ImporterCubit>().addToStocksPurchaseDetail(
                                      index,
                                      state.products!.indexWhere(
                                        (element) =>
                                            element.title?.toLowerCase() ==
                                            titleController?.text.toLowerCase(),
                                      ),
                                      detailTitleController.text,
                                      double.tryParse(meterController.text) ?? 0,
                                    ),
                              );
                          // context.read<ImporterCubit>().addPurchaseLogs(index);
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}

class _MySearchDelegate extends SearchDelegate<String> {
  final int importerIndex;
  final ImporterCubit importerCubit;
  final ImporterState importerState;
  final VoidCallback navigateBackButton;
  _MySearchDelegate({
    required this.importerIndex,
    required this.importerCubit,
    required this.importerState,
    required this.navigateBackButton,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return IconButton(onPressed: navigateBackButton, icon: Icon(Icons.navigate_before));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final items = importerState.importers?[importerIndex].purchases.where((element) {
      final result = element.title!.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          itemCount: items?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${items?[index].title}'
                  '${items?[index].detailTitle} ${items?[index].meter} metre'),
              trailing: importerCubit.getPurchasedDate(importerIndex, index),
              subtitle: Text(
                '${items?[index].totalAmount} ${importerState.importers![importerIndex].currency?.getSymbol}',
              ),
            );
          },
        );
      },
    );
  }
}
