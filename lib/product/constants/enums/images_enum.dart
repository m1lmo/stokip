import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../project_images.dart';

enum ImagesEnum { defaul, selected }

extension ImagesExtension on ImagesEnum {
  ImageProvider getImages(Uint8List? bytes) {
    switch (this) {
      case ImagesEnum.defaul:
        return ProjectImages.defaultUser().image;
      case ImagesEnum.selected:
        if (bytes == null) {
          Exception(
            'bytes parameter is required for ImagesEnum.selected',
          );
        }

        return ProjectImages.userPhotoByByte(bytes!).image;
    }
  }
}
