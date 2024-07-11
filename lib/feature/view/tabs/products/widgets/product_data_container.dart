part of '../products_view.dart';

/// Data container for [ProductsView]
class _ProductDataContainer extends StatelessWidget {
  /// constructor for [_ProductDataContainer]
  const _ProductDataContainer({required this.stock, required this.onPressed, super.key});
  final StockModel? stock;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    if (stock == null) return const SizedBox.shrink();
    return Container(
      height: 11.5.h,
      decoration: BoxDecoration(
        color: ProjectColors2.formBackground,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.sp),
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      stock!.title ?? '',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.navigate_next_outlined,
                      size: 30.sp,
                      color: Colors.black.withOpacity(.40),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Renk',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                        ), // TODOLOCALIZATION
                        Text(
                          '${stock!.stockDetailModel.length} Renk', // TODOLOCALIZATION
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Satış Fiyatı',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                        ), // TODOLOCALIZATION
                        Text(
                          '${stock!.sPrice} ${stock!.currency.currencySymbol}', // TODOLOCALIZATION
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Miktar',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                        ), // TODOLOCALIZATION
                        Text(
                          '${stock!.totalMeter}m', //TODOLOCALIZATION
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
