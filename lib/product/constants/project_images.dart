import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// The ProjectImages class contains project Images.
class ProjectImages extends Image {
  /// Images of default user photo
  ProjectImages.defaultUser() : super.asset('${_basePngPath}default-user.png');
  ProjectImages.userPhotoByByte(super.bytes) : super.memory();
  static String get _basePngPath => 'assets/pngs/';
}
