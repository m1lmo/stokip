// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/payment_model.dart';
import 'package:stokip/feature/model/purchases_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/project_input_Decorations.dart';
import 'package:stokip/product/constants/project_strings.dart';

class PurchasesView extends StatefulWidget {
  const PurchasesView({
    required this.index,
    required this.importerState,
    required this.importerCubit,
    required this.stockCubit,
    super.key,
  });
  final int index;
  final ImporterState importerState;
  final ImporterCubit importerCubit;
  final StockCubit stockCubit;

  @override
  State<PurchasesView> createState() => _PurchasesViewState();
}

class _PurchasesViewState extends State<PurchasesView> {
  List<PurchasesModel>? get getStocksFromTheImporter {
    return widget.importerState.importers?[widget.index].purchases;
  }

  List<PaymentModel>? get getPaymentsFromTheImporter {
    return widget.importerState.importers?[widget.index].payments;
  }

  late final TextEditingController titleEditingController;
  late final TextEditingController priceEditingController;
  late final TextEditingController meterEditingController;
  late final TextEditingController detailEditingController;
  late final TextEditingController paymentEditingController;
  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController();
    priceEditingController = TextEditingController();
    meterEditingController = TextEditingController();
    detailEditingController = TextEditingController();
    paymentEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleEditingController.dispose();
    priceEditingController.dispose();
    meterEditingController.dispose();
    detailEditingController.dispose();
    paymentEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImporterCubit>.value(
          value: widget.importerCubit,
        ),
        BlocProvider<StockCubit>.value(
          value: widget.stockCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ImporterCubit, ImporterState>(
            builder: (context, state) {
              return Text('${state.importers?[widget.index].title}');
            },
          ),
          actions: [
            BlocBuilder<ImporterCubit, ImporterState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    // showSearch(
                    //   context: context,
                    //   delegate: _MySearchDelegate(
                    //     importerCubit: widget.importerCubit,
                    //     importerState: state,
                    //     importerIndex: widget.index,
                    //     navigateBackButton: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //   ),
                    // );
                  },
                  icon: const Icon(Icons.search),
                );
              },
            ),
            BlocBuilder<ImporterCubit, ImporterState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    _showModal(
                      context,
                      widget.index,
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
                  value: widget.importerCubit,
                  child: AlertDialog(
                    title: Text(ProjectStrings.suppliersPayAlertTitle),
                    actions: [
                      BlocBuilder<ImporterCubit, ImporterState>(
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () {
                              context.read<ImporterCubit>().paymentToIndexedSupplier(
                                    widget.index,
                                    double.parse(paymentEditingController.text),
                                  );
                              context.read<ImporterCubit>().addPaymentLogs(widget.index, double.tryParse(paymentEditingController.text) ?? 0);
                              Navigator.of(context).pop();
                            },
                            child: Text(ProjectStrings.suppliersCompletePayment),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          ProjectStrings.suppliersDenyPayment,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    content: TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: paymentEditingController,
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.blue.shade200,
          child: Text(
            ProjectStrings.pay,
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
                  ProjectStrings.suppliersPurchases,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: getStocksFromTheImporter?.length ?? 0,
                    itemBuilder: (BuildContext context, int _index) {
                      final reversedList = getStocksFromTheImporter?.reversed.toList();
                      return ListTile(
                        title: Text('${reversedList?[_index].title}'
                                ' '
                                '${reversedList?[_index].detailTitle} ${reversedList?[_index].meter} ' +
                            ProjectStrings.meter),
                        trailing: context.read<ImporterCubit>().getPurchasedDate(widget.index, _index),
                        subtitle: Text(
                          '${reversedList?[_index].totalAmount} ${state.importers![widget.index].currency?.getSymbol}',
                        ),
                      );
                    },
                  ),
                ),
                Text(ProjectStrings.suppliersPayments),
                Expanded(
                  child: ListView.builder(
                    itemCount: getPaymentsFromTheImporter?.length ?? 0,
                    itemBuilder: (BuildContext context, int _index) {
                      final reversedList = getPaymentsFromTheImporter?.reversed.toList();
                      return ListTile(
                        title: Text(
                          '${reversedList?[_index].price} ${state.importers![widget.index].currency?.getSymbol} ' + ProjectStrings.suppliersPaymentSuccess,
                        ),
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
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: ProjectInputDecorations.suppliersAdd(
                                ProjectStrings.suppliersHintItem,
                              ),
                              controller: titleController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        decoration: ProjectInputDecorations.suppliersAdd(
                          ProjectStrings.suppliersHintDetailItem,
                        ),
                        controller: detailTitleController,
                      ),
                      TextField(
                        decoration: ProjectInputDecorations.suppliersAdd(
                          ProjectStrings.suppliersHintQuantityMeter,
                        ),
                        controller: meterController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      TextField(
                        decoration: ProjectInputDecorations.suppliersAdd(
                          ProjectStrings.suppliersHintPurchasePrice,
                        ),
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                                        (element) => element.title?.toLowerCase() == titleController?.text.toLowerCase(),
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

///TODO TYPE ILE YAP
///