// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/sales/sales_cubit.dart';


class OldSaleLogsView extends StatelessWidget {
  const OldSaleLogsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  salesCubit = SalesCubit()..getSales();
    return BlocProvider<SalesCubit>.value(
      value: salesCubit,
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<SalesCubit, SalesState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.sales?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(state.sales?[index].title ?? ''),
                  subtitle: Text('${state.sales?[index].meter} Metre'),
                  leading: Text(state.sales?[index].meter.toString() ?? ''),
                  trailing: BlocBuilder<SalesCubit, SalesState>(
                    builder: (context, state) {
                      return context.read<SalesCubit>().getSoldTime(index);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
