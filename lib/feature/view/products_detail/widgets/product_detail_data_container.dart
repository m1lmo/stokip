part of '../products_detail_view.dart';

/// Data container for [ProductsView]
class ProductDetailDataContainer extends StatelessWidget {
  /// constructor for [ProductDetailDataContainer]
  const ProductDetailDataContainer({required this.stockDetail, required this.onPressed, required this.totalSale, super.key});
  final StockDetailModel? stockDetail;
  final VoidCallback? onPressed;
  final int? totalSale;
  @override
  Widget build(BuildContext context) {
    if (stockDetail == null) return const SizedBox.shrink();
    return Container(
      height: 8.5.h,
      decoration: BoxDecoration(
        color: ProjectColors2.formBackground,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.sp),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, top: .5.h),
                      child: Text(
                        '${stockDetail?.title?.toCapitalized()}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 12.sp,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Miktar',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                    ),
                              ),
                              Text(
                                '${stockDetail?.meter}m',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Toplam Satış',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                    ),
                              ),
                              Text(
                                totalSale?.toString() ?? '0',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 5.w, top: .5.h),
              //   child: Text(
              //     '${stockDetail?.title?.toCapitalized()}',
              //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              //           fontSize: 12.sp,
              //         ),
              //   ),
              // ),
              IconButton(
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                icon: Icon(
                  CustomIcons.pen_edit,
                  size: 13.sp,
                  color: ProjectColors2.primaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
