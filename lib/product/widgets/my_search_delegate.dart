import 'package:flutter/material.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/widgets/custom_icon.dart';

abstract class MySearchDelegate<T> extends SearchDelegate<T> {
  MySearchDelegate({
    required this.items,
  });
  List<T> items;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
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
