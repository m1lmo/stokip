import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/stock_model.dart';

/// The class _MyPopupMenuButton<T extends MainModel> is a Dart class that represents a popup menu
/// button.
///
///
//
@immutable
class MainModelPopup<T extends MainModel> extends StatelessWidget {
  const MainModelPopup({
    required this.value,
    required this.items,
    super.key,
  });
  final String value;
  final List<T>? items;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        return PopupMenuButton(
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  value,
                  style: const TextStyle(),
                ),
              ),
              const Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
          itemBuilder: (context) {
            return items
                    ?.map(
                      (e) => PopupMenuItem(
                        value: e.title,
                        child: Text(
                          e.title ?? '',
                        ),
                      ),
                    )
                    .toList() ??
                [];
          },
          onSelected: (value) {
            if (value is String && T == StockModel) {
              return context.read<SalesCubit>().updateSelectedItem(value);
            }
            if (value is String && T == StockDetailModel) {
              return context.read<SalesCubit>().updateSelectedSpecificItem(value);
            }
            if (value is String && T == ImporterModel) return;
          },
        );
      },
    );
  }
}
