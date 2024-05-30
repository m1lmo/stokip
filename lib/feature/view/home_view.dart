import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/product/constants/enums/tabs_enum.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/extensions/tabs_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
  // bool _swipeIsInProgress = false;
  // final bool _tapIsBeingExecuted = false;
  // final int _selectedIndex = 1;
  // int _prevIndex = 1;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: Tabs.values.length, animationDuration: const Duration(milliseconds: 300));
    // _tabController.animation?.addListener(() {
    //   if (!_tapIsBeingExecuted && !_swipeIsInProgress && (_tabController.offset >= 0.5 || _tabController.offset <= -0.5)) {
    //     // detects if a swipe is being executed. limits set to 0.5 and -0.5 to make sure the swipe gesture triggered
    //     log('swipe  detected');
    //     final newIndex = _tabController.offset > 0 ? _tabController.index + 1 : _tabController.index - 1;
    //     _swipeIsInProgress = true;
    //     _prevIndex = _selectedIndex;
    //     tabIndex.value = _tabController.index;
    //   } else {
    //     if (!_tapIsBeingExecuted &&
    //         _swipeIsInProgress &&
    //         ((_tabController.offset < 0.5 && _tabController.offset > 0) || (_tabController.offset > -0.5 && _tabController.offset < 0))) {
    //       // detects if a swipe is being reversed. the
    //       log('swipe reverse detected');
    //       _swipeIsInProgress = false;
    //       tabIndex.value = _tabController.index;
    //     }
    //   }
    // });
    _tabController.addListener(() {
      tabIndex.value = _tabController.index;
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
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
            final salesCubit = SalesCubit(
              stocks: stocks,
              stockDatabaseOperation: databaseOperation,
            );
            return salesCubit..init;
          },
        ),
        BlocProvider<ImporterCubit>(
          create: (context) {
            return ImporterCubit()
              ..init
              ..getImporters;
          },
        ),
      ],
      child: DefaultTabController(
        length: Tabs.values.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomAppBar(
            child: TabBar(
              tabs: Tabs.values.map(
                (e) {
                  print(e.index);
                  return Center(
                    child: ValueListenableBuilder(
                      valueListenable: tabIndex,
                      builder: (_, tabIndexValue, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              e.getIconData(),
                              color: tabIndexValue == e.index ? ProjectColors2.primaryContainer : Colors.black,
                              size: MediaQuery.of(context).size.width / 20,
                            ),
                            Text(
                              e.tabTitle(),
                              style: TextStyle(color: tabIndexValue == e.index ? ProjectColors2.primaryContainer : Colors.black, fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ).toList(),
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Tabs.dashboard.getPage(),
              Tabs.sales.getPage(),
              Tabs.products.getPage(),
              Tabs.suppliers.getPage(),
            ],
          ),
        ),
      ),
    );
  }
}
