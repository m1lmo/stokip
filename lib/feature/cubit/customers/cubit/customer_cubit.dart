import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/service/repository/customer_repository.dart';
import 'package:stokip/product/cache/storage_manager.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/customer_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';
import 'package:stokip/product/widgets/c_notify.dart';
import 'package:stokip/test_global.dart' as globals;

part 'customer_state.dart';

final class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit({
    required this.sales,
  }) : super(CustomerState());
  final List<SalesModel> sales;
  final List<CustomerModel> customers = [];
  final databaseOperation = CustomerHiveOperation();
  final dioHelper = DioHelper.instance();
  late final CustomerRepository customerRepository;
  final secureStorage = StorageManager.instance();

  /// init method for [CustomerCubit]
  Future<void> init() async {
    await DatabaseHiveManager().start();
    await databaseOperation.start();
    customerRepository = CustomerRepository(dioHelper.dio);
    if (databaseOperation.box.isNotEmpty && !globals.globalInternetConnection) {
      customers.addAll(databaseOperation.box.values);
    } else {
      final data = await customerRepository.fetchData();
      if (data == null) return;
      for (final item in data) {
        if (item == null) continue;
        customers.add(item);
        // await databaseOperation.addOrUpdateItem(item);
      }
    }
    emit(state.copyWith(customers: customers));
    updateTotalBalanceUSD();
  }

  void addCustomer(CustomerModel customer, BuildContext context) {
    final copyCustomer = customer.copyWith(id: customers.length + 1);
    if (customers.isNotEmpty) {
      if (customers.where((element) => element.title?.toLowerCase() == customer.title?.toLowerCase()).isNotEmpty) {
        return CNotify(
          title: 'Hata',
          message: 'Bu isimde bir müşteri zaten var',
        ).show();
      }
    }
    customerRepository.postData(copyCustomer);
    customers.add(copyCustomer);
    databaseOperation.addOrUpdateItem(copyCustomer);
    updateTotalBalanceUSD();
    return emit(state.copyWith(customers: List.from(customers)));
  }

  void updateCustomerBalance(CustomerModel customer, double balance) {
    customer.balance = (customer.balance ?? 0) + balance;
    databaseOperation.addOrUpdateItem(customer);
    emit(state.copyWith(customers: List.from(customers)));
  }

  void updateCustomerBoughtedProducts() {
    for (final customer in customers) {
      final boughtedProducts = sales.where((element) => element.customer == customer).toList();
      customer.boughtProducts = List.from(boughtedProducts);
      databaseOperation.addOrUpdateItem(customer);
    }
    emit(state.copyWith(customers: List.from(customers)));
  }

  void updateTotalBalanceUSD() {
    final totalBalance = customers.fold<double>(0, (previousValue, element) {
      if (element.currency == CurrencyEnum.usd) return previousValue + (element.balance ?? 0);
      return previousValue;
    });
    return emit(state.copyWith(totalBalance: totalBalance));
  }
}
