import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/product/extensions/tabs_extension.dart';
import '../cubit/importers/importer_cubit.dart';
import '../cubit/sales/sales_cubit.dart';
import '../cubit/stock/stock_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: Tabs.values.length);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StockCubit>(
          create: (context) {
            return StockCubit()..init;
          },
        ),
        BlocProvider<SalesCubit>(
          create: (context) {
            final stocks = context.read<StockCubit>().state.products;
            final databaseOperation = context.read<StockCubit>().databaseOperation;
            SalesCubit stockCubit = SalesCubit(
              stocks: stocks,
              stockDatabaseOperation: databaseOperation,
            );
            return stockCubit..init;
          },
        ),
        BlocProvider<ImporterCubit>(
          create: (context) {
            return ImporterCubit()
              ..init
              ..getImporters;
          },
        )
      ],
      child: DefaultTabController(
        length: Tabs.values.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomAppBar(
            child: TabBar(
              tabs: Tabs.values
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.016),
                        child: Text(
                          e.tabTitle(),
                          style:
                              TextStyle(color: const Color.fromARGB(255, 36, 34, 34), fontSize: 12),
                        ),
                      ))
                  .toList(),
              controller: tabController,
            ),
          ),
          body: TabBarView(controller: tabController, children: [
            Tabs.dashboard.getPage(),
            Tabs.sales.getPage(),
            Tabs.suppliers.getPage(),
            Tabs.products.getPage(),
          ]),
        ),
      ),
    );
  }
}
