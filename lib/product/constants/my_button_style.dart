import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/product/constants/project_colors.dart';

final class MyButtonStyle extends ButtonStyle {
  static final ButtonStyle loginButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.white),
    elevation: const WidgetStatePropertyAll(5),
    foregroundColor: WidgetStateProperty.all(Colors.black),
    fixedSize: WidgetStatePropertyAll(Size(30.w, 5.h)),
  );
  static final ButtonStyle registerButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(ProjectColors2.scaffoldBackgroundColor),
    elevation: const WidgetStatePropertyAll(5),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    fixedSize: WidgetStatePropertyAll(Size(30.w, 5.h)),
  );
}
