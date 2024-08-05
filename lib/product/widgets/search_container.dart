import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/view/home/home_view_inherited.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/custom_icon.dart';

/// SearchContainer is a [StatelessWidget] that contains a [TextField] with a prefix icon.
@immutable
final class SearchContainer<T extends MainModel> extends StatelessWidget {
  /// constructor of [SearchContainer]
  const SearchContainer({required this.delegate, super.key, this.edgeInsets});
  final SearchDelegate<T> delegate;

  /// [EdgeInsets] for padding default is [EdgeInsets.symmetric(horizontal: 8.w)]
  final EdgeInsets? edgeInsets;
  @override
  Widget build(BuildContext context) {
    final homeState = HomeViewInherited.of(context);
    return InkWell(
      onTap: () {
        if (homeState.isInterstitialAdReady) {
          homeState.showInterstitialAd();
        }
        showSearch<T>(context: context, delegate: delegate);
      },
      child: Container(
        height: 5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          border: Border.all(color: ProjectColors2.secondary, width: .5.w),
        ),
        child: Row(
          children: [
            SizedBox(width: 2.w),
            const Icon(
              CustomIcons.search_5393079,
              color: ProjectColors2.secondary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Ara',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ProjectColors2.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
