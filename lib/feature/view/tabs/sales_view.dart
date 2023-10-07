// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/view/old_sale_logs_view.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/navigator_manager.dart';
import 'package:stokip/product/widgets/currency_popup_button.dart';

class SalesView extends StatelessWidget {
  const SalesView({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const _MyPopupMenu();
  }
}

class _MyPopupMenu extends StatelessWidget with NavigatorManager {
  const _MyPopupMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final salesCubit = BlocProvider.of<SalesCubit>(context)..getSales();

    final meterEditingController = TextEditingController();
    final priceEditingController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider<StockCubit>(
          create: (context) => StockCubit()..updateAppBarTitle(ProjectStrings.salesAppBarTitle),
        ),
        BlocProvider.value(
            value: salesCubit
              ..updateSelectedItem(ProjectStrings.pickItem)
              ..updateSelectedSpecificItem(ProjectStrings.pickDetailItem))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<StockCubit, StockState>(
            builder: (context, state) {
              return Text(state.appBarTitle!);
            },
          ),
          actions: [
            Center(child: Text(ProjectStrings.oldLogs)),
            BlocBuilder<SalesCubit, SalesState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      navigateToPage(context, OldSaleLogsView());
                    },
                    icon: const Icon(Icons.navigate_next_outlined));
              },
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: _AddLogToSales(
                meterEditingController: meterEditingController,
                priceEditingController: priceEditingController,
              ),
            ),
            const Divider(
              thickness: 5,
            ),
            Expanded(
              child: LogsListView(),
            ),
          ],
        ),
      ),
    );
  }
}

class LogsListView extends StatelessWidget {
  LogsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final currentMonthSales = context.watch<SalesCubit>().getSalesByMonth(currentDate.month);
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: currentMonthSales?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(currentMonthSales?[index].title ?? ''),
              subtitle: Text(
                  '${currentMonthSales?[index].meter} ${ProjectStrings.meter}, x ${currentMonthSales?[index].price} ${currentMonthSales?[index].currency?.getSymbol} = ${currentMonthSales![index].meter! * (currentMonthSales[index].price ?? 1)}'),
              leading: Text(currentMonthSales[index].meter.toString()),
              trailing: context.read<SalesCubit>().getSoldTime(index),
            );
          },
        );
      },
    );
  }
}

/// The _AddLogToSales class is a StatelessWidget in Dart.
class _AddLogToSales extends StatelessWidget {
  const _AddLogToSales({
    required this.meterEditingController,
    required this.priceEditingController,
    super.key,
  });

  final TextEditingController meterEditingController;
  final TextEditingController priceEditingController;

  void Function()? performSaleButton(
    BuildContext context,
    SalesState salesState,
  ) {
    context.read<SalesCubit>().sold(
          context.read<SalesCubit>().selectedSoldItemIndex ?? 0,
          salesState.selectedSpecific,
          double.tryParse(meterEditingController.text) ?? 0,
          context,
          double.tryParse(priceEditingController.text) ?? 0,
          salesState.currency ?? CurrencyEnum.usd,
        );
    context
        .read<StockCubit>()
        .updateTotalMeter(context.read<SalesCubit>().selectedSoldItemIndex ?? 0);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, salesState) {
        return BlocBuilder<StockCubit, StockState>(
          builder: (context, stockState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ürün adı seçme yeri
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _MyPopupMenuButton<StockModel>(
                          items: stockState.products,
                          value: salesState.selectedItemOnSales ?? ProjectStrings.pickItem),
                    ),
                    // burada selectedıtemOnSales in Daha seçilmemiş haliyken 2. popupın gözükmemesini sağlıyoruz
                    // ürün rengi seçme yeri eğer ürün adı seçilmemiişse buası gözükmez
                    if (salesState.selectedItemOnSales != ProjectStrings.pickItem)
                      Expanded(
                        flex: 2,
                        child: _MyPopupMenuButton<StockDetailModel>(
                            value: salesState.selectedSpecific!,
                            items: stockState
                                .products?[stockState.products!.indexWhere(
                                    (element) => element.title == salesState.selectedItemOnSales)]
                                .stockDetailModel),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (salesState.selectedSpecific != ProjectStrings.pickDetailItem)
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(hintText: ProjectStrings.meter),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: meterEditingController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                          ],
                        ),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),
                    SizedBox(
                      width: 20,
                    ),
                    // ürünleri satış tablosuna ekleme yeri eğer renk seçilmemişse burası gözükmez
                    if (salesState.selectedSpecific != ProjectStrings.pickDetailItem)
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: ProjectStrings.salesPriceHint,
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: priceEditingController,
                        ),
                      ),
                    if (salesState.selectedSpecific != ProjectStrings.pickDetailItem)
                      Expanded(
                        child: CurrencyPopupButton<SalesModel>(
                          salesState: salesState,
                        ),
                      ),
                    if (salesState.selectedSpecific != ProjectStrings.pickDetailItem)
                      Expanded(
                        child: IconButton(
                            onPressed: () => performSaleButton(context, salesState),
                            icon: const Icon(Icons.add)),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}

class _MyPopupMenuButton<T extends MainModel> extends StatelessWidget {
  _MyPopupMenuButton({
    required this.value,
    required this.items,
    super.key,
  });
  final String value;
  final List<T>? items;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        return PopupMenuButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    value,
                    style: const TextStyle(),
                  ),
                ),
                const Icon(Icons.arrow_drop_down_outlined)
              ],
            ),
            itemBuilder: (context) {
              return items
                      ?.map((e) => PopupMenuItem(
                            value: e.title,
                            child: Text(
                              e.title ?? '',
                            ),
                          ))
                      .toList() ??
                  [];
            },
            onSelected: (value) {
              if (value is String && T == StockModel)
                return context.read<SalesCubit>().updateSelectedItem(value);
              if (value is String && T == StockDetailModel)
                return context.read<SalesCubit>().updateSelectedSpecificItem(value);
              if (value is String && T == ImporterModel) return;
            });
      },
    );
  }
}
