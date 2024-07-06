import 'package:flutter/material.dart';
import 'package:stokip/product/widgets/custom_icon.dart';

abstract class MySearchDelegate<T> extends SearchDelegate<T> {
  MySearchDelegate({
    required this.items,
  });
  List<T>? items;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const Icon(CustomIcons.search_5393079);
  }

  @override
  Widget buildResults(BuildContext context);

  @override
  Widget buildSuggestions(BuildContext context);
}
