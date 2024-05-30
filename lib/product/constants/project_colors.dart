import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

final class ProjectColors extends Color {
  ProjectColors._(this.value) : super(value);
  factory ProjectColors.primary() {
    return ProjectColors._(0xFF00687B);
  }
  factory ProjectColors.primaryContainer() {
    return ProjectColors._(0xFFAEECFF);
  }
  factory ProjectColors.secondary() {
    return ProjectColors._(0xFF4B6269);
  }
  factory ProjectColors.formBackground() {
    return ProjectColors._(0xFF07435B);
  }
  factory ProjectColors.grey() {
    return ProjectColors._(0xFFD9D9D9);
  }
  factory ProjectColors.scaffoldBackgroundColor() {
    return ProjectColors._(0xFF001F26);
  }
  @override
  final int value;
}
// static const Color primaryContainer = Color(0xFFAEECFF);
// static const Color secondary = Color(0xFF4B6269);
// static const Color formBackground = Color(0xFF07435B);
// static const Color grey = Color(0xFFD9D9D9);
// static const Color scaffoldBackgroundColor = Color(0xFFD9D9D9);

final class ProjectColors2 {
  ProjectColors2._();
  static const Color primary = Color(0xFF00687B);
  static const Color primaryContainer = Color(0xFFAEECFF);
  static const Color secondary = Color(0xFF4B6269);
  static const Color secondaryContainer = Color(0xFF1E2730);
  static const Color formBackground = Color(0xFF07435B);
  static const Color grey = Color(0xFFD9D9D9);
  static const Color scaffoldBackgroundColor = Color(0xFF001F26);
}
