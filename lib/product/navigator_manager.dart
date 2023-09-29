import 'package:flutter/material.dart';

mixin NavigatorManager {
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<Widget?>(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
