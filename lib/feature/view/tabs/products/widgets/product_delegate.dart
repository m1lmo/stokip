// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../products_view.dart';

class _ProductDelegate<T extends StockModel> extends MySearchDelegate<T> with NavigatorManager {
  _ProductDelegate({
    required this.stockCubit,
    required this.salesCubit,
    required super.items,
  });
  final StockCubit stockCubit;
  final SalesCubit salesCubit;
  @override
  Widget buildResults(BuildContext context) {
    final result = <StockModel?>[];
    for (final item in items!) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.isEmpty ? 0 : result.length,
      itemBuilder: (context, index) {
        if (result[index] == null) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: .5.h),
          child: _ProductDataContainer(
            stock: result[index],
            onPressed: () {
              navigateToPageReplaced(
                context,
                ProductsDetailView(
                  stockModel: result[index]!,
                  salesCubit: salesCubit,
                  stockCubit: stockCubit,
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = <StockModel?>[];
    for (final item in items!) {
      if (item.title!.toLowerCase().contains(query.toLowerCase())) {
        result.add(item);
      }
    }
    return ListView.builder(
      itemCount: result.isEmpty ? 0 : result.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: .5.h),
          child: _ProductDataContainer(
            stock: result[index],
            onPressed: () {
              navigateToPageReplaced(
                context,
                ProductsDetailView(
                  stockModel: result[index]!,
                  salesCubit: salesCubit,
                  stockCubit: stockCubit,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
