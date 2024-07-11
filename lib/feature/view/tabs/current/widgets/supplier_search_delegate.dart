part of '../tabs/supplier_tab_view.dart';

final class _SupplierSearchDelegate<T extends ImporterModel> extends MySearchDelegate<T> {
  _SupplierSearchDelegate({required super.items});

  @override
  Widget buildResults(BuildContext context) {
    final result = <ImporterModel?>[];
    for (final item in items!) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.length ?? 0,
      itemBuilder: (context, index) {
        return _ImporterListTile(
          importer: result[index]!,
          // onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = <ImporterModel?>[];
    for (final item in items!) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.length ?? 0,
      itemBuilder: (context, index) {
        return _ImporterListTile(
          importer: result[index]!,
          // onTap: () {},
        );
      },
    );
  }
}
