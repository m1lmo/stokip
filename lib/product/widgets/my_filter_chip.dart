import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/mixin/filter_mixin.dart';

@immutable
final class MyFilterChip<T extends FilterModel> extends StatelessWidget {
  const MyFilterChip({
    required this.value,
    // required this.groupValue,
    required this.onChanged,
    super.key,
    this.title,
  });
  final T value;
  // final List<T> groupValue;

  final String? title;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _customRadioButton(context);
  }

  Widget _customRadioButton(BuildContext context) {
    // final isSelected = groupValue.contains(value);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4.h,
      decoration: BoxDecoration(
        color: value.isSelected ? ProjectColors2.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(value),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              widthFactor: 1,
              child: Text(
                title ?? '',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: value.isSelected ? Colors.black : Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
