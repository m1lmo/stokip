import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/widgets/custom_icon.dart';

/// SearchContainer is a [StatelessWidget] that contains a [TextField] with a prefix icon.
@immutable
final class SearchContainer extends StatelessWidget {
  /// constructor of [SearchContainer]
  const SearchContainer({required this.controller, super.key, this.edgeInsets});
  final TextEditingController controller;

  /// [EdgeInsets] for padding default is [EdgeInsets.symmetric(horizontal: 8.w)]
  final EdgeInsets? edgeInsets;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorHeight: 2.h,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontSize: 12.sp,
          ),
      decoration: const InputDecoration(
        hintText: 'Ara',
        prefixIcon: Icon(CustomIcons.search_5393079, color: ProjectColors2.secondary),
      ),
    );
  }
}
