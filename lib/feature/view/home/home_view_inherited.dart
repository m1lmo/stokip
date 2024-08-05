import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stokip/feature/view/home/home_view.dart';
import 'package:stokip/product/constants/enums/tabs_enum.dart';
import 'package:stokip/product/helper/ticker_provider_service.dart';

/// This class is used to pass the state of [HomeViewHost] to [HomeView]
final class HomeViewInherited extends InheritedWidget {
  const HomeViewInherited(this.data, {required super.child, super.key});
  final HomeViewHostState data;

  static HomeViewHostState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HomeViewInherited>();
    if (result != null) {
      return result.data;
    } else {
      throw Exception('HomeViewInherited not found in context');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

/// This class is used to host the state of [HomeView]
class HomeViewHost extends StatefulWidget {
  const HomeViewHost({super.key});

  @override
  State<HomeViewHost> createState() => HomeViewHostState();
}

class HomeViewHostState extends State<HomeViewHost> {
  late final TabController tabController;
  late final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
  late final ValueNotifier<BannerAd?> bannerAd;
  final List<InterstitialAd?> _interstitialAds = [];
  int _showedAdIntersitialAds = 0;
  bool isInterstitialAdReady = false;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: tickerProviderService, length: Tabs.values.length, animationDuration: const Duration(milliseconds: 300));
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      if (tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
    loadBanner();
    _loadInterstitialAd();
  }

  /// This method is used to show the interstitial ad
  /// the maximum number of ads that can be shown is 4
  void showInterstitialAd() {
    if (isInterstitialAdReady) {
      _adCountReset();
      _interstitialAds[0]!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          log('Interstitial ad displayed.');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) async {
          log('Interstitial ad dismissed.');
          await _reloadIntersititialAd(ad);
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) async {
          log('Interstitial ad failed to show: $error');
          await _reloadIntersititialAd(ad);
        },
      );
      _showedAdIntersitialAds++;
      _interstitialAds[0]!.show();
      isInterstitialAdReady = false;
    } else {
      log('Interstitial ad is not ready yet.');
    }
  }

  /// This method is used to reload the interstitial ad
  Future<void> _reloadIntersititialAd(InterstitialAd ad) async {
    await ad.dispose();
    _interstitialAds.removeAt(0);
    await Future.delayed(const Duration(seconds: 15), () {});
    _loadInterstitialAd(); // load new ad
  }

  /// This method is used to reset the ad count
  void _adCountReset() {
    if (_showedAdIntersitialAds == 4) {
      Future.delayed(const Duration(seconds: 60), () {
        _showedAdIntersitialAds = 0;
      });
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9069954727984208/9151849409',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('interversititial ad ${ad.adUnitId} loaded.');
          isInterstitialAdReady = true;
          _interstitialAds.add(ad);
          setState(() {});
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  /// this method is used to load the ads
  /// and set the value of the bannerAd
  Future<void> loadBanner() async {
    print('load ads triggered');
    bannerAd = ValueNotifier(
      BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-9069954727984208/2913442795',
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log('Banner Ad loaded: ${ad.adUnitId}');
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
    return HomeViewInherited(this, child: const HomeView());
  }
}
