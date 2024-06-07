import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/customer_hive_operation.dart';

part 'customer_state.dart';

final class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(const CustomerState());
  final List<CustomerModel> customers = [];
  final databaseOperation = CustomerHiveOperation();

  Future<void> get init async {
    try {
      await DatabaseHiveManager().start();
      await databaseOperation.start();
      if (databaseOperation.box.isEmpty) return;
      customers
        ..addAll(databaseOperation.box.values)
        ..sort((a, b) => a.id.compareTo(b.id));
      emit(state.copyWith(customers: customers));
    } catch (e) {
      print(e);
    }
  }

  void addCustomer(CustomerModel customer) {
    customers.add(customer);
    databaseOperation.addOrUpdateItem(customer);
    emit(state.copyWith(customers: List.from(customers)));
  }
}
