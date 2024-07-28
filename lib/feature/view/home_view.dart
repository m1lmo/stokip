import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/ad/ad_inherited.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
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
  late final ValueNotifier<BannerAd?> bannerAd;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: Tabs.values.length, animationDuration: const Duration(milliseconds: 300));
    _tabController.addListener(() {
      tabIndex.value = _tabController.index;
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    loadAds();
  }

  Future<void> loadAds() async {
    print('load ads triggered');
    bannerAd = ValueNotifier(
      BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-9069954727984208/2913442795',
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('Ad loaded: ${ad.adUnitId}');
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Ad failed to load: ${ad.adUnitId}, $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
      ),
    );
    await bannerAd.value!.load();
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
      child: AdInherited(bannerAd, child: TabView(tabIndex: tabIndex, tabController: _tabController)),
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
    final addInherited = AdInherited.of(context);
    return DefaultTabController(
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
            ValueListenableBuilder(
              valueListenable: addInherited.bannerAd,
              builder: (context, value, _) {
                return Positioned(
                  bottom: 0,
                  left: 88.w - value!.size.width.toDouble(),
                  child: SizedBox(
                    width: value.size.width.toDouble(),
                    height: value.size.height.toDouble(),
                    child: AdWidget(ad: value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
