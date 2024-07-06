import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/product/widgets/data_container.dart';
import 'package:stokip/product/widgets/my_search_delegate.dart';

final class SaleDelegate<T extends SalesModel> extends MySearchDelegate<T> {
  SaleDelegate(this.saleBloc, {required super.items});
  final SalesCubit saleBloc;

  @override
  Widget buildResults(BuildContext context) {
    final result = <SalesModel?>[];
    for (final item in items!) {
      if (item.title!.contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    for (final item in items!) {
      if (item.dateTime.toString().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    for (final item in items!) {
      if (item.customer!.title!.contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.isEmpty ? 0 : result.length,
      itemBuilder: (context, index) {
        if (result[index] == null) return const SizedBox.shrink();
        return DataContainer(saleBloc: saleBloc, data: result[index]!);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = <SalesModel?>[];
    for (final item in items!) {
      if (item.title!.contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    for (final item in items!) {
      if (item.dateTime.toString().contains(query.toLowerCase())) {
        if (!result.contains(item)) result.add(item);
      }
    }
    for (final item in items!) {
      if (item.customer!.title!.contains(query.toLowerCase())) {
        if (!result.contains(item)) result.add(item);
      }
    }

    return ListView.builder(
      itemCount: result.isEmpty ? 0 : result.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: .5.h),
          child: DataContainer(saleBloc: saleBloc, data: result[index]!),
        );
      },
    );
  }
}
