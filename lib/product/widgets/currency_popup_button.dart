import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';

/// this class should extend SalesModel or ImporterModel
class CurrencyPopupButton<T extends MainModel> extends StatelessWidget {
  /// The `CurrencyPopupButton` class has a constructor with named parameters. The `const
  /// CurrencyPopupButton({super.key, this.salesState, this.importerState})` is defining the constructor
  /// parameters.
  const CurrencyPopupButton({super.key, this.salesState, this.importerState});
  final SalesState? salesState;
  final ImporterState? importerState;

  @override
  Widget build(BuildContext context) {
    Text popupChild(SalesState? salesState, ImporterState? importerState) {
      if (T == SalesModel && salesState != null) {
        return Text(salesState.currency?.getSymbol ?? r'$');
      } else if (T == ImporterModel && importerState != null) {
        return Text(importerState.selectedCurrency?.getSymbol ?? 'Para Birimini Giriniz');
      } else {
        return const Text('');
      }
    }

    return PopupMenuButton(
      child: popupChild(salesState, importerState),
      itemBuilder: (BuildContext context) {
        return CurrencyEnum.values
            .map(
              (e) => PopupMenuItem(
                value: e,
                child: Text(e.name),
              ),
            )
            .toList();
      },
      onSelected: (value) {
        if (T == SalesModel) {
          context.read<SalesCubit>().updateCurrency(value);
        } else if (T == ImporterModel) {
          context.read<ImporterCubit>().updateSelectedCurrency(value);
          print(value);
        }
      },
    );
  }
}
