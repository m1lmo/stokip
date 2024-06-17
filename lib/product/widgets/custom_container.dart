import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/product/constants/project_colors.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({required this.text, required this.title, super.key});
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      enableFeedback: true,
      
      child: Container(
        height: 8.h,
        width: 39.w,
        decoration: BoxDecoration(
          color: ProjectColors2.secondaryContainer,
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                title,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: ProjectColors2.primaryContainer,
                    ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
