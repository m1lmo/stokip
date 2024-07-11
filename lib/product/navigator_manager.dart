import 'package:flutter/material.dart';

/// NavigatorManager is a mixin class that contains navigation methods.
mixin NavigatorManager {
  /// navigate to the new page
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<Widget?>(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  /// remove all the previous pages from the stack and navigate to the new page
  void navigateToPageRemoved(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<Widget?>(
        builder: (context) {
          return page;
        },
      ),
      (route) => false,
    );
  }

  /// navigate to the new page and replace the current page
  void navigateToPageReplaced(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<Widget?>(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
