import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/view/home/home_view_inherited.dart';
import 'package:stokip/product/constants/enums/tabs_enum.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/extensions/tabs_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentState = HomeViewInherited.of(context);
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
            return ImporterCubit()..init;
          },
        ),
        BlocProvider<CustomerCubit>(
          create: (context) {
            return CustomerCubit(
              sales: context.read<SalesCubit>().state.sales ?? [],
            )..init();
          },
        ),
      ],
      // this is the parent widget that will pass the value of the bannerAd to the child widgets
      child: TabView(
        tabIndex: currentState.tabIndex,
        tabController: currentState.tabController,
      ),
    );
  }
}

class TabView extends StatelessWidget {
  const TabView({
    required this.tabIndex,
    required TabController tabController,
    super.key,
  }) : _tabController = tabController;

  final ValueNotifier<int> tabIndex;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Tabs.values.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: Tabs.values.map(
              (e) {
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
        body: Stack(
          children: [
            TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Tabs.dashboard.getPage(),
                Tabs.sales.getPage(),
                Tabs.products.getPage(),
                Tabs.suppliers.getPage(),
              ],
            ),
            const _BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _BannerAdWidget extends StatelessWidget {
  const _BannerAdWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeState = HomeViewInherited.of(context);
    return ValueListenableBuilder(
      valueListenable: homeState.bannerAd,
      builder: (context, value, _) {
        if (value == null) {
          return const SizedBox();
        }
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: value.size.width.toDouble(),
            height: value.size.height.toDouble(),
            child: AdWidget(ad: value),
          ),
        );
      },
    );
  }
}
