import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/product/constants/project_colors.dart';

/// this class is output for data
class DataContainer extends StatelessWidget {
  const DataContainer({required this.data, super.key});
  final SalesModel data;
  @override
  Widget build(BuildContext context) {
    if (data.title == null) return const SizedBox.shrink();
    return Container(
      height: 9.h,
      decoration: BoxDecoration(
        color: ProjectColors2.formBackground,
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.title ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Text(
                      data.customer?.key ?? 'Nakit', //TODO LOCALIZATION
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Tarih', //TODO LOCALIZATION
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                    ),
                    Text(
                      data.dateTime.toString().substring(0, 10),
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
                      'Miktar', //TODO LOCALIZATION
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                    ),
                    Text(
                      '${data.meter}m',
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
                      'Fiyat',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                    ),
                    Text(
                      '${data.price}',
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
                      'Tutar',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                    ),
                    Text(
                      '${data.price! * data.meter!}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
