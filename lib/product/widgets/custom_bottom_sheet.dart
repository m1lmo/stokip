import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/product/extensions/string_extension.dart';

class CustomBottomSheet {
  CustomBottomSheet._();
  static void show(
    BuildContext context, {
    required Widget child,
    required String title,
  }) {
    showModalBottomSheet<Widget>(
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: 35.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toTitleCase(),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 20.sp,
                    ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
