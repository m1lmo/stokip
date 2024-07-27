part of '../tabs/customer_tab_view.dart';

class _CustomerSearchDelegate<T extends CustomerModel> extends MySearchDelegate<T> with NavigatorManager {
  _CustomerSearchDelegate({required super.items});

  @override
  Widget buildResults(BuildContext context) {
    final result = <CustomerModel?>[];
    for (final item in items!) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        return _CustomerListTile(
          customer: result[index]!,
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = <CustomerModel?>[];
    for (final item in items!) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        return _CustomerListTile(
          customer: result[index]!,
          onTap: () {},
        );
      },
    );
  }
}
