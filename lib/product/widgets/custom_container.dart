import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/product/constants/project_colors.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({required this.text, required this.title, super.key});
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      width: 39.w,
      decoration: BoxDecoration(
        color: ProjectColors2.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: ProjectColors2.primaryContainer,
                ),
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }
}
