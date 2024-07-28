import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This class is used to pass the data of [BannerAd] to Widgets
final class AdInherited extends InheritedWidget {
  /// Constructor for the [AdInherited]
  const AdInherited(this.bannerAd, {required super.child, super.key});

  /// The [BannerAd] to be passed to the Widgets
  /// don't forget to set the value of this variable in the parent widget
  final ValueNotifier<BannerAd?> bannerAd;

  static AdInherited of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AdInherited>();
    if (result != null) {
      return result;
    } else {
      throw Exception('BannerAd not found in context');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
