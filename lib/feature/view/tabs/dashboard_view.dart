// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/extensions/string_extension.dart';
import 'package:stokip/product/widgets/line_chart_widget.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    double? monthlyPurchases;
    double? monthlySales;
    final salesCubit = BlocProvider.of<SalesCubit>(context);
    final importerCubit = BlocProvider.of<ImporterCubit>(context);
    @override
    void initState() {
      super.initState();
      monthlyPurchases =
          context.read<ImporterCubit>().updateMonthlyPurchasesAmount(DateTime.now().month);
      monthlySales = context.read<SalesCubit>().updateMonthlySalesAmount(DateTime.now().month);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<SalesCubit>.value(
          value: salesCubit..getSales(),
        ),
        BlocProvider<ImporterCubit>.value(
          value: importerCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfitWidget(
              monthlyPurchases: monthlyPurchases ?? 0,
              monthlySales: monthlySales ?? 0,
            ),
            const SizedBox(
              height: 15,
            ),
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                      top: 30,
                      bottom: 12,
                    ),
                    child: BlocBuilder<ImporterCubit, ImporterState>(
                      builder: (context, importerState) {
                        return BlocBuilder<SalesCubit, SalesState>(
                          builder: (context, salesState) {
                            return LineChartWidget(
                              salesState: salesState,
                              importerState: importerState,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 30,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      ProjectStrings.dashboardMonthlyGraph
                          .locale(), // todo burada ? : ; kullanarak grafiğin haftalık ve aylık versiyonlarını göstericez
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfitWidget extends StatelessWidget {
  const ProfitWidget({
    required this.monthlySales,
    required this.monthlyPurchases,
    Key? key,
  }) : super(key: key);
  final double monthlySales;
  final double monthlyPurchases;
  @override
  Widget build(BuildContext context) {
    double profitMonthly(int currentMonth) {
      return context.read<SalesCubit>().updateMonthlySalesAmount(currentMonth) -
          context.read<ImporterCubit>().updateMonthlyPurchasesAmount(currentMonth);
    }

    bool compareWithLastMonth() {
      if (profitMonthly(DateTime.now().month) > profitMonthly(DateTime.now().month - 1)) {
        return true;
      }
      return false;
    }

    double calculateAverageProfitIncrease() {
      return ((profitMonthly(DateTime.now().month - 1) / 100) *
              profitMonthly(DateTime.now().month)) *
          -1;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${context.read<SalesCubit>().updateMonthlySalesAmount(DateTime.now().month) - context.read<ImporterCubit>().updateMonthlyPurchasesAmount(DateTime.now().month)}',
          style: const TextStyle(
              fontSize: 35, color: Colors.blue), //todo burası tabin rengiyle aynı renk olucak
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                compareWithLastMonth()
                    ? Icons.arrow_circle_up_outlined
                    : Icons.arrow_circle_down_outlined,
                color: compareWithLastMonth() ? Colors.green : Colors.red,
              ),
              Text(
                '${calculateAverageProfitIncrease().toString()}%',
                style: TextStyle(
                  color: compareWithLastMonth() ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
