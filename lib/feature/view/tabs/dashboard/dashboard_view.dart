// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/product/constants/project_paddings.dart';

part './widgets/sale_chart_widget.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.delayed(const Duration(milliseconds: 200), () {});
      isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesCubit = BlocProvider.of<SalesCubit>(context);
    final importerCubit = BlocProvider.of<ImporterCubit>(context);

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
        appBar: AppBar(
          title: const Text('Anasayfa'), // TODO   Localization
        ),
        body: Padding(
          padding: ProjectPaddings.mainPadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              const Text('Yıllık Satış Grafiği'),
              SizedBox(
                height: 2.h,
              ),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, _) {
                  return !value
                      ? const _SaleChartWidget()
                      : SizedBox(
                          height: 30.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
