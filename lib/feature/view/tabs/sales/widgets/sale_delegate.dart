import 'package:flutter/material.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/product/widgets/data_container.dart';
import 'package:stokip/product/widgets/my_search_delegate.dart';

final class SaleDelegate<T extends SalesModel> extends MySearchDelegate<T> {
  SaleDelegate({required super.items});

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: items.isEmpty ? 0 : items.length,
      itemBuilder: (context, index) {
        return DataContainer(data: items[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: items.isEmpty ? 0 : items.length,
      itemBuilder: (context, index) {
        return DataContainer(data: items[index]);
      },
    );
  }
}
